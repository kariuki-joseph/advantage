import 'dart:async';

import 'package:advantage/models/ad.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final myLat = 0.0.obs;
  final myLng = 0.0.obs;
  final isLoading = false.obs;

  StreamSubscription<Position>? _positionStreamSubscription;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 2,
  );

  final RxList<Ad> ads = RxList<Ad>();

  @override
  void onInit() {
    super.onInit();
    ever(myLat, (double lat) {
      debugPrint('lat: $lat');
    });
    ever(myLng, (double lng) {
      debugPrint('lng: $lng');
    });

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        myLat.value = position.latitude;
        myLng.value = position.longitude;
      },
    );

    /// initial configurations and checking for permissions
    initConfig();
    // get ads from firebase
    fetchAds();
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

  void _updateGeofence(Position position) {}

  // fetch ads from firebase
  Future<void> fetchAds() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot = await _firestore.collection("ads").get();
      if (snapshot.docs.isNotEmpty) {
        ads.value = Ad.fromQuerySnapshot(snapshot);
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
}
