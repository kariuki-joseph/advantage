import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:get/get.dart';

class SetLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationController());
  }
}
