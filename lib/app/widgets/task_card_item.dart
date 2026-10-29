import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/icons/app_svg_icons.dart';
import '../data/models/models.dart';
import 'priority_badge.dart';
import 'user_avatar.dart';

class TaskCardItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onCyclePriority;

  const TaskCardItem({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleStatus,
    this.onCyclePriority,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.isCompleted;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        onToggleStatus?.call();
        return false; // Don't remove from DOM, just toggle status optimistically
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const AppSvg(AppSvgIcons.check, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              isDone ? 'Mark In Progress' : 'Mark Done',
              style: AppTheme.labelAction.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: AppColors.borderDefault,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Status icon + ID + Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onToggleStatus,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, right: 8),
                      child: AppSvg(
                        task.status.svgIcon,
                        size: 16,
                        color: task.status.color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${task.identifier}  •  ',
                            style: AppTheme.labelMono.copyWith(
                              color: isDone ? AppColors.textDisabled : AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: task.title,
                            style: AppTheme.bodyMd.copyWith(
                              color: isDone ? AppColors.textMuted : AppColors.textSecondary,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                              decorationColor: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Footer Row: Priority, Tag, Due Date, Assignee
              Row(
                children: [
                  // Priority Badge (Tappable to cycle!)
                  PriorityBadge(
                    priority: task.priority,
                    onTap: onCyclePriority,
                    compact: true,
                  ),
                  const SizedBox(width: 6),

                  // Tag chip
                  if (task.labels.isNotEmpty)
                    Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surface3,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        border: Border.all(
                          color: AppColors.borderDefault,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '#${task.labels.first}',
                        style: AppTheme.labelMonoSm.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Due date / Status label
                  if (task.dueDate != null && task.dueDate!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        task.dueDate!,
                        style: AppTheme.labelMonoSm.copyWith(
                          color: task.dueDate!.toLowerCase().contains('today') || task.dueDate!.toLowerCase().contains('2h')
                              ? AppColors.priorityHigh
                              : AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),

                  // Assignee Avatar
                  _buildAssigneeAvatar(task.assignee),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssigneeAvatar(UserModel? assignee) {
    return UserAvatar(
      avatarUrl: assignee?.avatarUrl,
      name: assignee?.name,
      size: 18,
      borderWidth: 1,
    );
  }
}
