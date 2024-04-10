import 'package:advantage/constants/app_color.dart';
import 'package:advantage/models/ad.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class AdWidget extends StatelessWidget {
  final Ad ad;
  const AdWidget({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ad.isVisible ? Colors.white : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(
                ad.userName,
                style: const TextStyle(fontSize: 12),
              ),
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColor.primaryColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    timeago.format(ad.createdAt),
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Icon(
                    Icons.directions_run,
                    size: 16,
                    color: AppColor.primaryColor,
                  ),
                  Text(
                    "${ad.distance.toStringAsFixed(2)}m",
                    style: const TextStyle(fontSize: 11),
                  )
                ],
              ),
            ),
            Text(
              ad.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ad.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // text and call icons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text("Chat"),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                  label: const Text("Call"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
