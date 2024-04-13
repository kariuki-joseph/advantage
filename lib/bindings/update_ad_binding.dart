import 'package:advantage/screens/home/controller/home_tab_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/screens/home/controller/my_ads_controller.dart';
import 'package:advantage/screens/update_ad/controller/controller/update_ad_controller.dart';
import 'package:get/get.dart';

class UpdateAdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateAdController>(() => UpdateAdController());
    Get.lazyPut<HomeTabController>(() => HomeTabController());
    Get.lazyPut<MyAdsController>(() => MyAdsController());
    Get.lazyPut(() => LocationController());
  }
}
