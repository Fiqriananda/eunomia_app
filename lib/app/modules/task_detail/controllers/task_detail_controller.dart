import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';

class TaskDetailController extends GetxController {
  final ApiService api = ApiService.to;

  late final String taskId;
  final task = Rxn<TaskModel>();
  final subtasks = <SubtaskItem>[].obs;
  final comments = <CommentItem>[].obs;
  final members = <WorkspaceMemberModel>[].obs;
  final isLoading = false.obs;

  final commentController = TextEditingController();
  final commentFocusNode = FocusNode();

  final showMentionOverlay = false.obs;
  final mentionQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['taskId'] != null) {
      taskId = args['taskId'].toString();
    } else {
      taskId = Get.parameters['id'] ?? '';
    }
    commentController.addListener(_onCommentTextChanged);
    if (taskId.isNotEmpty) {
      fetchDetail();
      fetchMembers();
    }
  }

  @override
  void onClose() {
    commentController.removeListener(_onCommentTextChanged);
    commentController.dispose();
    commentFocusNode.dispose();
    super.onClose();
  }

  void _onCommentTextChanged() {
    final text = commentController.text;
    final selection = commentController.selection;
    final offset = selection.baseOffset >= 0 ? selection.baseOffset : text.length;
    if (offset <= 0) {
      showMentionOverlay.value = false;
      return;
    }
    final textBeforeCursor = text.substring(0, offset);
    final lastAt = textBeforeCursor.lastIndexOf('@');
    if (lastAt != -1) {
      final query = textBeforeCursor.substring(lastAt + 1);
      if (!query.contains(' ') && !query.contains('\n')) {
        mentionQuery.value = query.toLowerCase();
        showMentionOverlay.value = true;
        return;
      }
    }
    showMentionOverlay.value = false;
  }

  List<WorkspaceMemberModel> get filteredMembers {
    final q = mentionQuery.value.trim().toLowerCase();
    if (q.isEmpty) return members;
    return members.where((m) {
      final name = m.user?.name.toLowerCase() ?? '';
      final email = m.user?.email.toLowerCase() ?? '';
      return name.contains(q) || email.contains(q);
    }).toList();
  }

  void insertMention(WorkspaceMemberModel member) {
    final name = member.user?.name ?? 'member';
    final text = commentController.text;
    final selection = commentController.selection;
    final offset = selection.baseOffset >= 0 ? selection.baseOffset : text.length;
    final textBeforeCursor = text.substring(0, offset);
    final lastAt = textBeforeCursor.lastIndexOf('@');
    if (lastAt != -1) {
      final before = text.substring(0, lastAt);
      final after = text.substring(offset);
      final replacement = '@$name ';
      commentController.text = '$before$replacement$after';
      commentController.selection = TextSelection.collapsed(
        offset: before.length + replacement.length,
      );
    } else {
      final replacement = '@$name ';
      commentController.text = '$text$replacement';
      commentController.selection = TextSelection.collapsed(
        offset: commentController.text.length,
      );
    }
    showMentionOverlay.value = false;
    commentFocusNode.requestFocus();
  }

  void triggerMention() {
    final text = commentController.text;
    final prefix = text.isEmpty || text.endsWith(' ') ? '' : ' ';
    commentController.text = '$text$prefix@';
    commentController.selection = TextSelection.collapsed(
      offset: commentController.text.length,
    );
    commentFocusNode.requestFocus();
    _onCommentTextChanged();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    try {
      final t = await api.getMobileTaskDetail(taskId);
      task.value = t;
      subtasks.assignAll(t.subtasks);
      comments.assignAll(t.comments);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMembers() async {
    try {
      final list = await api.getWorkspaceMembers();
      members.assignAll(list);
    } catch (_) {}
  }

  Future<void> updateStatus(TaskStatusEnum newStatus) async {
    if (task.value == null) return;
    task.value = task.value!.copyWith(status: newStatus);
    await api.updateTaskStatus(taskId, newStatus.apiKey);
    _refreshParentControllers();
  }

  Future<void> updatePriority(TaskPriorityEnum newPriority) async {
    if (task.value == null) return;
    task.value = task.value!.copyWith(priority: newPriority);
    await api.updateTaskPriority(taskId, newPriority.apiKey);
    _refreshParentControllers();
  }

  Future<void> updateAssignee(String? newAssigneeId) async {
    if (task.value == null) return;
    try {
      await api.updateTaskAssignee(taskId, newAssigneeId);
      UserModel? newAssignee;
      if (newAssigneeId != null) {
        final m = members.firstWhereOrNull((mem) => mem.userId == newAssigneeId);
        newAssignee = m?.user;
      }
      task.value = task.value!.copyWith(assignee: newAssignee);
      _refreshParentControllers();
    } catch (_) {}
  }

  Future<bool> editTask({
    required String title,
    String? description,
    TaskStatusEnum? status,
    TaskPriorityEnum? priority,
    String? assigneeId,
  }) async {
    if (title.trim().isEmpty) return false;
    try {
      final updated = await api.updateTask(
        taskId,
        title: title.trim(),
        description: description?.trim().isEmpty == true ? null : description?.trim(),
        status: status?.apiKey,
        priority: priority?.apiKey,
        assigneeId: assigneeId,
      );

      if (updated != null) {
        task.value = updated;
      } else {
        UserModel? newAssignee;
        if (assigneeId != null) {
          final m = members.firstWhereOrNull((mem) => mem.userId == assigneeId);
          newAssignee = m?.user;
        }
        task.value = task.value!.copyWith(
          title: title.trim(),
          description: description?.trim().isEmpty == true ? null : description?.trim(),
          status: status ?? task.value!.status,
          priority: priority ?? task.value!.priority,
          assignee: newAssignee,
        );
      }
      _refreshParentControllers();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save issue: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surface3,
        colorText: AppColors.textPrimary,
      );
      return false;
    }
  }

  void _refreshParentControllers() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().fetchHomeData();
    }
    if (Get.isRegistered<TasksController>()) {
      Get.find<TasksController>().fetchTasks();
    }
  }

  Future<void> addSubtask(String title) async {
    if (title.trim().isEmpty) return;
    final item = await api.createSubtask(taskId, title.trim());
    if (item != null) {
      subtasks.add(item);
    }
  }

  Future<void> sendComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) return;
    commentController.clear();
    showMentionOverlay.value = false;
    final item = await api.addComment(taskId, content);
    if (item != null) {
      comments.insert(0, item);
    }
  }

  Future<void> toggleReaction(String emoji) async {
    await api.toggleTaskReaction(taskId, emoji);
    fetchDetail();
  }

  Future<void> deleteTask() async {
    await api.deleteTask(taskId);
    _refreshParentControllers();
    Get.back(result: true);
  }
}
