import 'dart:async';

import 'package:advantage/models/user_model.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Add this line

class PinLoginController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final loginPin = [].obs;
  String savedPin = "";
  final String phoneNumber; // Add phone number
  late final bool isOnline;
  final isLoading = false.obs; // When loading from the internet
  final isPinWrong = false.obs;
  final isLoginSuccess = false.obs;
  Timer? _timer;

  PinLoginController({required this.phoneNumber});

  @override
  void onInit() async {
    // get user from shared prefs
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    savedPin = prefs.getString("pin") ?? "";

    // if user has no saved pin, proceed to login via phone first
    if (savedPin.isEmpty && phoneNumber.isEmpty) {
      Get.offAllNamed(AppRoutes.phoneLogin);
      return;
    }

    // update if user is online or not
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    isOnline = !connectivityResult.contains(ConnectivityResult.none);

    // listen for pin input
    if (savedPin.isNotEmpty) {
      ever(loginPin, (_) async {
        // don't listen to pin when it is loading
        if (isLoading.value || loginPin.length < 4) {
          return;
        }

        isPinWrong.value = false;

        if (savedPin != loginPin.join('')) {
          await Future.delayed(const Duration(milliseconds: 100));
          isPinWrong.value = true;
          await Future.delayed(const Duration(milliseconds: 1500));
          isPinWrong.value = false;
          loginPin.clear();
          return;
        }

        // else pin is correct. Proceed to Home
        isLoginSuccess.value = true;
        loginPin.addAll([1, 2, 3, 4]); // for animation purpose
        await Future.delayed(const Duration(milliseconds: 200), () {});
        loginPin.clear();

        Get.toNamed(AppRoutes.home);
      });
    } else {
      // User is logging in for the first time. Get the pin from database
      ever(loginPin, (_) async {
        // don't listen when loading state is active
        if (isLoading.value || loginPin.length < 4) {
          return;
        }

        if (isPinWrong.value) {
          isPinWrong.value = false;
        }

        if (!isOnline) {
          showErrorToast("No internet connection. Please try again later");
          return;
        }

        // Internet connection available
        // Check pin from internet
        // start animation
        isLoading.value = true;
        _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          if (loginPin.length < 4) {
            loginPin.add(1);
          } else {
            loginPin.clear();
          }
        });

        try {
          final QuerySnapshot result = await FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: phoneNumber)
              .where('pin', isEqualTo: loginPin.join(''))
              .get();

          if (result.docs.isEmpty) {
            // Incorrect pin. Retry
            isPinWrong.value = true;
            _timer?.cancel();
            loginPin.addAll([1, 2, 3, 4]); // for animation purpose

            await Future.delayed(const Duration(milliseconds: 1500));
            isPinWrong.value = false;
            loginPin.clear();
            return;
          }

          // pin correct
          isLoginSuccess.value = true;
          _timer?.cancel();
          loginPin.addAll([1, 2, 3, 4]); // for animation purpose

          // update logged in user details
          authController.user.value = UserModel.fromDocument(result.docs.first);
          // save pin to shared prefs
          await authController.saveUserDetailsToSharedPrefs();

          // PIN correct. await for 1.5s to show success message
          await Future.delayed(const Duration(milliseconds: 1500));
          loginPin.clear();

          Get.offAllNamed(AppRoutes.home);
        } on Exception catch (e) {
          showErrorToast("Error: $e");
        } finally {
          isLoading.value = false;
          // end animatin
          _timer?.cancel();
        }
      });
    }

    super.onInit();
  }

  // delete last pin character
  void deleteLastPin() {
    if (loginPin.isNotEmpty) {
      loginPin.removeLast();
    }
  }

  // create pin loading animation

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
