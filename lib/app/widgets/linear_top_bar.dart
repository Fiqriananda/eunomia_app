import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/icons/app_svg_icons.dart';
import '../data/models/models.dart';
import 'user_avatar.dart';

class LinearTopBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel? user;
  final WorkspaceModel? workspace;
  final int unreadCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onWorkspaceTap;

  const LinearTopBar({
    super.key,
    this.user,
    this.workspace,
    this.unreadCount = 3,
    this.onNotificationTap,
    this.onProfileTap,
    this.onWorkspaceTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.canvas,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              // Linear Logo
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                alignment: Alignment.center,
                child: const AppSvg(
                  AppSvgIcons.eunomiaLogo,
                  size: 20,
                  color: AppColors.primaryHover,
                ),
              ),
              const SizedBox(width: 12),

              // Organization / Project Title
              Expanded(
                child: GestureDetector(
                  onTap: onWorkspaceTap,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LINEAR',
                        style: AppTheme.labelMonoSm.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              workspace?.name ?? 'Acme Dev / Mobile Core',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.labelAction.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const AppSvg(
                            AppSvgIcons.chevronDown,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Notification Bell with Badge
              GestureDetector(
                onTap: onNotificationTap,
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const AppSvg(
                        AppSvgIcons.bell,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Color(0xFF6366F1),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // User Profile Avatar
              GestureDetector(
                onTap: onProfileTap,
                child: UserAvatar(
                  avatarUrl: user?.avatarUrl,
                  name: user?.name,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
