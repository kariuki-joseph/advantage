import 'package:advantage/models/ad.dart';
import 'package:advantage/models/user_model.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/screens/home/controller/home_tab_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/screens/home/controller/my_ads_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PostAdController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find<AuthController>();
  final LocationController locationController = Get.find<LocationController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discoveryRadiusController =
      TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  final HomeTabController homeTabController = Get.find();
  final MyAdsController myAdsController = Get.find();

  final isLoading = false.obs;
  final isLocationLoading = false.obs;
  final isLocationSelected = false.obs;
  final locationError = false.obs;
  final tags = <String>[].obs;
  final int maxTags = 5;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late UserModel loggedInUser = Get.find<AuthController>().user.value;

  @override
  void onInit() async {
    discoveryRadiusController.text = "20";
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
    try {
      await locationController.getAndUpdateUserLocation();
    } on Exception catch (e) {
      locationError.value = true;
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isLocationLoading.value = false;
    }
  }

  Future<void> postAd() async {
    // check if user is logged in before posting an ad
    if (!formKey.currentState!.validate()) {
      debugPrint('Error in form');
      return;
    }
    String adId = _firestore.collection("ads").doc().id;
    // validate that location is not null
    if (locationController.userLocation.value.latitude == 0.0 ||
        locationController.userLocation.value.longitude == 0.0) {
      locationError.value = true;
      showErrorToast("Please select location");
      return;
    }

    // validate at least one tag
    if (tags.isEmpty) {
      showErrorToast("Please add at least one tag");
      return;
    }

    Ad ad = Ad(
      id: adId,
      title: titleController.text,
      description: descriptionController.text,
      lat: locationController.userLocation.value.latitude,
      lng: locationController.userLocation.value.longitude,
      createdAt: DateTime.now(),
      discoveryRadius: double.parse(discoveryRadiusController.text),
      userId: loggedInUser.phone,
      userName: loggedInUser.username,
      phoneNumber: loggedInUser.phone,
      tags: tags,
    );

    debugPrint("Ad: ${ad.toMap()}");
    try {
      isLoading.value = true;

      await _firestore.collection("ads").doc(adId).set(ad.toMap());
      isLoading.value = false;
      showSuccessToast("Ad posted successfully");
      _resetForm();

      // refresh the ads in home page
      homeTabController.fetchAds();
      myAdsController.fetchMyAds();
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
      Get.back();
    }
  }

  void _resetForm() {
    titleController.clear();
    descriptionController.clear();
    tagsController.clear();
    discoveryRadiusController.text = "20";
    tags.clear();
    isLocationSelected.value = false;
    locationError.value = false;
  }

// add tags to the list
  void addTag() {
    if (tagsController.text.isNotEmpty) {
      tags.add(tagsController.text);
      tagsController.clear();
    }
  }
}
