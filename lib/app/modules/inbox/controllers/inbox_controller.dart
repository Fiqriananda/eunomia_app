import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class InboxController extends GetxController {
  final ApiService api = ApiService.to;

  final notifications = <NotificationItem>[].obs;
  final isLoading = false.obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final list = await api.getNotifications();
      notifications.assignAll(list);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markRead(String id) async {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      notifications[idx] = notifications[idx].copyWith(isRead: true);
    }
    await api.markNotificationRead(id);
  }

  Future<void> markAllRead() async {
    final updated = notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifications.assignAll(updated);
    await api.markAllNotificationsRead();
  }

  void openTask(String? taskId) {
    if (taskId != null && taskId.isNotEmpty) {
      Get.toNamed(Routes.TASK_DETAIL, arguments: {'taskId': taskId});
    }
  }
}
