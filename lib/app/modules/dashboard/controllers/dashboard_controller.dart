import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/command_palette_modal.dart';
import '../../../widgets/create_task_sheet.dart';
import '../../../widgets/user_avatar.dart';
import '../../../widgets/workspace_switcher_sheet.dart';
import '../../cycles/controllers/cycles_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';

class DashboardController extends GetxController {
  final ApiService api = ApiService.to;

  final currentTabIndex = 0.obs;
  late final PageController pageController;

  UserModel? get currentUser => api.currentUser.value;
  WorkspaceModel? get currentWorkspace => api.currentWorkspace.value;
  bool get cyclesEnabled => currentWorkspace?.cyclesEnabled == true;

  int get unreadCount {
    if (Get.isRegistered<InboxController>()) {
      return Get.find<InboxController>().unreadCount;
    }
    return 0;
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentTabIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void switchTab(int index) {
    currentTabIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void navigateToTaskDetail(String taskId) {
    Get.toNamed(Routes.TASK_DETAIL, arguments: {'taskId': taskId});
  }

  void openCommandPalette() {
    Get.bottomSheet(
      CommandPaletteModal(
        onSearchIssues: (query) {},
        onCreateIssue: openCreateTaskSheet,
        onFilterAssigned: () {
          switchTab(1); // switch to Tasks tab
          if (Get.isRegistered<TasksController>()) {
            Get.find<TasksController>().filterByAssignee(currentUser?.id);
          }
        },
        onOpenTask: navigateToTaskDetail,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void openCreateTaskSheet() {
    Get.bottomSheet(
      CreateTaskSheet(
        onCreate: ({
          required String title,
          String? description,
          String? status,
          String? priority,
          String? projectId,
          List<String>? labels,
        }) async {
          final newTask = await api.createTask(
            title: title,
            description: description,
            status: status,
            priority: priority,
            projectId: projectId,
            labels: labels,
          );
          if (newTask != null) {
            // Refresh data in Home and Tasks
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().fetchHomeData();
            }
            if (Get.isRegistered<TasksController>()) {
              Get.find<TasksController>().fetchTasks();
            }
          }
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void openWorkspaceSwitcher() {
    Get.bottomSheet(
      WorkspaceSwitcherSheet(
        workspaces: api.availableWorkspaces,
        currentWorkspace: currentWorkspace,
        onSelectWorkspace: (ws) {
          Get.back();
          switchWorkspace(ws);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void switchWorkspace(WorkspaceModel ws) async {
    if (currentWorkspace?.id == ws.id) return;
    await api.switchWorkspace(ws);

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().fetchHomeData();
    }
    if (Get.isRegistered<TasksController>()) {
      Get.find<TasksController>().fetchTasks();
    }
    if (Get.isRegistered<InboxController>()) {
      Get.find<InboxController>().fetchNotifications();
    }
    if (Get.isRegistered<CyclesController>()) {
      Get.find<CyclesController>().fetchData();
    }

    Get.snackbar(
      'Workspace Switched',
      'Now working in ${ws.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface3,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void openNavigationDrawer() {
    final ws = currentWorkspace;
    final user = currentUser;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
          border: Border(top: BorderSide(color: AppColors.borderDefault)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
            InkWell(
              onTap: () {
                Get.back();
                openWorkspaceSwitcher();
              },
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Row(
                  children: [
                    UserAvatar(avatarUrl: user?.avatarUrl, name: user?.name, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ws?.name ?? 'Eunomia Workspace',
                            style: AppTheme.headlineSm,
                          ),
                          Text(
                            user?.email ?? '',
                            style: AppTheme.bodySm.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const AppSvg(
                      AppSvgIcons.chevronDown,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.borderDefault, height: 1),
            const SizedBox(height: 12),
            _buildDrawerItem(
              icon: AppSvgIcons.cube,
              title: 'Switch Workspace',
              onTap: () {
                Get.back();
                openWorkspaceSwitcher();
              },
            ),
            _buildDrawerItem(
              icon: AppSvgIcons.pulse,
              title: 'Overview & Activity',
              onTap: () {
                Get.back();
                switchTab(0);
              },
            ),
            _buildDrawerItem(
              icon: AppSvgIcons.myIssues,
              title: 'Tasks & Issues',
              onTap: () {
                Get.back();
                switchTab(1);
              },
            ),
            _buildDrawerItem(
              icon: AppSvgIcons.navInbox,
              title: 'Inbox',
              onTap: () {
                Get.back();
                switchTab(2);
              },
            ),
            if (cyclesEnabled)
              _buildDrawerItem(
                icon: AppSvgIcons.switchCycles,
                title: 'Cycles & Sprints',
                onTap: () {
                  Get.back();
                  switchTab(3);
                },
              ),
            _buildDrawerItem(
              icon: AppSvgIcons.shield,
              title: 'Performance Indicators (Admin)',
              onTap: () {
                Get.back();
                Get.toNamed(Routes.ADMIN_PERFORMANCE);
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildDrawerItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            AppSvg(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTheme.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const AppSvg(AppSvgIcons.chevronRight, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void openProfileMenu() {
    final user = currentUser;
    final ws = currentWorkspace;

    Get.bottomSheet(
      Container(
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
                UserAvatar(avatarUrl: user?.avatarUrl, name: user?.name, size: 42),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'User', style: AppTheme.headlineSm),
                      Text(user?.email ?? '', style: AppTheme.bodySm.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
                if (ws?.role != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surface3,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                    ),
                    child: Text(
                      ws!.role!,
                      style: AppTheme.labelMonoSm.copyWith(
                        fontSize: 10,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: AppColors.borderDefault, height: 1),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final token = await FirebaseMessaging.instance.getToken();
                if (token != null && token.isNotEmpty) {
                  await Clipboard.setData(ClipboardData(text: token));
                  Get.snackbar(
                    'FCM Token Copied',
                    'FCM registration token copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.surface3,
                    colorText: AppColors.textPrimary,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    duration: const Duration(seconds: 3),
                  );
                } else {
                  Get.snackbar(
                    'Token Not Found',
                    'Could not retrieve FCM token. Ensure internet is connected.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.surface3,
                    colorText: AppColors.priorityUrgent,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                }
              },
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  children: [
                    const AppSvg(AppSvgIcons.copy, size: 18, color: AppColors.primaryLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Copy FCM Device Token', style: AppTheme.bodyMd),
                          Text('Paste into Firebase Console for testing',
                              style: AppTheme.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                    const AppSvg(AppSvgIcons.chevronRight, size: 14, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                Get.back();
                Get.toNamed(Routes.ADMIN_PERFORMANCE);
              },
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  children: [
                    const AppSvg(AppSvgIcons.chart, size: 18, color: AppColors.primaryLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Admin Performance Analytics', style: AppTheme.bodyMd),
                    ),
                    const AppSvg(AppSvgIcons.chevronRight, size: 14, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  Get.back();
                  await api.logout();
                  Get.offAllNamed(Routes.AUTH);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.priorityBorder(AppColors.priorityUrgent)),
                  backgroundColor: AppColors.priorityTint(AppColors.priorityUrgent),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusDefault)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppSvg(AppSvgIcons.logOut, size: 16, color: AppColors.priorityUrgent),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: AppTheme.labelAction.copyWith(
                        color: AppColors.priorityUrgent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
