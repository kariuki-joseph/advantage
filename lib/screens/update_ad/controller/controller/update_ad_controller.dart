import 'package:advantage/models/ad.dart';
import 'package:advantage/screens/home/controller/home_tab_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/screens/home/controller/my_ads_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateAdController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final HomeTabController homeTabController = Get.put(HomeTabController());
  final MyAdsController myAdsController = Get.put(MyAdsController());
  final LocationController locationController = Get.find<LocationController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discoveryRadiusController =
      TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final isLoading = false.obs;
  final isLocationLoading = false.obs;
  final isLocationSelected = false.obs;
  final locationError = false.obs;
  final tags = <String>[].obs;
  final int maxTags = 5;

  final lat = 0.0.obs;
  final lng = 0.0.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final adToUpdate = Rx<Ad>(Ad(
    id: "",
    title: "",
    description: "",
    lat: 0.0,
    lng: 0.0,
    discoveryRadius: 0.0,
    userId: "",
    userName: "",
    createdAt: DateTime.now(),
  ));

  @override
  void onClose() {
    debugPrint("updateAdOnClose: ${adToUpdate.value}");
    titleController.dispose();
    descriptionController.dispose();
    discoveryRadiusController.dispose();
    lat.value = 0.0;
    lng.value = 0.0;

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

  Future<void> updateAd() async {
    if (formKey.currentState!.validate()) {
      String adId = adToUpdate.value.id;
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
        createdAt: adToUpdate.value.createdAt,
        discoveryRadius: double.parse(discoveryRadiusController.text),
        userId: adToUpdate.value.userId,
        userName: adToUpdate.value.userName,
        phoneNumber: adToUpdate.value.phoneNumber,
        tags: tags,
      );

      try {
        isLoading.value = true;

        await _firestore.collection("ads").doc(adId).update(ad.toMap());

        isLoading.value = false;
        // load the new ad in home page and my ads
        homeTabController.fetchAds();
        myAdsController.fetchMyAds();
        Fluttertoast.showToast(msg: "Ad updated successfully");
      } catch (e) {
        showErrorToast(e.toString());
      } finally {
        isLoading.value = false;
        Get.back();
      }
    }
  }

  void setAdToUpdate(Ad ad) {
    adToUpdate.value = ad;
    titleController.text = adToUpdate.value.title;
    descriptionController.text = adToUpdate.value.description;
    discoveryRadiusController.text =
        adToUpdate.value.discoveryRadius.toString();
    lat.value = adToUpdate.value.lat;
    lng.value = adToUpdate.value.lng;
    isLocationSelected.value = true;
    tags.assignAll(ad.tags);
  }

  // add tags to the list
  void addTag() {
    if (tagsController.text.isNotEmpty) {
      tags.add(tagsController.text);
      tagsController.clear();
    }
  }
}
