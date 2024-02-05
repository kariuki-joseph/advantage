import 'dart:ffi';

import 'package:advantage/models/ad.dart';
import 'package:advantage/models/user_model.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAdsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Ad> myAds = RxList();
  final AuthController authController = Get.put(AuthController());
  final isLoading = false.obs;
  final loggedInUser = Rx<UserModel>(UserModel());

  @override
  void onInit() async {
    loggedInUser.value = await authController.getUserDetailsFromSharedPrefs();

    await fetchMyAds();

    super.onInit();
  }

  // get my ads
  Future<void> fetchMyAds() async {
    debugPrint("fetchMyAds: ${loggedInUser.value.phone}");
    // clear existing ads
    myAds.clear();

    UserModel user = loggedInUser.value;
    isLoading.value = true;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection("ads")
          .where("userId", isEqualTo: user.phone)
          .get();
      if (snapshot.docs.isNotEmpty) {
        myAds.value = Ad.fromQuerySnapshot(snapshot);
      }
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
