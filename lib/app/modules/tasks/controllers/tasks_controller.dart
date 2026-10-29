import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class TasksController extends GetxController {
  final ApiService api = ApiService.to;

  final tasks = <TaskModel>[].obs;
  final isLoading = false.obs;

  final selectedScope = 'all'.obs; // 'all', 'assigned_to_me', 'created_by_me'
  final selectedStatus = Rxn<String>();
  final selectedPriority = Rxn<String>();
  final selectedAssigneeId = Rxn<String>();
  final searchQuery = ''.obs;
  final isBoardView = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    try {
      final list = await api.getMobileTasks(
        filter: selectedScope.value,
        status: selectedStatus.value,
        priority: selectedPriority.value,
        assigneeId: selectedAssigneeId.value,
        search: searchQuery.value.trim().isEmpty ? null : searchQuery.value.trim(),
      );
      tasks.assignAll(list);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  List<TaskModel> get filteredTasks {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return tasks;
    return tasks.where((t) {
      return t.title.toLowerCase().contains(query) ||
          t.identifier.toLowerCase().contains(query) ||
          (t.project?.name.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  void setScope(String scope) {
    if (selectedScope.value == scope) return;
    selectedScope.value = scope;
    fetchTasks();
  }

  void filterByAssignee(String? assigneeId) {
    selectedAssigneeId.value = assigneeId;
    fetchTasks();
  }

  void filterByStatus(String? status) {
    if (selectedStatus.value == status) {
      selectedStatus.value = null;
    } else {
      selectedStatus.value = status;
    }
    fetchTasks();
  }

  void filterByPriority(String? priority) {
    if (selectedPriority.value == priority) {
      selectedPriority.value = null;
    } else {
      selectedPriority.value = priority;
    }
    fetchTasks();
  }

  void toggleViewMode() {
    isBoardView.value = !isBoardView.value;
  }

  Future<void> toggleStatus(TaskModel task) async {
    final nextStatus = task.status == TaskStatusEnum.done
        ? TaskStatusEnum.inProgress
        : TaskStatusEnum.done;

    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task.copyWith(status: nextStatus);
    }

    try {
      await api.updateTaskStatus(task.id, nextStatus.apiKey);
    } catch (_) {
      await fetchTasks();
    }
  }

  Future<void> cyclePriority(TaskModel task) async {
    final allPriorities = TaskPriorityEnum.values;
    final nextIdx = (allPriorities.indexOf(task.priority) + 1) % allPriorities.length;
    final nextPriority = allPriorities[nextIdx];

    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task.copyWith(priority: nextPriority);
    }

    try {
      await api.updateTaskPriority(task.id, nextPriority.apiKey);
    } catch (_) {
      await fetchTasks();
    }
  }

  void openTaskDetail(String taskId) {
    Get.toNamed(Routes.TASK_DETAIL, arguments: {'taskId': taskId});
  }
}
