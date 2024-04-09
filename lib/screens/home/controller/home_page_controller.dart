import 'dart:async';

import 'package:advantage/models/ad.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // initial location around DeKUT
  final myLat = (-0.3981185).obs;
  final myLng = 36.9612208.obs;

  final isLoading = false.obs;

  final Rx<RangeValues> rangeValues = Rx<RangeValues>(RangeValues(1, 50));

  StreamSubscription<Position>? _positionStreamSubscription;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 2, // notify me when I move 2 meters
  );

  final RxList<Ad> ads = RxList<Ad>();

  @override
  void onInit() {
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        myLat.value = position.latitude;
        myLng.value = position.longitude;

        recalculateDistances();
      },
    );

    // initial configurations and checking for permissions
    initConfig();
    // get ads from firebase
    fetchAds();

    // get ads when user adjusts search radius
    ever(rangeValues, (_) {
      getAdsWithRadius();
    });

    super.onInit();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            'Location permissions are denied. Please enable it in settings');
      }
    }

    // at this point we know that we have permission. Request location for the user
    return await Geolocator.getCurrentPosition();
  }

  void initConfig() async {
    // request location permission
    if (await Permission.location.request().isGranted) {
      // get current location
      Position position = await _determinePosition();
      myLat.value = position.latitude;
      myLng.value = position.longitude;
    } else {
      // request permission
      Permission.location.request();
    }
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    super.onClose();
  }

  // fetch ads from firebase
  Future<void> fetchAds() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot = await _firestore.collection("ads").get();
      if (snapshot.docs.isNotEmpty) {
        ads.value = Ad.fromQuerySnapshot(snapshot);
        recalculateDistances();
      }
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // geting the distance between two points
  double getDistance(double lat1, double lng1) {
    double lat2 = myLat.value;
    double lng2 = myLng.value;
    double distanceInMeters =
        Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
    return distanceInMeters;
  }

  // recalculate distances once the location changes
  void recalculateDistances() {
    // Fluttertoast.showToast(msg: "Recalculating distance....");

    // update visibility of ads based on the geofence radius
    for (var ad in ads) {
      double distance = getDistance(ad.lat, ad.lng);
      ad.distance = distance;
      ad.isVisible = distance <= ad.discoveryRadius;
    }

    // sort in ascending order of distance
    ads.sort((a, b) => a.distance.compareTo(b.distance));
  }

  // function to manually get the live position of a user
  void updateLiveLocation() async {
    Position position = await _determinePosition();
    myLat.value = position.latitude;
    myLng.value = position.longitude;
    debugPrint(
        "Location updated to: ${position.latitude}, ${position.longitude}");
    recalculateDistances();
  }

// get ads when users's geofence radius changes
  void getAdsWithRadius() {
    // get ads from firebase
    Fluttertoast.showToast(
        msg:
            "Getting ads within range: ${rangeValues.value.start}-${rangeValues.value.end}");
  }
}
