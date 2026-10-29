import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final ApiService api = ApiService.to;

  final isLoading = false.obs;
  final homeData = Rxn<HomeDataModel>();
  final currentCycle = Rxn<CycleModel>();

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      final wsId = api.currentWorkspace.value?.id;
      final results = await Future.wait([
        api.getMobileHome(workspaceId: wsId),
        api.getCurrentCycle(workspaceId: wsId),
      ]);
      homeData.value = results[0] as HomeDataModel;
      currentCycle.value = results[1] as CycleModel?;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    final nextStatus = task.status == TaskStatusEnum.done
        ? TaskStatusEnum.inProgress
        : TaskStatusEnum.done;

    if (homeData.value != null) {
      final updatedAssigned = homeData.value!.myAssignedTasks.map((t) {
        if (t.id == task.id) {
          return t.copyWith(status: nextStatus);
        }
        return t;
      }).toList();
      homeData.value = homeData.value!.copyWith(myAssignedTasks: updatedAssigned);
    }

    try {
      await api.updateTaskStatus(task.id, nextStatus.apiKey);
    } catch (_) {
      await fetchHomeData();
    }
  }

  void openTaskDetail(String taskId) {
    Get.toNamed(Routes.TASK_DETAIL, arguments: {'taskId': taskId});
  }
}
