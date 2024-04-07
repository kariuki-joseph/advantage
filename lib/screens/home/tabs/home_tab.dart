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
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.searchBarBackground,
                  hintText: "Search",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none),
                  prefixIcon: GestureDetector(
                    onTap: () {
                      // do nothing
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 1, 0),
                      // user icon
                      child: Icon(Icons.account_circle),
                    ),
                  ),
                  suffixIcon: null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                controller.fetchAds();
                controller.updateLiveLocation();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset("images/refresh.png", width: 40, height: 40),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        const Center(child: Text("Adjust Search Radius")),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => RangeSlider(
                  values: controller.rangeValues.value,
                  onChanged: (RangeValues values) {
                    controller.rangeValues.value = values;
                  },
                  min: 0,
                  max: 100,
                  divisions: 100,
                  labels: RangeLabels(
                    controller.rangeValues.value.start.round().toString(),
                    controller.rangeValues.value.end.round().toString(),
                  ),
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
                return GetBuilder<HomePageController>(
                  init: controller,
                  builder: (_) {
                    return Obx(
                      () => ListView.builder(
                        itemCount: controller.ads.length,
                        itemBuilder: (context, index) {
                          Ad ad = controller.ads[index];

                          return Card(
                            color: ad.isVisible
                                ? Colors.white
                                : Colors.transparent,
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
                                    leading: const Icon(
                                        Icons.account_circle_outlined),
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
