import 'package:advantage/models/ad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class AdWidget extends StatelessWidget {
  final Ad ad;
  final Function() onChat;
  final Function() onCall;
  const AdWidget({
    super.key,
    required this.ad,
    required this.onChat,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    timeago.format(ad.createdAt, locale: 'en_short'),
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.directions_run,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
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
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                text: "Tags: ",
                style: Get.theme.textTheme.bodyMedium,
                children: <TextSpan>[
                  if (ad.tags.isNotEmpty) ...[
                    TextSpan(
                      text: '#',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: "${ad.tags.join(", #")} ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            // text and call icons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: onChat,
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text("Chat"),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: onCall,
                  icon: const Icon(Icons.call),
                  label: const Text("Call"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.primary,
                    foregroundColor: Get.theme.colorScheme.onPrimary,
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
