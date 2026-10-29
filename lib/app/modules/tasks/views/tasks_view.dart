import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';
import '../../../widgets/task_card_item.dart';
import '../controllers/tasks_controller.dart';

class TasksView extends GetView<TasksController> {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final tasks = controller.filteredTasks;
        final isBoard = controller.isBoardView.value;

        return Column(
          children: [
            // Scope & Filter Bar
            _buildTopFilterBar(),

            // Tasks Content
            Expanded(
              child: isLoading && tasks.isEmpty
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
                      onRefresh: controller.fetchTasks,
                      child: isBoard ? _buildBoardView(tasks) : _buildListView(tasks),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTopFilterBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Column(
        children: [
          // Row 1: Scope tabs (All Issues, Assigned, Created) + View Mode Switcher
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.surface1,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      _scopeTab('All Issues', 'all'),
                      _scopeTab('Assigned', 'assigned_to_me'),
                      _scopeTab('Created', 'created_by_me'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // View Switcher (List vs Board)
              GestureDetector(
                onTap: controller.toggleViewMode,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: controller.isBoardView.value ? AppColors.surface3 : AppColors.surface1,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(
                      color: controller.isBoardView.value ? AppColors.primaryLight.withValues(alpha: 0.5) : AppColors.borderDefault,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSvg(
                        controller.isBoardView.value ? AppSvgIcons.list : AppSvgIcons.board,
                        size: 14,
                        color: controller.isBoardView.value ? AppColors.primaryLight : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        controller.isBoardView.value ? 'Board' : 'List',
                        style: AppTheme.labelMonoSm.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: controller.isBoardView.value ? AppColors.primaryLight : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Status Filter Chips (All, Backlog, Todo, In Progress, Done, Canceled)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _filterChip(
                  label: 'All',
                  isSelected: controller.selectedStatus.value == null,
                  onTap: () => controller.filterByStatus(null),
                ),
                ...TaskStatusEnum.values.map(
                  (status) => Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: _filterChip(
                      label: status.label,
                      isSelected: controller.selectedStatus.value == status.apiKey,
                      color: status.color,
                      onTap: () => controller.filterByStatus(status.apiKey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scopeTab(String label, String scopeKey) {
    final isSelected = controller.selectedScope.value == scopeKey;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setScope(scopeKey),
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface3 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusXs),
            border: isSelected ? Border.all(color: AppColors.borderDefault) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTheme.bodySm.copyWith(
              color: isSelected ? Colors.white : AppColors.textMuted,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface3 : AppColors.surface1,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.5) : AppColors.borderDefault,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTheme.bodySm.copyWith(
                color: isSelected ? Colors.white : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No issues match your filter',
          style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCardItem(
          task: task,
          onTap: () => controller.openTaskDetail(task.id),
          onToggleStatus: () => controller.toggleStatus(task),
          onCyclePriority: () => controller.cyclePriority(task),
        );
      },
    );
  }

  Widget _buildBoardView(List<TaskModel> tasks) {
    final columns = [
      {'status': TaskStatusEnum.backlog, 'title': 'Backlog'},
      {'status': TaskStatusEnum.todo, 'title': 'Todo'},
      {'status': TaskStatusEnum.inProgress, 'title': 'In Progress'},
      {'status': TaskStatusEnum.done, 'title': 'Done'},
      {'status': TaskStatusEnum.canceled, 'title': 'Canceled'},
    ];

    return PageView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: columns.length,
      itemBuilder: (context, index) {
        final col = columns[index];
        final status = col['status'] as TaskStatusEnum;
        final title = col['title'] as String;
        final colTasks = tasks.where((t) => t.status == status).toList();

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          padding: const EdgeInsets.all(12),
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
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: AppTheme.headlineSm.copyWith(fontSize: 14)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surface3,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${colTasks.length}',
                      style: AppTheme.labelMonoSm.copyWith(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: AppColors.borderSubtle, height: 1),
              const SizedBox(height: 8),
              Expanded(
                child: colTasks.isEmpty
                    ? Center(
                        child: Text(
                          'No issues',
                          style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
                        ),
                      )
                    : ListView.builder(
                        itemCount: colTasks.length,
                        itemBuilder: (context, cIdx) {
                          final t = colTasks[cIdx];
                          return TaskCardItem(
                            task: t,
                            onTap: () => controller.openTaskDetail(t.id),
                            onToggleStatus: () => controller.toggleStatus(t),
                            onCyclePriority: () => controller.cyclePriority(t),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
