import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/linear_bottom_nav.dart';
import '../../../widgets/linear_top_bar.dart';
import '../../cycles/views/cycles_view.dart';
import '../../home/views/home_view.dart';
import '../../inbox/views/inbox_view.dart';
import '../../tasks/views/tasks_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.currentUser;
      final workspace = controller.currentWorkspace;
      final unread = controller.unreadCount;
      final cyclesEnabled = controller.cyclesEnabled;
      final activeIndex = controller.currentTabIndex.value;

      return Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: LinearTopBar(
          user: user,
          workspace: workspace,
          unreadCount: unread,
          onNotificationTap: () => controller.switchTab(2),
          onWorkspaceTap: controller.openWorkspaceSwitcher,
          onProfileTap: controller.openProfileMenu,
        ),
        body: Stack(
          children: [
            // Smooth PageView
            PageView(
              controller: controller.pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (idx) {
                controller.currentTabIndex.value = idx;
              },
              children: [
                const HomeView(),
                const TasksView(),
                const InboxView(),
                if (cyclesEnabled) const CyclesView(),
              ],
            ),

            // Minimalist Bottom Floating Dock
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: LinearBottomNav(
                        currentIndex: activeIndex.clamp(0, cyclesEnabled ? 3 : 2),
                        cyclesEnabled: cyclesEnabled,
                        unreadInboxCount: unread,
                        onTabSelected: controller.switchTab,
                        onLongPress: controller.openNavigationDrawer,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _MinimalistActionSquircle(
                      onPressed: controller.openCreateTaskSheet,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _MinimalistActionSquircle extends StatefulWidget {
  final VoidCallback onPressed;

  const _MinimalistActionSquircle({required this.onPressed});

  @override
  State<_MinimalistActionSquircle> createState() => _MinimalistActionSquircleState();
}

class _MinimalistActionSquircleState extends State<_MinimalistActionSquircle> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const AppSvg(
            AppSvgIcons.plus,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
