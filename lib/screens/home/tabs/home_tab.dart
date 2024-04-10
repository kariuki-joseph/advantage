import 'package:advantage/models/ad.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/home/controller/home_tab_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/widgets/ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final HomeTabController homeTabController = Get.find<HomeTabController>();

  final LocationController locationController = Get.find<LocationController>();

  final FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Row(
          children: [
            Expanded(
              child: SearchBar(
                controller: homeTabController.searchController,
                focusNode: searchFocusNode,
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.account_circle, size: 40),
                ),
                trailing: searchFocusNode.hasFocus
                    ? [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.check, size: 32),
                        ),
                      ]
                    : null,
                onSubmitted: (String value) {
                  // add subscription to firebase
                  homeTabController.addSubscription(value);
                  // scroll to the end of the list
                  homeTabController.scrollController.animateTo(
                    homeTabController.scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.notifications);
              },
              icon: const Icon(
                Icons.notifications_outlined,
                size: 32,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // cancellable selection chips
        Obx(
          () => SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: homeTabController.scrollController,
              children: homeTabController.subscriptions
                  .map(
                    (subscription) => Padding(
                      padding: const EdgeInsets.all(5),
                      child: InputChip(
                        label: Text(subscription.keyword),
                        onDeleted: () {
                          homeTabController.deleteSubscription(subscription);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => RangeSlider(
                  values: homeTabController.rangeValues.value,
                  onChanged: (RangeValues values) {
                    homeTabController.rangeValues.value = values;
                  },
                  min: 0,
                  max: 100,
                  divisions: 100,
                  labels: RangeLabels(
                    homeTabController.rangeValues.value.start
                        .round()
                        .toString(),
                    homeTabController.rangeValues.value.end.round().toString(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Center(child: Text("Adjust Search Radius")),
        const SizedBox(height: 10),
        // Body
        Expanded(
          child: Obx(
            () {
              if (homeTabController.ads.isEmpty &&
                  homeTabController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return GetBuilder<HomeTabController>(
                  init: homeTabController,
                  builder: (_) {
                    return Obx(
                      () => RefreshIndicator(
                        onRefresh: () async {
                          await homeTabController.fetchAds();
                          locationController.updateLiveLocation();
                        },
                        child: ListView.builder(
                          itemCount: homeTabController.ads.length,
                          itemBuilder: (context, index) {
                            Ad ad = homeTabController.ads[index];
                            return AdWidget(ad: ad);
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
