import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/icons/app_svg_icons.dart';

enum TaskStatusEnum {
  backlog,
  todo,
  inProgress,
  done,
  canceled;

  static TaskStatusEnum fromString(String? val) {
    switch (val?.toUpperCase()) {
      case 'BACKLOG':
        return TaskStatusEnum.backlog;
      case 'TODO':
        return TaskStatusEnum.todo;
      case 'IN_PROGRESS':
        return TaskStatusEnum.inProgress;
      case 'DONE':
        return TaskStatusEnum.done;
      case 'CANCELED':
        return TaskStatusEnum.canceled;
      default:
        return TaskStatusEnum.todo;
    }
  }

  String get apiKey {
    switch (this) {
      case TaskStatusEnum.backlog:
        return 'BACKLOG';
      case TaskStatusEnum.todo:
        return 'TODO';
      case TaskStatusEnum.inProgress:
        return 'IN_PROGRESS';
      case TaskStatusEnum.done:
        return 'DONE';
      case TaskStatusEnum.canceled:
        return 'CANCELED';
    }
  }

  String get label {
    switch (this) {
      case TaskStatusEnum.backlog:
        return 'Backlog';
      case TaskStatusEnum.todo:
        return 'Todo';
      case TaskStatusEnum.inProgress:
        return 'In Progress';
      case TaskStatusEnum.done:
        return 'Done';
      case TaskStatusEnum.canceled:
        return 'Canceled';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatusEnum.backlog:
        return AppColors.statusBacklog;
      case TaskStatusEnum.todo:
        return AppColors.statusTodo;
      case TaskStatusEnum.inProgress:
        return AppColors.statusInProgress;
      case TaskStatusEnum.done:
        return AppColors.statusDone;
      case TaskStatusEnum.canceled:
        return AppColors.statusCanceled;
    }
  }

  String get svgIcon {
    switch (this) {
      case TaskStatusEnum.backlog:
        return AppSvgIcons.statusBacklog;
      case TaskStatusEnum.todo:
        return AppSvgIcons.statusTodo;
      case TaskStatusEnum.inProgress:
        return AppSvgIcons.statusInProgress;
      case TaskStatusEnum.done:
        return AppSvgIcons.statusDone;
      case TaskStatusEnum.canceled:
        return AppSvgIcons.statusCanceled;
    }
  }
}

enum TaskPriorityEnum {
  noPriority,
  low,
  medium,
  high,
  urgent;

  static TaskPriorityEnum fromString(String? val) {
    switch (val?.toUpperCase()) {
      case 'NO_PRIORITY':
        return TaskPriorityEnum.noPriority;
      case 'LOW':
        return TaskPriorityEnum.low;
      case 'MEDIUM':
        return TaskPriorityEnum.medium;
      case 'HIGH':
        return TaskPriorityEnum.high;
      case 'URGENT':
        return TaskPriorityEnum.urgent;
      default:
        return TaskPriorityEnum.noPriority;
    }
  }

  String get apiKey {
    switch (this) {
      case TaskPriorityEnum.noPriority:
        return 'NO_PRIORITY';
      case TaskPriorityEnum.low:
        return 'LOW';
      case TaskPriorityEnum.medium:
        return 'MEDIUM';
      case TaskPriorityEnum.high:
        return 'HIGH';
      case TaskPriorityEnum.urgent:
        return 'URGENT';
    }
  }

  String get label {
    switch (this) {
      case TaskPriorityEnum.noPriority:
        return 'No Priority';
      case TaskPriorityEnum.low:
        return 'LOW';
      case TaskPriorityEnum.medium:
        return 'MED';
      case TaskPriorityEnum.high:
        return 'HIGH';
      case TaskPriorityEnum.urgent:
        return 'URGENT';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriorityEnum.noPriority:
        return AppColors.priorityNone;
      case TaskPriorityEnum.low:
        return AppColors.priorityLow;
      case TaskPriorityEnum.medium:
        return AppColors.priorityMedium;
      case TaskPriorityEnum.high:
        return AppColors.priorityHigh;
      case TaskPriorityEnum.urgent:
        return AppColors.priorityUrgent;
    }
  }

