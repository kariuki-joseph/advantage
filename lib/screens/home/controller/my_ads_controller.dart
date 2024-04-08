import 'dart:async';

import 'package:advantage/models/ad.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
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

  // initial location around DeKUT
  final myLat = (-0.3981185).obs;
  final myLng = 36.9612208.obs;

  StreamSubscription<Position>? _positionStreamSubscription;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 2, // notify me when I move 2 meters
  );

  @override
  void onInit() async {
    await fetchMyAds();

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        myLat.value = position.latitude;
        myLng.value = position.longitude;

        recalculateDistances();
      },
    );
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
      double distance = getDistance(ad.lat, ad.lng);
      ad.distance = distance;
      ad.isVisible = distance <= ad.discoveryRadius;
    }

    // sort in ascending order of distance
    myAds.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // geting the distance between two points
  double getDistance(double lat1, double lng1) {
    double lat2 = myLat.value;
    double lng2 = myLng.value;
    double distanceInMeters =
        Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
    return distanceInMeters;
  }
}
