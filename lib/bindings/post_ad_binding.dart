import 'package:advantage/screens/home/controller/home_page_controller.dart';
import 'package:advantage/screens/home/controller/home_tab_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/screens/home/controller/my_ads_controller.dart';
import 'package:advantage/screens/post_ad/controller/post_ad_controller.dart';
import 'package:get/get.dart';

class PostAdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostAdController>(() => PostAdController());
    Get.lazyPut<HomePageController>(() => HomePageController());
    Get.lazyPut<MyAdsController>(() => MyAdsController());
    Get.lazyPut<HomeTabController>(() => HomeTabController());
    Get.lazyPut(() => LocationController());
  }
}
