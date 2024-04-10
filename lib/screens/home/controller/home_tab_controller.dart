import 'package:advantage/models/ad.dart';
import 'package:advantage/models/subscription.dart';
import 'package:advantage/models/user_model.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTabController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<RangeValues> rangeValues = Rx<RangeValues>(const RangeValues(1, 50));
  final ScrollController scrollController = ScrollController();
  final UserModel loggedInUser = Get.find<AuthController>().user.value;
  final LocationController locationController = Get.find<LocationController>();

  final TextEditingController searchController = TextEditingController();

  final subscriptions = <Subscription>[].obs;
  final RxList<Ad> ads = RxList<Ad>([]);
  final isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    // get ads when user adjusts search radius
    ever(rangeValues, (_) {
      getAdsWithRadius();
    });

    // listen to changes in user location and recalculate distances
    ever(locationController.userLocation, recalculateDistance);

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

  // get ads when users's geofence radius changes
  void getAdsWithRadius() {
    // get radius from min and max range values
    // ignore: unused_local_variable
    double radius = rangeValues.value.end - rangeValues.value.start;

    // get ads from firestore using GeoFlutterFire package
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

  // fetch ads from firebase
  Future<void> fetchAds() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot = await _firestore.collection("ads").get();
      ads.value = Ad.fromQuerySnapshot(snapshot);
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  recalculateDistance(_) {
    // recalculate distances once the location changes
    // update visibility of ads based on the geofence radius
    for (var ad in ads) {
      double distance = locationController.getDistance(ad.lat, ad.lng);
      ad.distance = distance;
      ad.isVisible = distance <= ad.discoveryRadius;
    }

    // sort in ascending order of distance
    ads.sort((a, b) => a.distance.compareTo(b.distance));
  }
}
