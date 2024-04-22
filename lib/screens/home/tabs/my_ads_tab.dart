import 'package:advantage/models/ad.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/home/controller/my_ads_controller.dart';
import 'package:advantage/screens/update_ad/controller/controller/update_ad_controller.dart';
import 'package:advantage/widgets/edit_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAdsTab extends StatelessWidget {
  MyAdsTab({super.key});
  final MyAdsController controller = Get.put(MyAdsController());
  final UpdateAdController updateAdController = Get.put(UpdateAdController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("My Ads"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.postAd);
                  },
                  icon: const Icon(Icons.add),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.primary,
                    foregroundColor: Get.theme.colorScheme.onPrimary,
                    side: BorderSide.none,
                  ),
                  label: const Text("Post New Ad"),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Current Ads",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),

              // chekck if loading
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.myAds.isEmpty
                      ? const Align(
                          alignment: Alignment.center,
                          child: Text("You have not posted any ads for now"),
                        )
                      : Expanded(
                          child: GetBuilder<MyAdsController>(
                            init: controller,
                            builder: (_) {
                              return Obx(
                                () => ListView.builder(
                                  itemCount: controller.myAds.length,
                                  itemBuilder: (context, index) {
                                    Ad ad = controller.myAds[index];

                                    return EditAdWidget(
                                      ad: ad,
                                      onDeleteAd: () {
                                        showConfirmDeleteDialog(context, ad);
                                      },
                                      onEditAd: () {
                                        updateAdController.setAdToUpdate(ad);
                                        Get.toNamed(AppRoutes.updateAd);
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }

  void showConfirmDeleteDialog(BuildContext context, Ad ad) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Ad"),
            content: const Text("Are you sure you want to delete this ad?"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  controller.deleteAd(ad.id);
                },
                child: const Text("Delete"),
              ),
            ],
          );
        });
  }
}
