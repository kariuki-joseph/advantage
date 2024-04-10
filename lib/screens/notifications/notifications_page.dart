import 'package:advantage/models/ad_notification.dart';
import 'package:advantage/widgets/notification_item_widget.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final List<AdNotification> notifications = [
    AdNotification(
      adId: "1",
      senderId: "1",
      senderName: "John Doe",
      receiverId: "2",
      title: 'New Match Found',
      description:
          'A new Ad matching your search subscription \'${"#MoneyMaking"}\' has been found. Check it out!',
      createdAt: DateTime.now().subtract(
        const Duration(minutes: 1),
      ),
      isRead: false,
    ),
    AdNotification(
        adId: "1",
        senderId: "1",
        senderName: "John Doe",
        receiverId: "2",
        title: 'New Match Found2',
        description:
            'A new Ad matching your search subscription \'${"#MoneyMaking"}\' has been found. Check it out!',
        createdAt: DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
        isRead: true),
    AdNotification(
      adId: "1",
      senderId: "1",
      senderName: "John Doe",
      receiverId: "2",
      title: 'New Match Found3',
      description:
          'A new Ad matching your search subscription \'${"#MoneyMaking"}\' has been found. Check it out!',
      createdAt: DateTime.now().subtract(
        const Duration(minutes: 1),
      ),
      isRead: true,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              notifications.length,
              (index) => NotificationItemWidget(
                notification: notifications[index],
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
