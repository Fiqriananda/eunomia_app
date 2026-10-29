import 'package:get/get.dart';
import '../../cycles/controllers/cycles_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<TasksController>(() => TasksController());
    Get.lazyPut<InboxController>(() => InboxController());
    Get.lazyPut<CyclesController>(() => CyclesController());
  }
}
