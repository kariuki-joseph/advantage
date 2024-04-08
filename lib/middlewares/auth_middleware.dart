import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // check if user is authenticated
    // redirect to login if user is not logged in
    final AuthController authController = Get.find<AuthController>();
    debugPrint("Checking if user is authenticated before accessing $route");
    if (!authController.isLoggedIn) {
      debugPrint("User is not authenticated");
      return const RouteSettings(name: AppRoutes.pinLogin);
    }

    debugPrint("User is authenticated");
    return null;
  }
}
