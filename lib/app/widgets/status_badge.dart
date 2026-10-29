import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/icons/app_svg_icons.dart';
import '../data/models/models.dart';

class StatusBadge extends StatelessWidget {
  final TaskStatusEnum status;
  final VoidCallback? onTap;
  final bool showDropdownArrow;

  const StatusBadge({
    super.key,
    required this.status,
    this.onTap,
    this.showDropdownArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    final badge = Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: AppColors.borderDefault,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: AppTheme.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          if (showDropdownArrow) ...[
            const SizedBox(width: 4),
            const AppSvg(
              AppSvgIcons.chevronDown,
              size: 12,
              color: AppColors.textMuted,
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: badge,
      );
    }
    return badge;
  }
}
