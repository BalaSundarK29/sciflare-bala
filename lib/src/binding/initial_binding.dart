import 'package:get/get.dart';
import 'package:sciflare/src/controller/home_controller.dart';
import 'package:sciflare/src/database/database_services.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DatabaseHelper>(DatabaseHelper());
    Get.put(HomeController());
  }
}
