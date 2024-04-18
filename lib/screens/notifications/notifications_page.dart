import 'package:advantage/screens/notifications/controllers/notifications_controller.dart';
import 'package:advantage/widgets/notification_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});
  final NotificationController notificationController =
      Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: notificationController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : notificationController.notifications.isEmpty
                  ? const Center(
                      child: Text('You have no new notifications.'),
                    )
                  : Obx(
                      () => Column(
                        children: List.generate(
                            notificationController.notifications.length,
                            (index) {
                          return NotificationItemWidget(
                            notification:
                                notificationController.notifications[index],
                            isRead: notificationController
                                .notifications[index].isRead,
                            onTap: () {
                              notificationController.markAsRead(
                                  notificationController.notifications[index]);
                            },
                          );
                        }).toList(),
                      ),
                    ),
        ),
      ),
    );
  }
}
