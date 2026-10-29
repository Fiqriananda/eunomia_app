import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/models.dart';

/// Clean, unified, non-repetitive API Client powered by GetxService
class ApiService extends GetxService {
  static ApiService get to => Get.find<ApiService>();

  static const String _defaultUrl = 'https://eunomiaapi.motionlaboratory.com';
  static const String _tokenKey = 'eunomia_auth_token';
  static const String _workspaceKey = 'eunomia_selected_workspace_id';

  final RxString baseUrl = _defaultUrl.obs;
  final RxnString token = RxnString();
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final Rxn<WorkspaceModel> currentWorkspace = Rxn<WorkspaceModel>();
  final RxList<WorkspaceModel> availableWorkspaces = <WorkspaceModel>[].obs;

  bool get isAuthenticated => token.value != null && token.value!.isNotEmpty;

  Future<ApiService> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString(_tokenKey);
      if (storedToken != null && storedToken.isNotEmpty) {
        token.value = storedToken;
      }
    } catch (e) {
      debugPrint('ApiService init error: $e');
    }
    return this;
  }

  String _resolveBaseUrl() {
    String url = baseUrl.value;
    if (!kIsWeb && Platform.isAndroid) {
      if (url.contains('localhost')) {
        url = url.replaceAll('localhost', '10.0.2.2');
      } else if (url.contains('127.0.0.1')) {
        url = url.replaceAll('127.0.0.1', '10.0.2.2');
      }
    }
    return url;
  }


  /// Core request executor eliminating repetitive http/json/header boilerplate
  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? query,
    dynamic body,
  }) async {
    final base = _resolveBaseUrl();
    final cleanPath = path.startsWith('/') ? path : '/$path';
    Uri uri = Uri.parse('$base$cleanPath');

    if (query != null && query.isNotEmpty) {
      final stringParams = <String, String>{};
      query.forEach((key, val) {
        if (val != null && val.toString().isNotEmpty) {
          stringParams[key] = val.toString();
        }
      });
      if (stringParams.isNotEmpty) {
        uri = uri.replace(queryParameters: stringParams);
      }
    }

    final isAuthRoute = cleanPath.startsWith('/auth/login') || cleanPath.startsWith('/auth/register');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (!isAuthRoute && token.value != null && token.value!.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.value}';
    }

    http.Response response;
    final encodedBody = (body != null && body is! String) ? jsonEncode(body) : body;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;
      case 'POST':
        response = await http.post(uri, headers: headers, body: encodedBody);
        break;
      case 'PATCH':
        response = await http.patch(uri, headers: headers, body: encodedBody);
        break;
      case 'PUT':
        response = await http.put(uri, headers: headers, body: encodedBody);
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: headers, body: encodedBody);
        break;
      default:
        throw UnsupportedError('Unsupported HTTP method $method');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return response.body;
      }
    } else {
      if (response.statusCode == 401 && !isAuthRoute) {
        await logout();
        throw Exception('Session expired (401)');
      }

      String errorMessage = 'Request failed (${response.statusCode})';
      try {
        final errJson = jsonDecode(response.body);
        if (errJson is Map && errJson['message'] != null) {
          errorMessage = errJson['message'].toString();
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  // --- Generic DRY helpers ---

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(dynamic data) parser,
  }) async {
    final data = await _send('GET', path, query: query);
    return parser(data);
  }

  Future<T> post<T>(
    String path, {
    dynamic body,
    required T Function(dynamic data) parser,
  }) async {
    final data = await _send('POST', path, body: body);
    return parser(data);
  }

  Future<T> patch<T>(
    String path, {
    dynamic body,
    required T Function(dynamic data) parser,
  }) async {
    final data = await _send('PATCH', path, body: body);
    return parser(data);
  }

  Future<bool> delete(String path, {dynamic body}) async {
    await _send('DELETE', path, body: body);
    return true;
  }

  // ==========================================
  // AUTHENTICATION & WORKSPACE
  // ==========================================

  
  // Device Token / Push Notification Sync
  Future<bool> registerDeviceToken(String fcmToken) {
    return post(
      '/mobile/device-token',
      body: {
        'token': fcmToken,
        'platform': !kIsWeb && Platform.isAndroid ? 'android' : 'ios',
      },
      parser: (_) => true,
    );
  }

  Future<bool> unregisterDeviceToken(String fcmToken) {
    return post(
      '/mobile/notifications/unregister-token',
      body: {
        'token': fcmToken,
      },
      parser: (_) => true,
    );
  }

  Future<void> syncCurrentFcmToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await registerDeviceToken(fcmToken);
        debugPrint('FCM Token successfully synced to backend');
      }
    } catch (e) {
      debugPrint('Failed to sync FCM token to backend: $e');
    }
  }

  Future<bool> checkAuth() async {
    if (token.value == null || token.value!.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_tokenKey);
      if (saved == null || saved.isEmpty) return false;
      token.value = saved;
    }
    try {
      final data = await _send('GET', '/auth/me');
      if (data != null && data is Map<String, dynamic>) {
        currentUser.value = UserModel(
          id: data['id']?.toString() ?? '',
          name: data['name']?.toString() ?? '',
          email: data['email']?.toString() ?? '',
          avatarUrl: data['avatarUrl']?.toString(),
        );

        if (data['workspaces'] != null && (data['workspaces'] as List).isNotEmpty) {
          final List<WorkspaceModel> wsList = [];
          for (final item in (data['workspaces'] as List)) {
            if (item is Map<String, dynamic>) {
              final wsData = item['workspace'] is Map<String, dynamic>
                  ? item['workspace'] as Map<String, dynamic>
                  : item;
              final role = item['role']?.toString();
              wsList.add(WorkspaceModel.fromJson(wsData, role: role));
            }
          }
          availableWorkspaces.assignAll(wsList);

          final prefs = await SharedPreferences.getInstance();
          final savedWsId = prefs.getString(_workspaceKey);
          if (savedWsId != null && wsList.any((w) => w.id == savedWsId)) {
            currentWorkspace.value = wsList.firstWhere((w) => w.id == savedWsId);
          } else if (wsList.isNotEmpty) {
            currentWorkspace.value = wsList.first;
          }
        }
        syncCurrentFcmToken();
        return true;
      }
      return false;
    } catch (_) {
      await logout();
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    final data = await post('/auth/login', body: {'email': email, 'password': password}, parser: (d) => d);
    if (data is Map<String, dynamic>) {
      final tk = data['token']?.toString() ?? data['accessToken']?.toString() ?? '';
      if (tk.isNotEmpty) {
        token.value = tk;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, tk);

        if (data['user'] != null) {
          currentUser.value = UserModel.fromJson(data['user']);
        }
        if (data['workspace'] != null) {
          currentWorkspace.value = WorkspaceModel.fromJson(data['workspace']);
        } else {
          await checkAuth();
        }
        await syncCurrentFcmToken();
        return true;
      }
    }
    return false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final data = await post(
      '/auth/register',
      body: {'email': email, 'password': password, 'name': name},
      parser: (d) => d,
    );
    if (data is Map<String, dynamic>) {
      final tk = data['token']?.toString() ?? data['accessToken']?.toString() ?? '';
      if (tk.isNotEmpty) {
        token.value = tk;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, tk);

        if (data['user'] != null) {
          currentUser.value = UserModel.fromJson(data['user']);
        }
        if (data['workspace'] != null) {
          currentWorkspace.value = WorkspaceModel.fromJson(data['workspace']);
        } else {
          await checkAuth();
        }
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await unregisterDeviceToken(fcmToken);
      }
    } catch (_) {}

    token.value = null;
    currentUser.value = null;
    currentWorkspace.value = null;
    availableWorkspaces.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_workspaceKey);
    } catch (_) {}
  }

  Future<void> switchWorkspace(WorkspaceModel ws) async {
    currentWorkspace.value = ws;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_workspaceKey, ws.id);
    } catch (_) {}
  }

  // MOBILE HOME & DASHBOARD

  Future<HomeDataModel> getMobileHome({String? workspaceId}) {
    return get(
      '/mobile/home',
      query: {'workspaceId': workspaceId},
      parser: (data) => HomeDataModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ==========================================
  // TASKS
  // ==========================================

  Future<List<TaskModel>> getMobileTasks({
    String filter = 'all',
    String? status,
    String? priority,
    String? projectId,
    String? assigneeId,
    String? cycleId,
    String? search,
    int page = 1,
    int limit = 100,
  }) {
    return get(
      '/mobile/tasks',
      query: {
        'filter': filter,
        'status': status,
        'priority': priority,
        'projectId': projectId,
        'assigneeId': assigneeId,
        'cycleId': cycleId,
        'search': search,
        'page': page,
        'limit': limit,
      },
      parser: (data) {
        if (data is Map && data['items'] is List) {
          return (data['items'] as List).map((e) => TaskModel.fromJson(e)).toList();
        } else if (data is List) {
          return data.map((e) => TaskModel.fromJson(e)).toList();
        }
        return <TaskModel>[];
      },
    );
  }

  Future<TaskModel> getMobileTaskDetail(String taskId) {
    return get(
      '/mobile/tasks/$taskId',
      parser: (data) => TaskModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<TaskModel?> createTask({
    required String title,
    String? description,
    String? status,
    String? priority,
    String? projectId,
    String? cycleId,
    List<String>? labels,
  }) {
    return post(
      '/mobile/tasks',
      body: {
        'title': title,
        'description': ?description,
        'status': ?status,
        'priority': ?priority,
        'projectId': ?projectId,
        'cycleId': ?cycleId,
        'labels': ?labels,
      },
      parser: (data) => data != null ? TaskModel.fromJson(data) : null,
    );
  }

  Future<bool> updateTaskStatus(String id, String status) {
    return patch(
      '/mobile/tasks/$id/status',
      body: {'status': status},
      parser: (_) => true,
    );
  }

  Future<bool> updateTaskPriority(String id, String priority) {
    return patch(
      '/mobile/tasks/$id/priority',
      body: {'priority': priority},
      parser: (_) => true,
    );
  }

  Future<bool> updateTaskAssignee(String id, String? assigneeId) {
    return patch(
      '/mobile/tasks/$id/assignee',
      body: {'assigneeId': assigneeId},
      parser: (_) => true,
    );
  }

  Future<bool> updateTaskCycle(String id, String? cycleId) {
    return patch(
      '/mobile/tasks/$id/cycle',
      body: {'cycleId': cycleId},
      parser: (_) => true,
    );
  }

  Future<TaskModel?> updateTask(
    String id, {
    String? title,
    String? description,
    String? status,
    String? priority,
    String? assigneeId,
    String? cycleId,
    String? dueDate,
    List<String>? labels,
  }) {
    return patch(
      '/mobile/tasks/$id',
      body: {
        'title': ?title,
        'description': ?description,
        'status': ?status,
        'priority': ?priority,
        'assigneeId': ?assigneeId,
        'cycleId': ?cycleId,
        'dueDate': ?dueDate,
        'labels': ?labels,
      },
      parser: (data) => data != null ? TaskModel.fromJson(data) : null,
    );
  }

  Future<bool> deleteTask(String id) => delete('/mobile/tasks/$id');

  // Subtasks
  Future<List<SubtaskItem>> getSubtasks(String taskId) {
    return get(
      '/mobile/tasks/$taskId/subtasks',
      parser: (data) => (data is List) ? data.map((e) => SubtaskItem.fromJson(e)).toList() : [],
    );
  }

  Future<SubtaskItem?> createSubtask(String taskId, String title) {
    return post(
      '/mobile/tasks/$taskId/subtasks',
      body: {'title': title},
      parser: (data) => data != null ? SubtaskItem.fromJson(data) : null,
    );
  }

  // Comments & Reactions
  Future<List<CommentItem>> getComments(String taskId) {
    return get(
      '/mobile/tasks/$taskId/comments',
      parser: (data) => (data is List) ? data.map((e) => CommentItem.fromJson(e)).toList() : [],
    );
  }

  Future<CommentItem?> addComment(String taskId, String content) {
    return post(
      '/mobile/tasks/$taskId/comments',
      body: {'content': content},
      parser: (data) => data != null ? CommentItem.fromJson(data) : null,
    );
  }

  Future<bool> toggleTaskReaction(String taskId, String emoji) {
    return post(
      '/mobile/tasks/$taskId/reactions',
      body: {'emoji': emoji},
      parser: (_) => true,
    );
  }

  Future<bool> toggleCommentReaction(String taskId, String commentId, String emoji) {
    return post(
      '/mobile/tasks/$taskId/comments/$commentId/reactions',
      body: {'emoji': emoji},
      parser: (_) => true,
    );
  }

  // ==========================================
  // CYCLES & PROJECTS
  // ==========================================

  Future<List<CycleModel>> getCycles({String? workspaceId}) {
    return get(
      '/mobile/cycles',
      query: {'workspaceId': workspaceId},
      parser: (data) => (data is List) ? data.map((e) => CycleModel.fromJson(e)).toList() : [],
    );
  }

  Future<CycleModel?> getCurrentCycle({String? workspaceId}) {
    return get(
      '/mobile/cycles/current',
      query: {'workspaceId': workspaceId},
      parser: (data) => (data != null && data is Map<String, dynamic>) ? CycleModel.fromJson(data) : null,
    );
  }

  Future<List<ProjectModel>> getProjects({String? workspaceId}) {
    return get(
      '/mobile/projects',
      query: {'workspaceId': workspaceId},
      parser: (data) => (data is List) ? data.map((e) => ProjectModel.fromJson(e)).toList() : [],
    );
  }

  // ==========================================
  // TRASH
  // ==========================================

  Future<List<TaskModel>> getTrash({int page = 1, int limit = 50}) {
    return get(
      '/mobile/trash',
      query: {'page': page, 'limit': limit},
      parser: (data) {
        if (data is Map && data['items'] is List) {
          return (data['items'] as List).map((e) => TaskModel.fromJson(e)).toList();
        }
        return <TaskModel>[];
      },
    );
  }

  Future<bool> restoreTrash(String id) {
    return post('/mobile/trash/$id/restore', parser: (_) => true);
  }

  Future<bool> permanentDeleteTask(String id) => delete('/mobile/trash/$id');

  // ==========================================
  // WORKSPACE MEMBERS & SEARCH
  // ==========================================

  Future<List<WorkspaceMemberModel>> getWorkspaceMembers(String workspaceId) {
    return get(
      '/mobile/workspaces/$workspaceId/members',
      parser: (data) => (data is List) ? data.map((e) => WorkspaceMemberModel.fromJson(e)).toList() : [],
    );
  }

  Future<UserHoverCardModel?> getUserHoverCard(String userId) {
    return get(
      '/mobile/users/$userId/hover-card',
      parser: (data) => (data != null && data is Map<String, dynamic>) ? UserHoverCardModel.fromJson(data) : null,
    );
  }

  Future<SearchResultsModel> searchMobile(String query) {
    if (query.trim().isEmpty) return Future.value(const SearchResultsModel());
    return get(
      '/mobile/search',
      query: {'q': query},
      parser: (data) => (data != null && data is Map<String, dynamic>) ? SearchResultsModel.fromJson(data) : const SearchResultsModel(),
    );
  }

  // ==========================================
  // NOTIFICATIONS
  // ==========================================

  Future<List<NotificationItem>> getNotifications({bool? unreadOnly}) {
    return get(
      '/mobile/notifications',
      query: {'unreadOnly': unreadOnly},
      parser: (data) {
        dynamic notifs = data;
        if (data is Map) {
          if (data['notifications'] != null) {
            notifs = data['notifications'];
            if (notifs is Map && notifs['notifications'] is List) {
              notifs = notifs['notifications'];
            }
          } else if (data['items'] is List) {
            notifs = data['items'];
          }
        }
        if (notifs is List) {
          return notifs
              .whereType<Map<String, dynamic>>()
              .map((e) => NotificationItem.fromJson(e))
              .toList();
        }
        return <NotificationItem>[];
      },
    );
  }

  Future<bool> markNotificationRead(String id) {
    return patch('/mobile/notifications/$id/read', parser: (_) => true);
  }

  Future<bool> markAllNotificationsRead() {
    return post('/mobile/notifications/read-all', parser: (_) => true);
  }

  // ==========================================
  // ADMIN PERFORMANCE
  // ==========================================

  Future<AdminPerformanceModel> getAdminPerformance({String? workspaceId, String period = 'all'}) {
    return get(
      '/mobile/admin/performance',
      query: {'workspaceId': workspaceId, 'period': period},
      parser: (data) => AdminPerformanceModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
