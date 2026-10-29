import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_service.dart';

class AdminPerformanceController extends GetxController {
  final ApiService api = ApiService.to;

  final performance = Rxn<AdminPerformanceModel>();
  final selectedPeriod = 'all'.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPerformance();
  }

  Future<void> fetchPerformance() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final wsId = api.currentWorkspace.value?.id;
      final data = await api.getAdminPerformance(
        workspaceId: wsId,
        period: selectedPeriod.value,
      );
      performance.value = data;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    fetchPerformance();
  }
}
