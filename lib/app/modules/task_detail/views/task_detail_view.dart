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
            icon: const AppSvg(AppSvgIcons.trash, size: 18, color: AppColors.textMuted),
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

                  // Issue Title
                  Text(
                    task.title,
                    style: AppTheme.headlineLg.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    Container(
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
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Subtasks Section
                  _buildSubtasksSection(),
                  const SizedBox(height: 24),

                  // Comments & Activity
                  _buildCommentsSection(),
                ],
              ),
            ),

            // Bottom Minimal Comment Composer
            _buildBottomCommentBar(),
          ],
        );
      }),
    );
  }

  Widget _buildTriageRow(TaskModel task) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // Status Picker
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

          // Priority Picker
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

          // Assignee Tag
          if (task.assignee != null)
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                children: [
                  UserAvatar(avatarUrl: task.assignee!.avatarUrl, name: task.assignee!.name, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    task.assignee!.name,
                    style: AppTheme.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
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
                      st.isCompleted ? AppSvgIcons.checkboxChecked : AppSvgIcons.checkboxUnchecked,
                      size: 16,
                      color: st.isCompleted ? AppColors.statusDone : AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
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
        const SizedBox(height: 10),

        Obx(() {
          if (controller.comments.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                'No comments yet',
                style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
              ),
            );
          }
          return Column(
            children: controller.comments.map((c) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface1,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAvatar(avatarUrl: c.user?.avatarUrl, name: c.user?.name, size: 28),
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
                          Text(
                            c.content,
                            style: AppTheme.bodyMd.copyWith(color: AppColors.textSecondary, fontSize: 12.5),
                          ),
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

  Widget _buildBottomCommentBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.surface1,
        border: Border(top: BorderSide(color: AppColors.borderDefault)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
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
                  style: AppTheme.bodyMd.copyWith(color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Leave a comment...',
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
    );
  }
}
