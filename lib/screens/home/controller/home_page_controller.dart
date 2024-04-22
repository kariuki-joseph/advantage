import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  // initial location around DeKUT
  final LocationController locationController = Get.find<LocationController>();
  @override
  void onInit() {
    // get ads from firebase
    debugPrint(
        "Current Location: ${locationController.userLocation.value.latitude} ${locationController.userLocation.value.longitude}");
    super.onInit();

    locationController.initConfig();
  }
}
