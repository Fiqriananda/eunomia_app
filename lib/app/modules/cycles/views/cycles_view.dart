import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/priority_badge.dart';
import '../../../widgets/user_avatar.dart';
import '../controllers/cycles_controller.dart';

class CyclesView extends GetView<CyclesController> {
  const CyclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final tab = controller.activeTab.value;

        return Column(
          children: [
            // Segment Switcher
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _tabButton('Sprints', 0),
                  const SizedBox(width: 8),
                  _tabButton('Members', 1, count: controller.members.length),
                  const SizedBox(width: 8),
                  _tabButton('Trash', 2, count: controller.trash.length),
                ],
              ),
            ),
            const Divider(color: AppColors.borderSubtle, height: 1),

            Expanded(
              child: isLoading && controller.cycles.isEmpty
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.surface2,
                      onRefresh: controller.fetchData,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        children: [
                          if (tab == 0) _buildSprintsTab(),
                          if (tab == 1) _buildMembersTab(),
                          if (tab == 2) _buildTrashTab(),
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _tabButton(String title, int index, {int? count}) {
    final isSelected = controller.activeTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.activeTab.value = index,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface3 : AppColors.surface1,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(
              color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.4) : AppColors.borderDefault,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTheme.bodySm.copyWith(
                  color: isSelected ? Colors.white : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              if (count != null && count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.3) : AppColors.surface4,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$count',
                    style: AppTheme.labelMonoSm.copyWith(fontSize: 9.5, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSprintsTab() {
    final cycles = controller.cycles;

    if (cycles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Column(
          children: [
            const AppSvg(AppSvgIcons.switchCycles, size: 36, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text('No cycles active', style: AppTheme.headlineSm),
            const SizedBox(height: 4),
            Text(
              'Sprint cycles are not configured yet for this workspace',
              textAlign: TextAlign.center,
              style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cycles.map((c) {
        final progress = (c.progress).clamp(0.0, 1.0);
        final pct = (progress * 100).toInt();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      c.name,
                      style: AppTheme.headlineSm.copyWith(fontSize: 14),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: c.status == 'ACTIVE'
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.surface3,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      c.status,
                      style: AppTheme.labelMonoSm.copyWith(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: c.status == 'ACTIVE' ? AppColors.primaryLight : AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '${c.completedTasks}/${c.totalTasks} issues completed',
                    style: AppTheme.bodySm.copyWith(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const Spacer(),
                  Text(
                    '$pct%',
                    style: AppTheme.labelMonoSm.copyWith(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: AppColors.surface4,
                  valueColor: AlwaysStoppedAnimation(
                    c.status == 'ACTIVE' ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMembersTab() {
    final members = controller.members;

    if (members.isEmpty) {
      return Center(
        child: Text('No members found', style: AppTheme.bodySm.copyWith(color: AppColors.textMuted)),
      );
    }

    return Column(
      children: members.map((m) {
        final u = m.user;
        final name = u?.name ?? 'Teammate';
        final email = u?.email ?? '';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            children: [
              UserAvatar(avatarUrl: u?.avatarUrl, name: name, size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTheme.labelAction.copyWith(fontWeight: FontWeight.w600)),
                    Text(email, style: AppTheme.bodySm.copyWith(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface3,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  m.role,
                  style: AppTheme.labelMonoSm.copyWith(
                    fontSize: 9.5,
                    color: m.role == 'OWNER' ? AppColors.primaryLight : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrashTab() {
    final trash = controller.trash;

    if (trash.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Column(
          children: [
            const AppSvg(AppSvgIcons.trash, size: 32, color: AppColors.textMuted),
            const SizedBox(height: 10),
            Text('Trash is empty', style: AppTheme.headlineSm),
            const SizedBox(height: 4),
            Text(
              'Deleted issues will appear here and can be restored',
              style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Column(
      children: trash.map((task) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            children: [
              PriorityBadge(priority: task.priority, compact: true),
              const SizedBox(width: 8),
              Text(
                task.identifier,
                style: AppTheme.labelMonoSm.copyWith(fontSize: 10.5, color: AppColors.textMuted),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.bodyMd.copyWith(
                    fontSize: 12.5,
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Restore button
              GestureDetector(
                onTap: () => controller.restoreTask(task.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const AppSvg(AppSvgIcons.restore, size: 12, color: AppColors.primaryLight),
                      const SizedBox(width: 4),
                      Text(
                        'Restore',
                        style: AppTheme.labelMonoSm.copyWith(fontSize: 10.5, color: AppColors.primaryLight),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Purge button
              GestureDetector(
                onTap: () => controller.purgeTask(task.id),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.surface3,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const AppSvg(AppSvgIcons.close, size: 12, color: AppColors.priorityUrgent),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
