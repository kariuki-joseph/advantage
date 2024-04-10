import 'dart:async';

import 'package:advantage/models/lat_lng.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  final Rx<LatLng> userLocation = Rx<LatLng>(LatLng((-0.3981185), 36.9612208));
  StreamSubscription<Position>? _positionStreamSubscription;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 2, // notify me when I move 2 meters
  );

  @override
  void onInit() {
    super.onInit();
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        userLocation.value.latitude = position.latitude;
        userLocation.value.longitude = position.longitude;
      },
    );
    // initial configurations and checking for permissions
    initConfig();
  }

  void setUserLocation(double lat, double lng) {
    userLocation.value = LatLng(lat, lng);
  }

  // function to manually get the live position of a user
  void updateLiveLocation() async {
    Position position = await _determinePosition();
    userLocation.value.latitude = position.latitude;
    userLocation.value.longitude = position.longitude;
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
      userLocation.value.latitude = position.latitude;
      userLocation.value.longitude = position.longitude;
    } else {
      // request permission
      Permission.location.request();
    }
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
