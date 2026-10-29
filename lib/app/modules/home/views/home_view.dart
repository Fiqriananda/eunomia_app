import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final data = controller.homeData.value;
      final assigned = data?.assignedToMe ?? [];
      final stats = data?.stats;
      final cycle = controller.currentCycle.value;

      if (isLoading && data == null) {
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface2,
        onRefresh: controller.fetchHomeData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            // Minimal Search & Command Bar
            _buildQuickSearchBar(context),
            const SizedBox(height: 18),

            // Minimal Metrics Summary
            if (stats != null) ...[
              _buildMinimalMetrics(stats),
              const SizedBox(height: 20),
            ],

            // Current Active Cycle Sprint Card (Minimal)
            if (cycle != null) ...[
              _buildMinimalCycleCard(cycle),
              const SizedBox(height: 22),
            ],

            // Section Header: Assigned to me
            Row(
              children: [
                Text(
                  'ASSIGNED TO ME',
                  style: AppTheme.labelMonoSm.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.surface3,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${assigned.length}',
                    style: AppTheme.labelMonoSm.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (assigned.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface1,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    const AppSvg(AppSvgIcons.check, size: 28, color: AppColors.textMuted),
                    const SizedBox(height: 10),
                    Text('All caught up', style: AppTheme.headlineSm),
                    const SizedBox(height: 4),
                    Text(
                      'No open issues currently assigned to you',
                      style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              )
            else
              ...assigned.map((task) => _buildMinimalTaskRow(task)),
          ],
        ),
      );
    });
  }

  Widget _buildQuickSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().openCommandPalette();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            const AppSvg(AppSvgIcons.search, size: 16, color: AppColors.textMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Type a command or search...',
                style: AppTheme.bodyMd.copyWith(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Text(
                '⌘K',
                style: AppTheme.labelMonoSm.copyWith(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalMetrics(HomeStatsModel stats) {
    return Row(
      children: [
        _metricTile('Assigned', '${stats.assignedTasksCount}', AppColors.primaryLight),
        const SizedBox(width: 10),
        _metricTile('Urgent / High', '${stats.urgentTasksCount}', AppColors.priorityHigh),
        const SizedBox(width: 10),
        _metricTile('Completed', '${stats.completedTasksCount}', AppColors.statusInProgress),
      ],
    );
  }

  Widget _metricTile(String label, String value, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.bodySm.copyWith(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTheme.headlineMd.copyWith(color: accentColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalCycleCard(CycleModel cycle) {
    final progress = (cycle.progress).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    return Container(
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
              const AppSvg(AppSvgIcons.switchCycles, size: 15, color: AppColors.primaryHover),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  cycle.name,
                  style: AppTheme.labelAction.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$percentage% done',
                style: AppTheme.labelMonoSm.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppColors.surface4,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalTaskRow(TaskModel task) {
    final isDone = task.isCompleted;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: InkWell(
        onTap: () => controller.openTaskDetail(task.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status Icon Button
            GestureDetector(
              onTap: () => controller.toggleTaskStatus(task),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: AppSvg(
                  task.status.svgIcon,
                  size: 16,
                  color: task.status.color,
                ),
              ),
            ),

            // Identifier & Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        task.identifier,
                        style: AppTheme.labelMonoSm.copyWith(
                          fontSize: 10.5,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (task.project?.name != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '• ${task.project!.name}',
                          style: AppTheme.bodySm.copyWith(fontSize: 10.5, color: AppColors.textDisabled),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.bodyMd.copyWith(
                      color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Priority Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.priorityTint(task.priority.color),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSvg(task.priority.svgIcon, size: 10, color: task.priority.color),
                  const SizedBox(width: 4),
                  Text(
                    task.priority.label,
                    style: AppTheme.labelMonoSm.copyWith(
                      fontSize: 9.5,
                      color: task.priority.color,
                      fontWeight: FontWeight.w600,
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
