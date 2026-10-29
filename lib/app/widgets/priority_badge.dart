import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/icons/app_svg_icons.dart';
import '../data/models/models.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriorityEnum priority;
  final VoidCallback? onTap;
  final bool compact;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = priority.color;

    final badge = Container(
      height: compact ? 20 : 22,
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.priorityTint(color),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: AppColors.priorityBorder(color),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSvg(
            priority.svgIcon,
            size: compact ? 11 : 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            priority.label,
            style: AppTheme.labelMonoSm.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 10 : 11,
            ),
          ),
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
