import 'package:flutter/material.dart';
import '../core/icons/app_svg_icons.dart';

class LinearBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final int unreadInboxCount;
  final bool cyclesEnabled;
  final VoidCallback? onLongPress;

  const LinearBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.unreadInboxCount = 0,
    this.cyclesEnabled = false,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1C20),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF2C2F36),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            index: 0,
            iconSvg: AppSvgIcons.pulse,
            label: 'Home',
          ),
          _buildNavItem(
            index: 1,
            iconSvg: AppSvgIcons.myIssues,
            label: 'Tasks',
          ),
          _buildNavItem(
            index: 2,
            iconSvg: AppSvgIcons.navInbox,
            label: 'Inbox',
            hasDot: unreadInboxCount > 0,
          ),
          if (cyclesEnabled)
            _buildNavItem(
              index: 3,
              iconSvg: AppSvgIcons.switchCycles,
              label: 'Cycles',
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconSvg,
    required String label,
    bool hasDot = false,
  }) {
    final isSelected = currentIndex == index;

    return Semantics(
      label: label,
      selected: isSelected,
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 18 : 14,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2B2E37) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  )
                : Border.all(color: Colors.transparent, width: 1),
          ),
          child: AnimatedScale(
            scale: isSelected ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AppSvg(
                  iconSvg,
                  size: 21,
                  color: isSelected ? Colors.white : const Color(0xFF8A8F98),
                ),
                if (hasDot)
                  Positioned(
                    right: -3,
                    top: -2,
                    child: Container(
                      width: 6.5,
                      height: 6.5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF388BFD),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x99388BFD),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
