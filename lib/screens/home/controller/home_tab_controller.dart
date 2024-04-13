import 'dart:async';

import 'package:advantage/models/ad.dart';
import 'package:advantage/models/subscription.dart';
import 'package:advantage/models/user_model.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';

class HomeTabController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<RangeValues> rangeValues = Rx<RangeValues>(const RangeValues(1, 30));
  final ScrollController scrollController = ScrollController();
  final UserModel loggedInUser = Get.find<AuthController>().user.value;
  final LocationController locationController = Get.find<LocationController>();

  final TextEditingController searchController = TextEditingController();

  final subscriptions = <Subscription>[].obs;
  final RxList<Ad> ads = RxList<Ad>([]);
  final isLoading = false.obs;

  final geo = GeoFlutterFire();

  @override
  void onInit() async {
    super.onInit();

    // listen to changes in user location and recalculate distances
    ever(locationController.userLocation, (_) => getAdsWithRadius());
    // listen to changes in the search radius of the user and get ads within the radius
    ever(locationController.searchRadius, (_) => getAdsWithRadius());

    await locationController.initConfig();
    // get user's subscriptions
    await fetchSubscriptions();
    await fetchAds();
  }

  Future<void> addSubscription(String keyword) async {
    String subId = _firestore.collection("subscriptions").doc().id;

    Subscription subscription =
        Subscription(userId: loggedInUser.id, keyword: keyword, id: subId);
    // add subscription to this keyword
    _firestore.collection("subscriptions").doc(subId).set(subscription.toMap());
    subscriptions.add(subscription);
    searchController.text = "";
  }

  // get user's subscriptions from firestore
  Future<void> fetchSubscriptions() async {
    QuerySnapshot snapshot = await _firestore
        .collection("subscriptions")
        .where("userId", isEqualTo: loggedInUser.id)
        .get();
    if (snapshot.docs.isNotEmpty) {
      subscriptions.value = Subscription.fromQuerySnapshot(snapshot);
    }
  }

  // delete a subscription from database
  Future<void> deleteSubscription(Subscription subscription) async {
    try {
      _firestore.collection("subscriptions").doc(subscription.id).delete();
      subscriptions.remove(subscription);
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  void refreshDistance() {
    // recalculate distances once the location changes
    // update visibility of ads based on the geofence radius
    for (var ad in ads) {
      double distance = locationController.getDistance(ad.lat, ad.lng);
      ad.distance = distance;
      ad.isVisible = distance <=
          ad.discoveryRadius + locationController.searchRadius.value;
    }

    // sort in ascending order of distance
    ads.sort((a, b) => a.distance.compareTo(b.distance));
  }

  // fetch ads from firebase
  Future<void> fetchAds() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot = await _firestore.collection("ads").get();
      ads.value = Ad.fromQuerySnapshot(snapshot);
      refreshDistance();
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // get ads when users's geofence radius changes
  Future<void> getAdsWithRadius() async {
    isLoading.value = true;
    // create a geofence collection reference
    GeoFireCollectionRef collectionRef =
        GeoFireCollectionRef(_firestore.collection("ads"));

    GeoFirePoint center = GeoFirePoint(
      locationController.userLocation.value.latitude,
      locationController.userLocation.value.longitude,
    );
    GeoFirePoint centerGeoPoint =
        geo.point(latitude: center.latitude, longitude: center.longitude);

    Stream<List<DocumentSnapshot>> stream = collectionRef.within(
      center: centerGeoPoint,
      radius: locationController.searchRadius.value / 1000, // convert to km
      field: "location",
      strictMode: true,
    );

    StreamSubscription subscription =
        stream.listen((List<DocumentSnapshot> documentList) {
      isLoading.value = false;
      debugPrint(" Got ads within radius: ${documentList.length}");
      // update the ads with the new list
      ads.value = documentList.map((doc) => Ad.fromDocument(doc)).toList();
      refreshDistance();
    });

    subscription.onDone(() {
      isLoading.value = false;
    });
  }
}
