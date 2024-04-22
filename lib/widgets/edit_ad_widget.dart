import 'package:advantage/models/ad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class EditAdWidget extends StatelessWidget {
  final Function()? onDeleteAd;
  final Function()? onEditAd;
  final Ad ad;

  const EditAdWidget({
    super.key,
    required this.ad,
    required this.onDeleteAd,
    required this.onEditAd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
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
                    color: Get.theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    timeago.format(ad.createdAt),
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.directions_run,
                    size: 16,
                    color: Get.theme.colorScheme.primary,
                  ),
                  Text(
                    "${ad.distance.toStringAsFixed(2)}m",
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(width: 10),
                  Image.asset("images/geofence_radius.png"),
                  const SizedBox(width: 5),
                  Text(
                    "${ad.discoveryRadius.toStringAsFixed(2)}m",
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
                      text: "${ad.tags.join("#, ")} ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // text and call icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                  onPressed: onDeleteAd,
                  icon: const Icon(Icons.delete_outlined),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Get.theme.colorScheme.error,
                    ),
                    backgroundColor: Get.theme.colorScheme.onError,
                    foregroundColor: Get.theme.colorScheme.error,
                  ),
                  label: const Text("Delete"),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: onEditAd,
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    backgroundColor: Get.theme.colorScheme.primary,
                    foregroundColor: Get.theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
