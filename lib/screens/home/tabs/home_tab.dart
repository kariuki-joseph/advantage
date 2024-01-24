import 'package:advantage/constants/app_color.dart';
import 'package:advantage/models/ad.dart';
import 'package:advantage/screens/home/controller/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeTab extends StatelessWidget {
  final HomePageController controller = Get.put(HomePageController());

  HomeTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // search
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.searchBarBackground,
                  hintText: "Search",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("images/user_avatar.png"),
                    ),
                  ),
                  suffixIcon: null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Body
        Expanded(
          child: Obx(
            () {
              if (controller.ads.isEmpty && controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: controller.ads.length,
                  itemBuilder: (context, index) {
                    Ad ad = controller.ads[index];

                    return !ad.isVisible
                        ? const SizedBox
                            .shrink() // hide the ad if it is not visible
                        : Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage("images/user_avatar.png"),
                                    ),
                                    title: Text(
                                      ad.userName,
                                      style: const TextStyle(fontSize: 16),
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
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  // text and call icons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.chat_bubble_outline),
                                        label: const Text("Chat"),
                                      ),
                                      const SizedBox(width: 10),
                                      OutlinedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.call),
                                        label: const Text("Call"),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              AppColor.primaryColor,
                                          foregroundColor: Colors.white,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }
}
