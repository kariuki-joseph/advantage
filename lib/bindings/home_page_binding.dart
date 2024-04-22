import 'package:advantage/screens/home/controller/home_page_controller.dart';
import 'package:advantage/screens/home/controller/home_tab_controller.dart';
import 'package:advantage/screens/home/controller/messages_controller.dart';
import 'package:advantage/screens/notifications/controllers/notifications_controller.dart';
import 'package:get/get.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(() => HomePageController());
    Get.lazyPut(() => HomeTabController());
    Get.lazyPut(() => NotificationController());
    Get.lazyPut(() => MessagesController());
  }
}
