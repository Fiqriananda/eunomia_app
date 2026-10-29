import 'package:flutter/material.dart';
import '../core/icons/app_svg_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../data/models/models.dart';

class WorkspaceSwitcherSheet extends StatelessWidget {
  final List<WorkspaceModel> workspaces;
  final WorkspaceModel? currentWorkspace;
  final Function(WorkspaceModel) onSelectWorkspace;

  const WorkspaceSwitcherSheet({
    super.key,
    required this.workspaces,
    required this.currentWorkspace,
    required this.onSelectWorkspace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
        border: Border(top: BorderSide(color: AppColors.borderDefault)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workspaces',
                      style: AppTheme.headlineSm.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Switch active organization / workspace',
                      style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surface3,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Text(
                  '${workspaces.length}',
                  style: AppTheme.labelMonoSm.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderDefault, height: 1),
          const SizedBox(height: 12),
          if (workspaces.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No workspaces available',
                  style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: workspaces.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final ws = workspaces[index];
                  final isSelected = currentWorkspace?.id == ws.id;

                  final initial = ws.name.isNotEmpty
                      ? ws.name.substring(0, 1).toUpperCase()
                      : 'W';

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelectWorkspace(ws),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.surface3
                              : AppColors.surface2.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryHover
                                : AppColors.borderDefault,
                            width: isSelected ? 1.4 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : AppColors.surface4,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryHover
                                      : AppColors.borderDefault,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initial,
                                style: AppTheme.labelAction.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppColors.onPrimary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          ws.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTheme.bodyMd.copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? AppColors.textPrimary
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      if (ws.role != null && ws.role!.isNotEmpty) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 1.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.surface4,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            ws.role!.toUpperCase(),
                                            style: AppTheme.labelMonoSm.copyWith(
                                              fontSize: 9,
                                              color: AppColors.textMuted,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (ws.slug.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      '/${ws.slug}',
                                      style: AppTheme.labelMonoSm.copyWith(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const AppSvg(
                                  AppSvgIcons.check,
                                  size: 12,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            else
                              const AppSvg(
                                AppSvgIcons.chevronRight,
                                size: 14,
                                color: AppColors.textDisabled,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
