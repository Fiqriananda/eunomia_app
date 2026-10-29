import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';
import '../../../widgets/user_avatar.dart';
import '../controllers/admin_performance_controller.dart';

class AdminPerformanceView extends GetView<AdminPerformanceController> {
  const AdminPerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          icon: const AppSvg(AppSvgIcons.arrowBack, size: 18, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Performance Indicators',
          style: AppTheme.headlineSm.copyWith(fontSize: 16),
        ),
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final perf = controller.performance.value;
        final error = controller.errorMessage.value;

        if (isLoading && perf == null) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
          );
        }

        if (error.isNotEmpty && perf == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppSvg(AppSvgIcons.shield, size: 36, color: AppColors.priorityUrgent),
                  const SizedBox(height: 12),
                  Text('Access Restricted', style: AppTheme.headlineSm),
                  const SizedBox(height: 6),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          );
        }

        if (perf == null) return const SizedBox.shrink();

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface2,
          onRefresh: controller.fetchPerformance,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            children: [
              // Period Selector
              _buildPeriodSelector(),
              const SizedBox(height: 16),

              // KPI Summary Cards
              _buildSummaryCards(perf.summary),
              const SizedBox(height: 20),

              // Member Leaderboard
              _buildLeaderboardSection(perf.members),
              const SizedBox(height: 20),

              // Project Velocity
              _buildProjectsSection(perf.projects),
              const SizedBox(height: 20),

              // Recent Done
              _buildRecentTasksSection(perf.recentDoneTasks),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = [
      {'key': 'all', 'label': 'All Time'},
      {'key': 'week', 'label': 'This Week'},
      {'key': 'month', 'label': 'This Month'},
      {'key': 'quarter', 'label': 'Quarter'},
    ];

    return Row(
      children: periods.map((p) {
        final key = p['key']!;
        final label = p['label']!;
        final isSelected = controller.selectedPeriod.value == key;

        return Expanded(
          child: GestureDetector(
            onTap: () => controller.changePeriod(key),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surface3 : AppColors.surface1,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(
                  color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.5) : AppColors.borderDefault,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: AppTheme.labelMonoSm.copyWith(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCards(PerformanceSummaryModel sum) {
    return Row(
      children: [
        _kpiTile('Completion', '${sum.completionRate}%', AppColors.primaryLight),
        const SizedBox(width: 8),
        _kpiTile('Done / Total', '${sum.completedTasks}/${sum.totalTasks}', AppColors.statusDone),
        const SizedBox(width: 8),
        _kpiTile('Avg/Member', '${sum.avgTasksPerMember}', AppColors.statusInProgress),
      ],
    );
  }

  Widget _kpiTile(String label, String value, Color accent) {
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
            Text(label, style: AppTheme.bodySm.copyWith(fontSize: 10.5, color: AppColors.textMuted)),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTheme.headlineMd.copyWith(fontSize: 16, color: accent, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardSection(List<MemberPerformanceModel> members) {
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
              const AppSvg(AppSvgIcons.trophy, size: 16, color: AppColors.statusInProgress),
              const SizedBox(width: 8),
              Text('Team Leaderboard', style: AppTheme.headlineSm.copyWith(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderSubtle, height: 1),
          const SizedBox(height: 8),

          ...members.map((m) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: m.rank == 1
                          ? AppColors.statusInProgress.withValues(alpha: 0.2)
                          : AppColors.surface3,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${m.rank}',
                      style: AppTheme.labelMonoSm.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: m.rank == 1 ? AppColors.statusInProgress : AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  UserAvatar(avatarUrl: m.avatarUrl, name: m.name, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      m.name,
                      style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.w500, fontSize: 13),
                    ),
                  ),
                  Text(
                    '${m.completedTasks} done',
                    style: AppTheme.labelMonoSm.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(List<ProjectPerformanceModel> projects) {
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
              const AppSvg(AppSvgIcons.chart, size: 16, color: AppColors.primaryHover),
              const SizedBox(width: 8),
              Text('Project Velocity', style: AppTheme.headlineSm.copyWith(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderSubtle, height: 1),
          const SizedBox(height: 10),

          ...projects.map((p) {
            final double pct = p.totalTasks > 0 ? (p.completedTasks / p.totalTasks).clamp(0.0, 1.0) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${p.name} (${p.key})',
                          style: AppTheme.bodyMd.copyWith(fontSize: 12.5),
                        ),
                      ),
                      Text(
                        '${p.completedTasks}/${p.totalTasks} (${p.completionRate}%)',
                        style: AppTheme.labelMonoSm.copyWith(fontSize: 10.5, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 5,
                      backgroundColor: AppColors.surface4,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentTasksSection(List<RecentDoneTaskModel> tasks) {
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
              const AppSvg(AppSvgIcons.check, size: 16, color: AppColors.statusDone),
              const SizedBox(width: 8),
              Text('Recently Completed', style: AppTheme.headlineSm.copyWith(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderSubtle, height: 1),
          const SizedBox(height: 8),

          ...tasks.map((t) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Text(
                    t.identifier,
                    style: AppTheme.labelMonoSm.copyWith(fontSize: 10.5, color: AppColors.primaryLight),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.bodyMd.copyWith(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ),
                  if (t.assigneeName != null) ...[
                    const SizedBox(width: 6),
                    UserAvatar(name: t.assigneeName, avatarUrl: t.assigneeAvatarUrl, size: 18),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
