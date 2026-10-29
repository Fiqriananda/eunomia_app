import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_service.dart';

class TaskDetailController extends GetxController {
  final ApiService api = ApiService.to;

  late final String taskId;
  final task = Rxn<TaskModel>();
  final subtasks = <SubtaskItem>[].obs;
  final comments = <CommentItem>[].obs;
  final isLoading = false.obs;

  final commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['taskId'] != null) {
      taskId = args['taskId'].toString();
    } else {
      taskId = Get.parameters['id'] ?? '';
    }
    if (taskId.isNotEmpty) {
      fetchDetail();
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    try {
      final t = await api.getMobileTaskDetail(taskId);
      task.value = t;
      subtasks.assignAll(t.subtasks);
      comments.assignAll(t.comments);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(TaskStatusEnum newStatus) async {
    if (task.value == null) return;
    task.value = task.value!.copyWith(status: newStatus);
    await api.updateTaskStatus(taskId, newStatus.apiKey);
  }

  Future<void> updatePriority(TaskPriorityEnum newPriority) async {
    if (task.value == null) return;
    task.value = task.value!.copyWith(priority: newPriority);
    await api.updateTaskPriority(taskId, newPriority.apiKey);
  }

  Future<void> addSubtask(String title) async {
    if (title.trim().isEmpty) return;
    final item = await api.createSubtask(taskId, title.trim());
    if (item != null) {
      subtasks.add(item);
    }
  }

  Future<void> sendComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) return;
    commentController.clear();
    final item = await api.addComment(taskId, content);
    if (item != null) {
      comments.insert(0, item);
    }
  }

  Future<void> toggleReaction(String emoji) async {
    await api.toggleTaskReaction(taskId, emoji);
    fetchDetail();
  }

  Future<void> deleteTask() async {
    await api.deleteTask(taskId);
    Get.back(result: true);
  }
}