  String get svgIcon {
    switch (this) {
      case TaskPriorityEnum.noPriority:
        return AppSvgIcons.priorityNone;
      case TaskPriorityEnum.low:
        return AppSvgIcons.priorityLow;
      case TaskPriorityEnum.medium:
        return AppSvgIcons.priorityMedium;
      case TaskPriorityEnum.high:
        return AppSvgIcons.priorityHigh;
      case TaskPriorityEnum.urgent:
        return AppSvgIcons.priorityUrgent;
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'User',
      email: json['email']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}

class WorkspaceModel {
  final String id;
  final String name;
  final String slug;
  final String? role;
  final bool cyclesEnabled;

  const WorkspaceModel({
    required this.id,
    required this.name,
    required this.slug,
    this.role,
    this.cyclesEnabled = false,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json, {String? role}) {
    return WorkspaceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Workspace',
      slug: json['slug']?.toString() ?? '',
      role: role ?? json['role']?.toString(),
      cyclesEnabled: json['cyclesEnabled'] == true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkspaceModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ProjectModel {
  final String id;
  final String name;
  final String key;
  final String? color;
  final int taskCount;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.key,
    this.color,
    this.taskCount = 0,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Project',
      key: json['key']?.toString() ?? 'PRJ',
      color: json['color']?.toString() ?? '#5e6ad2',
      taskCount: (json['taskCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class SubtaskItem {
  final String id;
  final String identifier;
  final String title;
  final TaskStatusEnum status;
  final TaskPriorityEnum priority;
  final UserModel? assignee;

  const SubtaskItem({
    required this.id,
    required this.identifier,
    required this.title,
    required this.status,
    required this.priority,
    this.assignee,
  });

  bool get isCompleted => status == TaskStatusEnum.done;

  factory SubtaskItem.fromJson(Map<String, dynamic> json) {
    return SubtaskItem(
      id: json['id']?.toString() ?? '',
      identifier: json['identifier']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      status: TaskStatusEnum.fromString(json['status']?.toString()),
      priority: TaskPriorityEnum.fromString(json['priority']?.toString()),
      assignee: json['assignee'] != null ? UserModel.fromJson(json['assignee']) : null,
    );
  }
}

class CommentItem {
  final String id;
  final String content;
  final String createdAt;
  final UserModel? user;
  final String? roleBadge;
  final String? reaction;
  final int reactionCount;

  const CommentItem({
    required this.id,
    required this.content,
    required this.createdAt,
    this.user,
    this.roleBadge,
    this.reaction,
    this.reactionCount = 0,
  });

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return CommentItem(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      roleBadge: json['roleBadge']?.toString(),
      reaction: json['reaction']?.toString(),
      reactionCount: (json['reactionCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class AttachmentItem {
  final String id;
  final String filename;
  final String originalName;
  final String? mimeType;
  final int size;
  final String url;
  final String? createdAt;

  const AttachmentItem({
    required this.id,
    required this.filename,
    required this.originalName,
    this.mimeType,
    required this.size,
    required this.url,
    this.createdAt,
  });

  factory AttachmentItem.fromJson(Map<String, dynamic> json) {
    return AttachmentItem(
      id: json['id']?.toString() ?? '',
      filename: json['filename']?.toString() ?? '',
      originalName: json['originalName']?.toString() ?? 'attachment',
      mimeType: json['mimeType']?.toString(),
      size: (json['size'] as num?)?.toInt() ?? 0,
      url: json['url']?.toString() ?? '',
      createdAt: json['createdAt']?.toString(),
    );
  }
}

class TaskModel {
  final String id;
  final String identifier;
  final String title;
  final String? description;
  final TaskStatusEnum status;
  final String? customStatus;
  final TaskPriorityEnum priority;
  final String? dueDate;
  final List<String> labels;
  final ProjectModel? project;
  final UserModel? assignee;
  final UserModel? creator;
  final int subtasksCount;
  final int subtasksCompletedCount;
  final int commentsCount;
  final int attachmentsCount;
  final String createdAt;
  final String updatedAt;
  final List<SubtaskItem> subtasks;
  final List<CommentItem> comments;
  final List<AttachmentItem> attachments;
  final String? blockedByInfo;
  final String? cycleId;
  final CycleModel? cycle;
  final String? workspaceId;

  const TaskModel({
    required this.id,
    required this.identifier,
    required this.title,
    this.description,
    required this.status,
    this.customStatus,
    required this.priority,
    this.dueDate,
    this.labels = const [],
    this.project,
    this.assignee,
    this.creator,
    this.subtasksCount = 0,
    this.subtasksCompletedCount = 0,
    this.commentsCount = 0,
    this.attachmentsCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.subtasks = const [],
    this.comments = const [],
    this.attachments = const [],
    this.blockedByInfo,
    this.cycleId,
    this.cycle,
    this.workspaceId,
  });

  bool get isCompleted => status == TaskStatusEnum.done;

  TaskModel copyWith({
    String? id,
    String? identifier,
    String? title,
    String? description,
    TaskStatusEnum? status,
    String? customStatus,
    TaskPriorityEnum? priority,
    String? dueDate,
    List<String>? labels,
    ProjectModel? project,
    UserModel? assignee,
    UserModel? creator,
    int? subtasksCount,
    int? subtasksCompletedCount,
    int? commentsCount,
    int? attachmentsCount,
    String? createdAt,
    String? updatedAt,
    List<SubtaskItem>? subtasks,
    List<CommentItem>? comments,
    List<AttachmentItem>? attachments,
    String? blockedByInfo,
    String? cycleId,
    CycleModel? cycle,
    bool clearCycle = false,
    String? workspaceId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      customStatus: customStatus ?? this.customStatus,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      labels: labels ?? this.labels,
      project: project ?? this.project,
      assignee: assignee ?? this.assignee,
      creator: creator ?? this.creator,
      subtasksCount: subtasksCount ?? this.subtasksCount,
      subtasksCompletedCount: subtasksCompletedCount ?? this.subtasksCompletedCount,
      commentsCount: commentsCount ?? this.commentsCount,
      attachmentsCount: attachmentsCount ?? this.attachmentsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subtasks: subtasks ?? this.subtasks,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
      blockedByInfo: blockedByInfo ?? this.blockedByInfo,
      cycleId: clearCycle ? null : (cycleId ?? this.cycleId),
      cycle: clearCycle ? null : (cycle ?? this.cycle),
      workspaceId: workspaceId ?? this.workspaceId,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final subtasksList = <SubtaskItem>[];
    if (json['subtasks'] is List) {
      for (final st in json['subtasks']) {
        subtasksList.add(SubtaskItem.fromJson(st));
      }
    } else if (json['subTasks'] is List) {
      for (final st in json['subTasks']) {
        subtasksList.add(SubtaskItem.fromJson(st));
      }
    }

    final commentsList = <CommentItem>[];
    if (json['comments'] is List) {
      for (final c in json['comments']) {
        commentsList.add(CommentItem.fromJson(c));
      }
    }

    final attachmentsList = <AttachmentItem>[];
    if (json['attachments'] is List) {
      for (final a in json['attachments']) {
        attachmentsList.add(AttachmentItem.fromJson(a));
      }
    }

    final rawLabels = json['labels'];
    final labels = <String>[];
    if (rawLabels is List) {
      for (final l in rawLabels) {
        labels.add(l.toString());
      }
    }

    return TaskModel(
      id: json['id']?.toString() ?? '',
      identifier: json['identifier']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      status: TaskStatusEnum.fromString(json['status']?.toString()),
      customStatus: json['customStatus']?.toString(),
      priority: TaskPriorityEnum.fromString(json['priority']?.toString()),
      dueDate: json['dueDate']?.toString(),
      labels: labels,
      project: json['project'] != null ? ProjectModel.fromJson(json['project']) : null,
      assignee: json['assignee'] != null ? UserModel.fromJson(json['assignee']) : null,
      creator: json['creator'] != null ? UserModel.fromJson(json['creator']) : null,
      subtasksCount: (json['subtasksCount'] as num?)?.toInt() ?? subtasksList.length,
      subtasksCompletedCount: (json['subtasksCompletedCount'] as num?)?.toInt() ??
          subtasksList.where((s) => s.isCompleted).length,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? commentsList.length,
      attachmentsCount: (json['attachmentsCount'] as num?)?.toInt() ?? attachmentsList.length,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      subtasks: subtasksList,
      comments: commentsList,
      attachments: attachmentsList,
      blockedByInfo: json['blockedByInfo']?.toString(),
      cycleId: json['cycleId']?.toString(),
      cycle: json['cycle'] != null && json['cycle'] is Map<String, dynamic>
          ? CycleModel.fromJson(json['cycle'])
          : null,
      workspaceId: json['workspaceId']?.toString() ?? json['workspace']?['id']?.toString(),
    );
  }
}

class HomeStatsModel {
  final int assignedCount;
  final int inProgressCount;
  final int dueSoonCount;
  final int urgentCount;
  final int completedThisWeekCount;
  final int unreadNotificationsCount;

  const HomeStatsModel({
    this.assignedCount = 0,
    this.inProgressCount = 0,
    this.dueSoonCount = 0,
    this.urgentCount = 0,
    this.completedThisWeekCount = 0,
    this.unreadNotificationsCount = 0,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    return HomeStatsModel(
      assignedCount: (json['assignedCount'] as num?)?.toInt() ?? 0,
      inProgressCount: (json['inProgressCount'] as num?)?.toInt() ?? 0,
      dueSoonCount: (json['dueSoonCount'] as num?)?.toInt() ?? 0,
      urgentCount: (json['urgentCount'] as num?)?.toInt() ?? 0,
      completedThisWeekCount: (json['completedThisWeekCount'] as num?)?.toInt() ?? 0,
      unreadNotificationsCount: (json['unreadNotificationsCount'] as num?)?.toInt() ?? 0,
    );
  }

  int get assignedTasksCount => assignedCount;
  int get urgentTasksCount => urgentCount;
  int get completedTasksCount => completedThisWeekCount;
}

class StatusBreakdownItem {
  final String status;
  final String label;
  final int count;

  const StatusBreakdownItem({
    required this.status,
    required this.label,
    required this.count,
  });

  factory StatusBreakdownItem.fromJson(Map<String, dynamic> json) {
    return StatusBreakdownItem(
      status: json['status']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class HomeDataModel {
  final UserModel user;
  final WorkspaceModel currentWorkspace;
  final List<WorkspaceModel> availableWorkspaces;
  final HomeStatsModel stats;
  final List<TaskModel> myAssignedTasks;
  final List<ProjectModel> projects;
  final List<StatusBreakdownItem> statusBreakdown;
  List<TaskModel> get assignedToMe => myAssignedTasks;

  const HomeDataModel({
    required this.user,
    required this.currentWorkspace,
    required this.availableWorkspaces,
    required this.stats,
    required this.myAssignedTasks,
    required this.projects,
    required this.statusBreakdown,
  });

  HomeDataModel copyWith({
    UserModel? user,
    WorkspaceModel? currentWorkspace,
    List<WorkspaceModel>? availableWorkspaces,
    HomeStatsModel? stats,
    List<TaskModel>? myAssignedTasks,
    List<ProjectModel>? projects,
    List<StatusBreakdownItem>? statusBreakdown,
  }) {
    return HomeDataModel(
      user: user ?? this.user,
      currentWorkspace: currentWorkspace ?? this.currentWorkspace,
      availableWorkspaces: availableWorkspaces ?? this.availableWorkspaces,
      stats: stats ?? this.stats,
      myAssignedTasks: myAssignedTasks ?? this.myAssignedTasks,
      projects: projects ?? this.projects,
      statusBreakdown: statusBreakdown ?? this.statusBreakdown,
    );
  }

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    final myTasks = <TaskModel>[];
    if (json['myAssignedTasks'] is List) {
      for (final t in json['myAssignedTasks']) {
        myTasks.add(TaskModel.fromJson(t));
      }
    }

    final projectsList = <ProjectModel>[];
    if (json['projects'] is List) {
      for (final p in json['projects']) {
        projectsList.add(ProjectModel.fromJson(p));
      }
    }

    final breakdownList = <StatusBreakdownItem>[];
    if (json['statusBreakdown'] is List) {
      for (final b in json['statusBreakdown']) {
        breakdownList.add(StatusBreakdownItem.fromJson(b));
      }
    }

    final workspacesList = <WorkspaceModel>[];
    if (json['availableWorkspaces'] is List) {
      for (final w in json['availableWorkspaces']) {
        workspacesList.add(WorkspaceModel.fromJson(w));
      }
    }

    return HomeDataModel(
      user: UserModel.fromJson(json['user'] ?? {}),
      currentWorkspace: WorkspaceModel.fromJson(json['currentWorkspace'] ?? {}),
      availableWorkspaces: workspacesList,
      stats: HomeStatsModel.fromJson(json['stats'] ?? {}),
      myAssignedTasks: myTasks,
      projects: projectsList,
      statusBreakdown: breakdownList,
    );
  }
}

class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final String? taskId;
  final UserModel? actor;
  final String createdAt;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    this.taskId,
    this.actor,
    required this.createdAt,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      taskId: taskId,
      actor: actor,
      createdAt: createdAt,
    );
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'SYSTEM',
      title: json['title']?.toString() ?? 'Notification',
      body: json['body']?.toString() ?? '',
      isRead: json['isRead'] == true,
      taskId: json['taskId']?.toString() ??
          (json['task'] is Map ? json['task']['id']?.toString() : null),
      actor: json['actor'] is Map<String, dynamic>
          ? UserModel.fromJson(json['actor'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class CycleModel {
  final String id;
  final int number;
  final String name;
  final String status; // 'ACTIVE', 'UPCOMING', 'COMPLETED'
  final String? startDate;
  final String? endDate;
  final int totalTasks;
  final int completedTasks;
  final int progressPercentage;
  final List<TaskModel> tasks;

  const CycleModel({
    required this.id,
    required this.number,
    required this.name,
    required this.status,
    this.startDate,
    this.endDate,
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.progressPercentage = 0,
    this.tasks = const [],
  });

  bool get isActive => status.toUpperCase() == 'ACTIVE';
  double get progress => progressPercentage > 0
      ? (progressPercentage / 100.0)
      : (totalTasks > 0 ? completedTasks / totalTasks : 0.0);

  factory CycleModel.fromJson(Map<String, dynamic> json) {
    final taskList = <TaskModel>[];
    if (json['tasks'] is List) {
      for (final t in json['tasks']) {
        taskList.add(TaskModel.fromJson(t));
      }
    }
    return CycleModel(
      id: json['id']?.toString() ?? '',
      number: (json['number'] as num?)?.toInt() ?? 1,
      name: json['name']?.toString() ?? 'Sprint',
      status: json['status']?.toString() ?? 'ACTIVE',
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
      totalTasks: (json['totalTasks'] as num?)?.toInt() ?? 0,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toInt() ?? 0,
      tasks: taskList,
    );
  }
}

class WorkspaceMemberModel {
  final String id;
  final String userId;
  final String role;
  final UserModel? user;
  final String status;

  const WorkspaceMemberModel({
    required this.id,
    required this.userId,
    required this.role,
    this.user,
    this.status = 'offline',
  });

  bool get isOnline => status.toLowerCase() == 'online';

  factory WorkspaceMemberModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceMemberModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      role: json['role']?.toString() ?? 'MEMBER',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      status: json['status']?.toString() ?? 'offline',
    );
  }
}

class UserHoverCardModel {
  final String id;
  final String name;
  final String handle;
  final String avatarUrl;
  final String initials;
  final String avatarColor;
  final String status;
  final String localTime;
  final String roleOrTitle;
  final String workspaceName;

  const UserHoverCardModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.initials,
    required this.avatarColor,
    required this.status,
    required this.localTime,
    required this.roleOrTitle,
    required this.workspaceName,
  });

  factory UserHoverCardModel.fromJson(Map<String, dynamic> json) {
    return UserHoverCardModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      handle: json['handle']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      initials: json['initials']?.toString() ?? '',
      avatarColor: json['avatarColor']?.toString() ?? '#8b5cf6',
      status: json['status']?.toString() ?? 'offline',
      localTime: json['localTime']?.toString() ?? '',
      roleOrTitle: json['roleOrTitle']?.toString() ?? '',
      workspaceName: json['workspaceName']?.toString() ?? '',
    );
  }
}

class SearchResultsModel {
  final List<TaskModel> tasks;
  final List<ProjectModel> projects;
  final List<UserModel> members;

  const SearchResultsModel({
    this.tasks = const [],
    this.projects = const [],
    this.members = const [],
  });

  factory SearchResultsModel.fromJson(Map<String, dynamic> json) {
    final tList = <TaskModel>[];
    if (json['tasks'] is List) {
      for (final t in json['tasks']) {
        tList.add(TaskModel.fromJson(t));
      }
    }
    final pList = <ProjectModel>[];
    if (json['projects'] is List) {
      for (final p in json['projects']) {
        pList.add(ProjectModel.fromJson(p));
      }
    }
    final mList = <UserModel>[];
    if (json['members'] is List) {
      for (final m in json['members']) {
        mList.add(UserModel.fromJson(m));
      }
    }
    return SearchResultsModel(
      tasks: tList,
      projects: pList,
      members: mList,
    );
  }
}



class AdminPerformanceModel {
  final String workspaceId;
  final String workspaceName;
  final String currentUserRole;
  final String period;
  final PerformanceSummaryModel summary;
  final List<MemberPerformanceModel> members;
  final List<ProjectPerformanceModel> projects;
  final List<CyclePerformanceModel> cycles;
  final List<RecentDoneTaskModel> recentDoneTasks;

  const AdminPerformanceModel({
    required this.workspaceId,
    required this.workspaceName,
    required this.currentUserRole,
    required this.period,
    required this.summary,
    required this.members,
    required this.projects,
    required this.cycles,
    required this.recentDoneTasks,
  });

  factory AdminPerformanceModel.fromJson(Map<String, dynamic> json) {
    return AdminPerformanceModel(
      workspaceId: json['workspaceId']?.toString() ?? '',
      workspaceName: json['workspaceName']?.toString() ?? '',
      currentUserRole: json['currentUserRole']?.toString() ?? 'MEMBER',
      period: json['period']?.toString() ?? 'all',
      summary: PerformanceSummaryModel.fromJson(
        (json['summary'] is Map<String, dynamic>) ? json['summary'] : {},
      ),
      members: (json['members'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => MemberPerformanceModel.fromJson(e))
          .toList(),
      projects: (json['projects'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ProjectPerformanceModel.fromJson(e))
          .toList(),
      cycles: (json['cycles'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => CyclePerformanceModel.fromJson(e))
          .toList(),
      recentDoneTasks: (json['recentDoneTasks'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => RecentDoneTaskModel.fromJson(e))
          .toList(),
    );
  }
}

class PerformanceSummaryModel {
  final int totalTasks;
  final int completedTasks;
  final double completionRate;
  final int inProgressTasks;
  final int pendingTasks;
  final int completedThisWeek;
  final int completedThisMonth;
  final int totalMembers;
  final int activeMembers;
  final double avgTasksPerMember;

  const PerformanceSummaryModel({
    required this.totalTasks,
    required this.completedTasks,
    required this.completionRate,
    required this.inProgressTasks,
    required this.pendingTasks,
    required this.completedThisWeek,
    required this.completedThisMonth,
    required this.totalMembers,
    required this.activeMembers,
    required this.avgTasksPerMember,
  });

  factory PerformanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return PerformanceSummaryModel(
      totalTasks: (json['totalTasks'] as num?)?.toInt() ?? 0,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0.0,
      inProgressTasks: (json['inProgressTasks'] as num?)?.toInt() ?? 0,
      pendingTasks: (json['pendingTasks'] as num?)?.toInt() ?? 0,
      completedThisWeek: (json['completedThisWeek'] as num?)?.toInt() ?? 0,
      completedThisMonth: (json['completedThisMonth'] as num?)?.toInt() ?? 0,
      totalMembers: (json['totalMembers'] as num?)?.toInt() ?? 0,
      activeMembers: (json['activeMembers'] as num?)?.toInt() ?? 0,
      avgTasksPerMember: (json['avgTasksPerMember'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class MemberPerformanceModel {
  final String userId;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final int assignedTasks;
  final int completedTasks;
  final int inProgressTasks;
  final int completionRate;
  final int completedThisWeek;
  final int completedThisMonth;
  final int rank;
  final String performanceGrade;

  const MemberPerformanceModel({
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.assignedTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.completionRate,
    required this.completedThisWeek,
    required this.completedThisMonth,
    required this.rank,
    required this.performanceGrade,
  });

  factory MemberPerformanceModel.fromJson(Map<String, dynamic> json) {
    return MemberPerformanceModel(
      userId: json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      role: json['role']?.toString() ?? 'MEMBER',
      assignedTasks: (json['assignedTasks'] as num?)?.toInt() ?? 0,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
      inProgressTasks: (json['inProgressTasks'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toInt() ?? 0,
      completedThisWeek: (json['completedThisWeek'] as num?)?.toInt() ?? 0,
      completedThisMonth: (json['completedThisMonth'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      performanceGrade: json['performanceGrade']?.toString() ?? 'ON_TRACK',
    );
  }
}

class ProjectPerformanceModel {
  final String projectId;
  final String name;
  final String key;
  final String? color;
  final int totalTasks;
  final int completedTasks;
  final int completionRate;

  const ProjectPerformanceModel({
    required this.projectId,
    required this.name,
    required this.key,
    this.color,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionRate,
  });

  factory ProjectPerformanceModel.fromJson(Map<String, dynamic> json) {
    return ProjectPerformanceModel(
      projectId: json['projectId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      color: json['color']?.toString(),
      totalTasks: (json['totalTasks'] as num?)?.toInt() ?? 0,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toInt() ?? 0,
    );
  }
}

class CyclePerformanceModel {
  final String cycleId;
  final String name;
  final int number;
  final String status;
  final int totalTasks;
  final int completedTasks;
  final int completionRate;

  const CyclePerformanceModel({
    required this.cycleId,
    required this.name,
    required this.number,
    required this.status,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionRate,
  });

  factory CyclePerformanceModel.fromJson(Map<String, dynamic> json) {
    return CyclePerformanceModel(
      cycleId: json['cycleId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      number: (json['number'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'ACTIVE',
      totalTasks: (json['totalTasks'] as num?)?.toInt() ?? 0,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toInt() ?? 0,
    );
  }
}

class RecentDoneTaskModel {
  final String id;
  final String identifier;
  final String title;
  final String projectName;
  final String? assigneeName;
  final String? assigneeAvatarUrl;
  final String completedAt;

  const RecentDoneTaskModel({
    required this.id,
    required this.identifier,
    required this.title,
    required this.projectName,
    this.assigneeName,
    this.assigneeAvatarUrl,
    required this.completedAt,
  });

  factory RecentDoneTaskModel.fromJson(Map<String, dynamic> json) {
    return RecentDoneTaskModel(
      id: json['id']?.toString() ?? '',
      identifier: json['identifier']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      projectName: json['projectName']?.toString() ?? 'General',
      assigneeName: json['assigneeName']?.toString(),
      assigneeAvatarUrl: json['assigneeAvatarUrl']?.toString(),
      completedAt: json['completedAt']?.toString() ?? '',
    );
  }
}
