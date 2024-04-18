import 'package:advantage/models/ad.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/home/controller/home_tab_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/screens/notifications/controllers/notifications_controller.dart';
import 'package:advantage/widgets/ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  final NotificationController notificationController =
      Get.find<NotificationController>();

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
              icon: Stack(
                children: <Widget>[
                  const Icon(
                    Icons.notifications_outlined,
                    size: 32,
                  ),
                  Obx(
                    () => Visibility(
                      visible:
                          notificationController.unreadNotifications.value > 0,
                      child: Positioned(
                        bottom: 5,
                        right: 3,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 15,
                            minHeight: 12,
                          ),
                          child: Text(
                            notificationController.unreadNotifications.value
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // cancellable selection chips
        Obx(
          () => SizedBox(
            height: homeTabController.subscriptions.isEmpty ? 0 : 50,
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
        const SizedBox(height: 5),
        Center(
          child: Obx(
            () => RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: 'Search Radius: '),
                  TextSpan(
                    text:
                        '${homeTabController.rangeValues.value.end.round()} m',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    showValueIndicator: ShowValueIndicator.always,
                  ),
                  child: RangeSlider(
                    values: homeTabController.rangeValues.value,
                    onChangeEnd: (RangeValues values) {
                      // update the search radius
                      locationController.searchRadius.value =
                          values.end - values.start + 1;
                    },
                    onChanged: (RangeValues values) {
                      final newValues = RangeValues(
                        homeTabController.rangeValues.value
                            .start, // Keep the start value constant
                        values.end, // Only update the end value
                      );
                      if (newValues.start <= newValues.end) {
                        homeTabController.rangeValues.value = newValues;
                      }
                    },
                    min: 0,
                    max: 1000,
                    divisions: 200,
                    labels: RangeLabels(
                      homeTabController.rangeValues.value.start
                          .round()
                          .toString(),
                      homeTabController.rangeValues.value.end
                          .round()
                          .toString(),
                    ),
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
              if (homeTabController.ads.isEmpty &&
                      homeTabController.isLoading.value ||
                  homeTabController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return GetBuilder<HomeTabController>(
                  init: homeTabController,
                  builder: (_) {
                    return Obx(
                      () => RefreshIndicator(
                        onRefresh: () async {
                          await homeTabController.getAdsWithRadius();
                          locationController.getAndUpdateUserLocation();
                        },
                        child: ListView.builder(
                          itemCount: homeTabController.ads.length,
                          itemBuilder: (context, index) {
                            Ad ad = homeTabController.ads[index];
                            if (!ad.isVisible) return const SizedBox.shrink();
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
