import 'package:get/get.dart';

import '../controllers/cycles_controller.dart';

class CyclesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CyclesController>(
      () => CyclesController(),
    );
  }
}
