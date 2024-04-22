import 'dart:async';

import 'package:advantage/models/ad.dart';
import 'package:advantage/models/notification_model.dart';
import 'package:advantage/models/subscription.dart';
import 'package:advantage/models/user_model.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/screens/notifications/controllers/notifications_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTabController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<RangeValues> rangeValues = Rx<RangeValues>(const RangeValues(1, 30));
  final ScrollController scrollController = ScrollController();
  final UserModel loggedInUser = Get.find<AuthController>().user.value;
  final LocationController locationController = Get.find<LocationController>();
  final NotificationController notificationController =
      Get.find<NotificationController>();

  final TextEditingController searchController = TextEditingController();

  final subscriptions = <Subscription>[].obs;
  final RxList<Ad> ads = RxList<Ad>([]);
  final isLoading = false.obs;

  final geo = GeoFlutterFire();

  @override
  void onInit() async {
    super.onInit();

    // listen to changes in user location and recalculate distances
    ever(locationController.userLocation, (_) => getAdsWithRadius(true));
    // listen to changes in the search radius of the user and get ads within the radius
    ever(locationController.searchRadius, (_) => getAdsWithRadius(false));

    locationController.initConfig();
    locationController.getAndUpdateUserLocation();
    debugPrint("Ater finishing getting locatio upates");
    // get user's subscriptions
    await fetchSubscriptions();
    await getAdsWithRadius(false);
    // check user's notifications
    notificationController.fetchNotifications();
  }

  Future<void> addSubscription(String keyword) async {
    String subId = _firestore.collection("subscriptions").doc().id;

    Subscription subscription =
        Subscription(userId: loggedInUser.id, keyword: keyword, id: subId);
    // add subscription to this keyword
    await _firestore
        .collection("subscriptions")
        .doc(subId)
        .set(subscription.toMap());
    subscriptions.add(subscription);
    searchController.text = "";
  }

  // get user's subscriptions from firestore
  Future<void> fetchSubscriptions() async {
    QuerySnapshot snapshot = await _firestore
        .collection("subscriptions")
        .where("userId", isEqualTo: loggedInUser.id)
        .get();
    debugPrint("userId: ${loggedInUser.id}, Len: ${snapshot.docs.length}");
    if (snapshot.docs.isNotEmpty) {
      subscriptions.value = Subscription.fromQuerySnapshot(snapshot);
    }
  }

  // delete a subscription from database
  Future<void> deleteSubscription(Subscription subscription) async {
    try {
      _firestore.collection("subscriptions").doc(subscription.id).delete();
      subscriptions.remove(subscription);
      // remove from already notified ads matching this subscription
      notificationController.alreadyNotifiedAds.removeWhere((ad) =>
          ad.tags.contains(subscription.keyword) ||
          ad.title.contains(subscription.keyword));
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  void recalculateDistance() {
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

  // fetching ads from firebase using geopoints
  Future<void> fetchAds() async {
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
      recalculateDistance();
      debugPrint(
          " Got ads within radius: ${locationController.searchRadius.value}");
    });

    subscription.onDone(() {
      isLoading.value = false;
    });
  }

  // get ads when users's geofence radius changes
  Future<void> getAdsWithRadius(bool auto) async {
    if (auto) {
      Fluttertoast.showToast(msg: "Recalculating...");
    }
    isLoading.value = true;
    try {
      QuerySnapshot snapshot = await _firestore.collection("ads").get();
      ads.value = Ad.fromQuerySnapshot(snapshot);
      recalculateDistance();
      checkSubscriptions();
    } catch (e) {
      showErrorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // check if there is any ad that matches the subscriptions of the user
  void checkSubscriptions() {
    for (var sub in subscriptions) {
      for (var ad in ads) {
        if (!ad.isVisible) continue;
        if (ad.title.toLowerCase().contains(sub.keyword.toLowerCase()) ||
            ad.description.toLowerCase().contains(sub.keyword.toLowerCase())) {
          // check if user has already been notified about this ad
          if (!notificationController.alreadyNotifiedAds.contains(ad)) {
            createNotification(ad, sub);
            notificationController.alreadyNotifiedAds.add(ad);
          }
          // don't check for tags for this ad. Just show the notification
          continue;
        }
        // check for matching tags
        for (var tag in ad.tags) {
          if (tag.toLowerCase().contains(sub.keyword.toLowerCase())) {
            // check if user has already been notified about this ad
            if (!notificationController.alreadyNotifiedAds.contains(ad)) {
              createNotification(ad, sub);
              notificationController.alreadyNotifiedAds.add(ad);
            }
          }
        }
      }
    }
  }

  // create notification
  void createNotification(Ad ad, Subscription sub) {
    NotificationModel notification = NotificationModel(
      id: _firestore.collection("notifications").doc().id,
      senderId: ad.userId,
      senderName: ad.userName,
      receiverId: loggedInUser.id,
      createdAt: DateTime.now(),
      title: 'New Match Found',
      description:
          'A new Ad matching your search subscription \'${sub.keyword}\' has been found. Check it out!',
      isRead: false,
    );

    notificationController.createNotification(notification);
  }

// start in-app chat with advertiser
  void startChat(String receiverId) {
    Get.toNamed(AppRoutes.chat, arguments: receiverId);
  }

  void callUser(String phoneNumber) async {
    // launch phone call intent on mobile devices
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      showErrorToast('Could not launch phone call');
    }
  }
}
