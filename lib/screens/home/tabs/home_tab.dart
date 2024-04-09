import 'package:advantage/models/ad.dart';
import 'package:advantage/screens/home/controller/home_page_controller.dart';
import 'package:advantage/widgets/ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeTab extends StatelessWidget {
  final HomePageController controller = Get.find<HomePageController>();

  HomeTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Row(
          children: [
            Expanded(
              child: SearchBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.account_circle, size: 40),
                ),
                trailing: [],
                onSubmitted: (String value) {
                  debugPrint("Search: $value");
                },
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                size: 32,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
        const Center(child: Text("Adjust Search Radius")),
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
                      () => RefreshIndicator(
                        onRefresh: () async {
                          await controller.fetchAds();
                          controller.updateLiveLocation();
                        },
                        child: ListView.builder(
                          itemCount: controller.ads.length,
                          itemBuilder: (context, index) {
                            Ad ad = controller.ads[index];
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
