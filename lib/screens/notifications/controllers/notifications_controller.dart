import 'package:advantage/models/notification_model.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = RxList<NotificationModel>([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find<AuthController>();
  final isLoading = false.obs;
  final RxInt unreadNotifications = 0.obs;
  final Set<String> alreadyNotifiedAds = <String>{};

  @override
  void onInit() {
    super.onInit();
    ever(notifications, (_) => getUnreadNotificationsCount());

    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("notifications")
          .where("receiverId", isEqualTo: authController.user.value.id)
          .get();
      if (snapshot.docs.isNotEmpty) {
        notifications.value = NotificationModel.fromQuerySnapshot(snapshot);
        sortNotifications();
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    isLoading.value = true;
    try {
      _firestore.collection("notifications").doc(notification.id).delete();
      notifications.remove(notification);
      fetchNotifications();
    } catch (e) {
      Get.snackbar("Error", "Failed to delete notification");
    } finally {
      isLoading.value = false;
    }
  }

  // create new notification
  Future<void> createNotification(NotificationModel notification) async {
    debugPrint("Creating notification....");
    isLoading.value = true;
    try {
      await _firestore
          .collection("notifications")
          .doc(notification.id)
          .set(notification.toMap());
      notifications.add(notification);
      // vibrate to alert user of new notification
      vibrateAlert();
    } catch (e) {
      Get.snackbar("Error", "Failed to create notification");
    } finally {
      isLoading.value = false;
    }
  }

  // mark notification as read
  Future<void> markAsRead(NotificationModel notification) async {
    isLoading.value = true;
    try {
      await _firestore
          .collection("notifications")
          .doc(notification.id)
          .update({"isRead": true});

      // update notiication as read in all notiications list
      notifications
          .firstWhere((element) => element.id == notification.id)
          .isRead = true;
    } catch (e) {
      Get.snackbar("Error", "Failed to mark notification as read");
    } finally {
      isLoading.value = false;
    }
  }

  // mark all notifications as read
  Future<void> markAllAsRead() async {
    isLoading.value = true;
    try {
      WriteBatch batch = _firestore.batch();

      for (var notification in notifications) {
        DocumentReference docRef =
            _firestore.collection("notifications").doc(notification.id);
        batch.update(docRef, {"isRead": true});
      }

      await batch.commit();
      await fetchNotifications();
    } catch (e) {
      Get.snackbar("Error", "Failed to mark all notifications as read");
    } finally {
      isLoading.value = false;
    }
  }

  // get unread notifications count
  void getUnreadNotificationsCount() {
    unreadNotifications.value =
        notifications.where((notification) => !notification.isRead).length;
  }

  // vibrate to alert user of new notification
  void vibrateAlert() {
    HapticFeedback.vibrate();
  }

  // sort, by time
  void sortNotifications() {
    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
