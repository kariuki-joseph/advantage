import 'dart:async';

import 'package:advantage/models/lat_lng.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  final Rx<LatLng> userLocation = Rx<LatLng>(LatLng(0.0, 0.0));
  StreamSubscription<Position>? _positionStreamSubscription;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1, // notify me when I move 2 meters
  );
  GeoPoint userGeoPoint = const GeoPoint(0, 0);
  // search radius of the user in km (default is 30m)
  final RxDouble searchRadius = 30.0.obs;

  Future<void> initConfig() async {
    // listen to user location changes
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        userLocation.value.latitude = position.latitude;
        userLocation.value.longitude = position.longitude;
        // print user location
        debugPrint(
            "Current Location: ${userLocation.value.latitude}, ${userLocation.value.longitude}");
        //  update user geopoint
        userGeoPoint =
            GeoPoint(userLocation.value.latitude, userLocation.value.longitude);
      },
    );

    // request location permission
    if (await Permission.location.request().isGranted) {
      // get current location
      Position position = await _determinePosition();
      userLocation.value.latitude = position.latitude;
      userLocation.value.longitude = position.longitude;
    } else {
      // request permission
      Permission.location.request();
    }
  }

  void setUserLocation(double lat, double lng) {
    userLocation.value = LatLng(lat, lng);
  }

  // function to manually get the live position of a user
  Future<Position> getAndUpdateUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    userLocation.value.latitude = position.latitude;
    userLocation.value.longitude = position.longitude;
    return position;
  }

  Future<void> checkAndRequestLocationPermissions() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permissions are denied. Please enable it in settings',
        );
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    await checkAndRequestLocationPermissions();

    // at this point we know that we have permission. Request location for the user
    return await Geolocator.getCurrentPosition();
  }

  // geting the distance between two points
  double getDistance(double lat1, double lng1) {
    return Geolocator.distanceBetween(
      lat1,
      lng1,
      userLocation.value.latitude,
      userLocation.value.longitude,
    );
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    super.onClose();
  }
}
