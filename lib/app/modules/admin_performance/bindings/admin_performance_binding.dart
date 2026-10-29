import 'package:get/get.dart';

import '../controllers/admin_performance_controller.dart';

class AdminPerformanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminPerformanceController>(
      () => AdminPerformanceController(),
    );
  }
}
