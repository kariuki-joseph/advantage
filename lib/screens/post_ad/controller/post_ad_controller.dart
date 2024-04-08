import 'package:advantage/models/ad.dart';
import 'package:advantage/models/user_model.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/screens/home/controller/home_page_controller.dart';
import 'package:advantage/screens/home/controller/my_ads_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PostAdController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.put(AuthController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discoveryRadiusController =
      TextEditingController();
  final HomePageController homePageController = Get.find();
  final MyAdsController myAdsController = Get.find();

  final isLoading = false.obs;
  final isLocationLoading = false.obs;
  final isLocationSelected = false.obs;
  final locationError = false.obs;

  final lat = 0.0.obs;
  final lng = 0.0.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late UserModel loggedInUser = Get.find<AuthController>().user.value;

  @override
  void onInit() async {
    discoveryRadiusController.text = "5";
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    discoveryRadiusController.dispose();
    super.onClose();
  }

  Future<void> getLocation() async {
    isLocationLoading.value = true;
    if (await Permission.location.request().isGranted) {
      Fluttertoast.showToast(msg: "Geting location...");
      final position = await Geolocator.getCurrentPosition();
      lat.value = position.latitude;
      lng.value = position.longitude;
      isLocationLoading.value = false;
      isLocationSelected.value = true;
      locationError.value = false;
      Fluttertoast.showToast(msg: "Location selected successfully");
    } else {
      isLocationSelected.value = false;
      locationError.value = true;
      isLocationLoading.value = false;
      Fluttertoast.showToast(msg: "Please enable location permission");
      // request permissions
      await Permission.location.request();
      getLocation();
    }
  }

  Future<void> postAd() async {
    // check if user is logged in before posting an ad
    if (loggedInUser.phone == '') {
      Fluttertoast.showToast(
          msg: "You must be logged in to post", toastLength: Toast.LENGTH_LONG);
      return;
    }

    if (formKey.currentState!.validate()) {
      String adId = _firestore.collection("ads").doc().id;
      // validate that location is not null
      if (lat.value == 0.0 || lng.value == 0.0) {
        locationError.value = true;
        showErrorToast("Please select location");
        return;
      }

      Ad ad = Ad(
        id: adId,
        title: titleController.text,
        description: descriptionController.text,
        lat: lat.value,
        lng: lng.value,
        createdAt: DateTime.now(),
        discoveryRadius: double.parse(discoveryRadiusController.text),
        userId: loggedInUser.phone == "" ? "123" : loggedInUser.phone,
        userName:
            loggedInUser.username == "" ? "Test User" : loggedInUser.username,
      );
      try {
        isLoading.value = true;

        await _firestore.collection("ads").doc(adId).set(ad.toMap());
        isLoading.value = false;
        showSuccessToast("Ad posted successfully");
        _resetForm();

        // refresh the ads in home page
        homePageController.fetchAds();
        myAdsController.fetchMyAds();
      } catch (e) {
        showErrorToast(e.toString());
      } finally {
        isLoading.value = false;
        Get.back();
      }
    }
  }

  void _resetForm() {
    titleController.clear();
    descriptionController.clear();
    lat.value = 0.0;
    lng.value = 0.0;
    isLocationSelected.value = false;
    locationError.value = false;
  }
}
