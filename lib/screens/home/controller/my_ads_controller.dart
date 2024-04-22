import 'dart:async';

import 'package:advantage/models/ad.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MyAdsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Ad> myAds = RxList();
  final AuthController authController = Get.put(AuthController());
  final isLoading = false.obs;
  final loggedInUser = Get.find<AuthController>().user.value;
  final LocationController locationController = Get.find<LocationController>();

  @override
  void onInit() async {
    await fetchMyAds();

    super.onInit();
  }

  // get my ads
  Future<void> fetchMyAds() async {
    // clear existing ads
    myAds.clear();

    isLoading.value = true;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection("ads")
          .where("userId", isEqualTo: loggedInUser.phone)
          .get();
      if (snapshot.docs.isNotEmpty) {
        myAds.value = Ad.fromQuerySnapshot(snapshot);
        recalculateDistances();
      }
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // delete an ad
  Future<void> deleteAd(String adId) async {
    isLoading.value = true;

    try {
      await _firestore.collection("ads").doc(adId).delete();
      await fetchMyAds();
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // recalculate distances once the location changes
  void recalculateDistances() {
    // update visibility of ads based on the geofence radius
    for (var ad in myAds) {
      double distance = locationController.getDistance(ad.lat, ad.lng);
      ad.distance = distance;
    }

    // sort in ascending order of distance
    myAds.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
