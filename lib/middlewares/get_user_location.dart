import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetUserLocation extends GetMiddleware {
  final LocationController locationController =
      Get.find(); // Get the instance of LocationController

  @override
  RouteSettings? redirect(String? route) {
    debugPrint("redirecting to location configuration");
    return super.redirect(route);
  }

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    debugPrint("Initializing location configuration");

    // Perform an asynchronous task
    await locationController.initConfig();

    return super.redirectDelegate(route);
  }
}
