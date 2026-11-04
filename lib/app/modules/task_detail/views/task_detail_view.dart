import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';
import '../../../widgets/priority_badge.dart';
import '../../../widgets/status_badge.dart';
import '../../../widgets/user_avatar.dart';
import '../controllers/task_detail_controller.dart';

class TaskDetailView extends GetView<TaskDetailController> {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          icon: const AppSvg(AppSvgIcons.arrowBack, size: 18, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final t = controller.task.value;
          return Text(
            t?.identifier ?? '',
            style: AppTheme.labelMonoSm.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          );
        }),
        actions: [
          IconButton(
            icon: const AppSvg(AppSvgIcons.pencil, size: 18, color: AppColors.textSecondary),
            tooltip: 'Edit Issue',
            onPressed: () {
              final t = controller.task.value;
              if (t != null) _openEditModal(context, t);
            },
          ),
          IconButton(
            icon: const AppSvg(AppSvgIcons.trash, size: 18, color: AppColors.textMuted),
            tooltip: 'Delete Issue',
            onPressed: () {
              Get.defaultDialog(
                title: 'Delete Issue',
                titleStyle: AppTheme.headlineSm,
                middleText: 'Are you sure you want to move this issue to trash?',
                middleTextStyle: AppTheme.bodyMd.copyWith(color: AppColors.textMuted),
                backgroundColor: AppColors.surface1,
                textCancel: 'Cancel',
                textConfirm: 'Delete',
                confirmTextColor: Colors.white,
                buttonColor: AppColors.priorityUrgent,
                onConfirm: () {
                  Get.back();
                  controller.deleteTask();
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final task = controller.task.value;

        if (isLoading && task == null) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
          );
        }

        if (task == null) {
          return Center(
            child: Text(
              'Issue not found',
              style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // Triage Properties Row (Status, Priority, Assignee)
                  _buildTriageRow(task),
                  const SizedBox(height: 16),

                  // Issue Title (Tap to edit)
                  GestureDetector(
                    onTap: () => _openEditModal(context, task),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: AppTheme.headlineLg.copyWith(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: AppSvg(AppSvgIcons.pencil, size: 14, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description (Tap to edit)
                  GestureDetector(
                    onTap: () => _openEditModal(context, task),
                    behavior: HitTestBehavior.opaque,
                    child: task.description != null && task.description!.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface1,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: Text(
                              task.description!,
                              style: AppTheme.bodyMd.copyWith(height: 1.5, color: AppColors.textSecondary),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.surface1,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: Row(
                              children: [
                                const AppSvg(AppSvgIcons.plus, size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 8),
                                Text(
                                  'Add description...',
                                  style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Subtasks Section
                  _buildSubtasksSection(),
                  const SizedBox(height: 24),

                  // Comments & Activity
                  _buildCommentsSection(),
                ],
              ),
            ),

            // Bottom Minimal Comment Composer with Mentions
            _buildBottomCommentBar(context),
          ],
        );
      }),
    );
  }

  void _openEditModal(BuildContext context, TaskModel task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description ?? '');
    var selectedStatus = task.status;
    var selectedPriority = task.priority;
    String? selectedAssigneeId = task.assignee?.id;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
              border: Border(top: BorderSide(color: AppColors.borderDefault, width: 1)),
            ),
            child: SafeArea(
              top: false,
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.surface4,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Text(
                            'Edit Issue',
                            style: AppTheme.headlineSm.copyWith(fontSize: 18),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.of(ctx).pop(),
                            child: const AppSvg(
                              AppSvgIcons.close,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: titleController,
                        style: AppTheme.bodyLg.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Issue title',
                          hintStyle: AppTheme.bodyLg.copyWith(color: AppColors.textMuted),
                          filled: true,
                          fillColor: AppColors.surface2,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                            borderSide: const BorderSide(color: AppColors.borderDefault),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                            borderSide: const BorderSide(color: AppColors.borderDefault),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                            borderSide: const BorderSide(color: AppColors.primaryHover),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: descController,
                        maxLines: 4,
                        style: AppTheme.bodyMd.copyWith(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Add description (Markdown supported)...',
                          hintStyle: AppTheme.bodyMd.copyWith(color: AppColors.textMuted),
                          filled: true,
                          fillColor: AppColors.surface2,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                            borderSide: const BorderSide(color: AppColors.borderDefault),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                            borderSide: const BorderSide(color: AppColors.borderDefault),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                            borderSide: const BorderSide(color: AppColors.primaryHover),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          PopupMenuButton<TaskStatusEnum>(
                            initialValue: selectedStatus,
                            color: AppColors.surface2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                              side: const BorderSide(color: AppColors.borderDefault),
                            ),
                            onSelected: (val) => setSheetState(() => selectedStatus = val),
                            itemBuilder: (_) => TaskStatusEnum.values.map((s) {
                              return PopupMenuItem(
                                value: s,
                                child: Row(
                                  children: [
                                    AppSvg(s.svgIcon, size: 16, color: s.color),
                                    const SizedBox(width: 8),
                                    Text(s.label, style: AppTheme.bodyMd),
                                  ],
                                ),
                              );
                            }).toList(),
                            child: StatusBadge(status: selectedStatus, showDropdownArrow: true),
                          ),

                          PopupMenuButton<TaskPriorityEnum>(
                            initialValue: selectedPriority,
                            color: AppColors.surface2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                              side: const BorderSide(color: AppColors.borderDefault),
                            ),
                            onSelected: (val) => setSheetState(() => selectedPriority = val),
                            itemBuilder: (_) => TaskPriorityEnum.values.map((p) {
                              return PopupMenuItem(
                                value: p,
                                child: Row(
                                  children: [
                                    AppSvg(p.svgIcon, size: 16, color: p.color),
                                    const SizedBox(width: 8),
                                    Text(p.label, style: AppTheme.bodyMd),
                                  ],
                                ),
                              );
                            }).toList(),
                            child: PriorityBadge(priority: selectedPriority),
                          ),

                          PopupMenuButton<String?>(
                            color: AppColors.surface2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                              side: const BorderSide(color: AppColors.borderDefault),
                            ),
                            onSelected: (val) => setSheetState(() => selectedAssigneeId = val),
                            itemBuilder: (_) => [
                              PopupMenuItem<String?>(
                                value: null,
                                child: Row(
                                  children: [
                                    const AppSvg(AppSvgIcons.close, size: 14, color: AppColors.textMuted),
                                    const SizedBox(width: 8),
                                    Text('Unassigned', style: AppTheme.bodyMd.copyWith(color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              ...controller.members.map((m) {
                                final u = m.user;
                                return PopupMenuItem<String?>(
                                  value: m.userId,
                                  child: Row(
                                    children: [
                                      UserAvatar(avatarUrl: u?.avatarUrl, name: u?.name ?? 'User', size: 18),
                                      const SizedBox(width: 8),
                                      Text(u?.name ?? 'Member', style: AppTheme.bodyMd),
                                    ],
                                  ),
                                );
                              }),
                            ],
                            child: Builder(
                              builder: (_) {
                                final currentMember = controller.members.firstWhereOrNull((m) => m.userId == selectedAssigneeId);
                                final displayName = currentMember?.user?.name ?? (selectedAssigneeId == task.assignee?.id ? task.assignee?.name : null);
                                final displayAvatar = currentMember?.user?.avatarUrl ?? (selectedAssigneeId == task.assignee?.id ? task.assignee?.avatarUrl : null);
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface2,
                                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                                    border: Border.all(color: AppColors.borderDefault),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (displayName != null) ...[
                                        UserAvatar(avatarUrl: displayAvatar, name: displayName, size: 16),
                                        const SizedBox(width: 6),
                                        Text(displayName, style: AppTheme.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                                      ] else ...[
                                        const AppSvg(AppSvgIcons.user, size: 14, color: AppColors.textMuted),
                                        const SizedBox(width: 6),
                                        Text('Assignee', style: AppTheme.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11)),
                                      ],
                                      const SizedBox(width: 4),
                                      const AppSvg(AppSvgIcons.chevronDown, size: 10, color: AppColors.textMuted),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await controller.editTask(
                              title: titleController.text,
                              description: descController.text,
                              status: selectedStatus,
                              priority: selectedPriority,
                              assigneeId: selectedAssigneeId,
                            );
                            if (success && ctx.mounted) {
                              Navigator.of(ctx).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save Changes',
                            style: AppTheme.labelAction.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    }

  Widget _buildTriageRow(TaskModel task) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          PopupMenuButton<TaskStatusEnum>(
            initialValue: task.status,
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
              side: const BorderSide(color: AppColors.borderDefault),
            ),
            onSelected: controller.updateStatus,
            itemBuilder: (context) => TaskStatusEnum.values.map((s) {
              return PopupMenuItem(
                value: s,
                child: Row(
                  children: [
                    AppSvg(s.svgIcon, size: 14, color: s.color),
                    const SizedBox(width: 8),
                    Text(s.label, style: AppTheme.bodyMd),
                  ],
                ),
              );
            }).toList(),
            child: StatusBadge(status: task.status, showDropdownArrow: true),
          ),
          const SizedBox(width: 8),

          PopupMenuButton<TaskPriorityEnum>(
            initialValue: task.priority,
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
              side: const BorderSide(color: AppColors.borderDefault),
            ),
            onSelected: controller.updatePriority,
            itemBuilder: (context) => TaskPriorityEnum.values.map((p) {
              return PopupMenuItem(
                value: p,
                child: Row(
                  children: [
                    AppSvg(p.svgIcon, size: 14, color: p.color),
                    const SizedBox(width: 8),
                    Text(p.label, style: AppTheme.bodyMd),
                  ],
                ),
              );
            }).toList(),
            child: PriorityBadge(priority: task.priority),
          ),
          const SizedBox(width: 8),

          PopupMenuButton<String?>(
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
              side: const BorderSide(color: AppColors.borderDefault),
            ),
            onSelected: (val) => controller.updateAssignee(val),
            itemBuilder: (context) => [
              PopupMenuItem<String?>(
                value: null,
                child: Row(
                  children: [
                    const AppSvg(AppSvgIcons.close, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 8),
                    Text('Unassigned', style: AppTheme.bodyMd.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              ...controller.members.map((m) {
                final user = m.user;
                return PopupMenuItem<String?>(
                  value: m.userId,
                  child: Row(
                    children: [
                      UserAvatar(
                        avatarUrl: user?.avatarUrl,
                        name: user?.name ?? 'User',
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          user?.name ?? 'Member',
                          style: AppTheme.bodyMd,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            child: Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                children: [
                  if (task.assignee != null) ...[
                    UserAvatar(avatarUrl: task.assignee!.avatarUrl, name: task.assignee!.name, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      task.assignee!.name,
                      style: AppTheme.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ] else ...[
                    const AppSvg(AppSvgIcons.user, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      'Assignee',
                      style: AppTheme.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                  const SizedBox(width: 4),
                  const AppSvg(AppSvgIcons.chevronDown, size: 10, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'SUBTASKS',
              style: AppTheme.labelMonoSm.copyWith(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 6),
            Obx(() => Text(
                  '(${controller.subtasks.length})',
                  style: AppTheme.labelMonoSm.copyWith(fontSize: 10, color: AppColors.textMuted),
                )),
          ],
        ),
        const SizedBox(height: 8),

        Obx(() {
          if (controller.subtasks.isEmpty) {
            return Text(
              'No subtasks',
              style: AppTheme.bodySm.copyWith(color: AppColors.textDisabled),
            );
          }
          return Column(
            children: controller.subtasks.map((st) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface1,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    AppSvg(
                      st.isCompleted ? AppSvgIcons.statusDone : AppSvgIcons.statusTodo,
                      size: 14,
                      color: st.isCompleted ? AppColors.statusDone : AppColors.textMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        st.title,
                        style: AppTheme.bodyMd.copyWith(
                          fontSize: 12.5,
                          decoration: st.isCompleted ? TextDecoration.lineThrough : null,
                          color: st.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),

        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            final subtaskController = TextEditingController();
            Get.defaultDialog(
              title: 'Add Subtask',
              titleStyle: AppTheme.headlineSm,
              backgroundColor: AppColors.surface1,
              content: TextField(
                controller: subtaskController,
                autofocus: true,
                style: AppTheme.bodyMd,
                decoration: const InputDecoration(
                  hintText: 'Subtask title...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                ),
              ),
              textCancel: 'Cancel',
              textConfirm: 'Add',
              confirmTextColor: Colors.white,
              buttonColor: AppColors.primary,
              onConfirm: () {
                controller.addSubtask(subtaskController.text);
                Get.back();
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const AppSvg(AppSvgIcons.plus, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  'Add subtask...',
                  style: AppTheme.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'ACTIVITY & COMMENTS',
              style: AppTheme.labelMonoSm.copyWith(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 6),
            Obx(() => Text(
                  '(${controller.comments.length})',
                  style: AppTheme.labelMonoSm.copyWith(fontSize: 10, color: AppColors.textMuted),
                )),
          ],
        ),
        const SizedBox(height: 12),

        Obx(() {
          if (controller.comments.isEmpty) {
            return Text(
              'No comments yet',
              style: AppTheme.bodySm.copyWith(color: AppColors.textDisabled),
            );
          }
          return Column(
            children: controller.comments.map((c) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface1,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAvatar(
                      avatarUrl: c.user?.avatarUrl,
                      name: c.user?.name ?? 'User',
                      size: 26,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                c.user?.name ?? 'Teammate',
                                style: AppTheme.labelAction.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              const Spacer(),
                              Text(
                                c.createdAt.split('T').first,
                                style: AppTheme.labelMonoSm.copyWith(fontSize: 9.5, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          _buildCommentContent(c.content),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildCommentContent(String content) {
    final words = content.split(' ');
    final spans = <TextSpan>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final isLast = i == words.length - 1;
      final suffix = isLast ? '' : ' ';

      if (word.startsWith('@') && word.length > 1) {
        spans.add(
          TextSpan(
            text: '$word$suffix',
            style: AppTheme.bodyMd.copyWith(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word$suffix',
            style: AppTheme.bodyMd.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.5,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildBottomCommentBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface1,
        border: Border(top: BorderSide(color: AppColors.borderDefault)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating Mention Overlay
            Obx(() {
              if (!controller.showMentionOverlay.value) {
                return const SizedBox.shrink();
              }
              final members = controller.filteredMembers;
              if (members.isEmpty) {
                return const SizedBox.shrink();
              }
              return Container(
                constraints: const BoxConstraints(maxHeight: 180),
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppColors.borderDefault),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x55000000),
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: members.length,
                  separatorBuilder: (_, _) => const Divider(
                    color: AppColors.borderSubtle,
                    height: 1,
                  ),
                  itemBuilder: (ctx, idx) {
                    final m = members[idx];
                    final name = m.user?.name ?? 'Member';
                    final email = m.user?.email ?? '';
                    return InkWell(
                      onTap: () => controller.insertMention(m),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            UserAvatar(
                              avatarUrl: m.user?.avatarUrl,
                              name: name,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppTheme.bodyMd.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (email.isNotEmpty)
                                    Text(
                                      email,
                                      style: AppTheme.bodySm.copyWith(
                                        color: AppColors.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surface3,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '@$name',
                                style: AppTheme.labelMonoSm.copyWith(
                                  color: AppColors.primaryLight,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            // Comment Composer Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: controller.triggerMention,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      alignment: Alignment.center,
                      child: const AppSvg(
                        AppSvgIcons.atSign,
                        size: 16,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      child: TextField(
                        controller: controller.commentController,
                        focusNode: controller.commentFocusNode,
                        style: AppTheme.bodyMd.copyWith(color: AppColors.textPrimary, fontSize: 13),
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => controller.sendComment(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  GestureDetector(
                    onTap: controller.sendComment,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const AppSvg(AppSvgIcons.send, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
