import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class CyclesController extends GetxController {
  final ApiService api = ApiService.to;

  final cycles = <CycleModel>[].obs;
  final currentCycle = Rxn<CycleModel>();
  final members = <WorkspaceMemberModel>[].obs;
  final trash = <TaskModel>[].obs;

  final activeTab = 0.obs; // 0: Sprints, 1: Members, 2: Trash
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    final wsId = api.currentWorkspace.value?.id;
    try {
      final results = await Future.wait([
        api.getCycles(workspaceId: wsId),
        api.getCurrentCycle(workspaceId: wsId),
        if (wsId != null && wsId.isNotEmpty)
          api.getWorkspaceMembers(wsId)
        else
          Future.value(<WorkspaceMemberModel>[]),
        api.getTrash(),
      ]);

      cycles.assignAll(results[0] as List<CycleModel>);
      currentCycle.value = results[1] as CycleModel?;
      members.assignAll(results[2] as List<WorkspaceMemberModel>);
      trash.assignAll(results[3] as List<TaskModel>);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restoreTask(String id) async {
    trash.removeWhere((t) => t.id == id);
    await api.restoreTrash(id);
  }

  Future<void> purgeTask(String id) async {
    trash.removeWhere((t) => t.id == id);
    await api.permanentDeleteTask(id);
  }

  void openTask(String taskId) {
    Get.toNamed(Routes.TASK_DETAIL, arguments: {'taskId': taskId});
  }
}
