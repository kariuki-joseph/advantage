import 'package:advantage/constants/app_color.dart';
import 'package:advantage/models/ad.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:advantage/screens/home/controller/my_ads_controller.dart';
import 'package:advantage/screens/update_ad/controller/controller/update_ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                    Get.toNamed(AppPage.postAd);
                  },
                  icon: const Icon(Icons.add),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
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

                                        return Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  leading: const Icon(Icons
                                                      .account_circle_outlined),
                                                  title: Text(
                                                    ad.userName,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  subtitle: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        size: 16,
                                                        color: AppColor
                                                            .primaryColor,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        timeago.format(
                                                            ad.createdAt),
                                                        style: const TextStyle(
                                                            fontSize: 11),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Icon(
                                                        Icons.directions_run,
                                                        size: 16,
                                                        color: AppColor
                                                            .primaryColor,
                                                      ),
                                                      Text(
                                                        "${ad.distance.toStringAsFixed(2)}m",
                                                        style: const TextStyle(
                                                            fontSize: 11),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Image.asset(
                                                          "images/geofence_radius.png"),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        "${ad.discoveryRadius.toStringAsFixed(2)}m",
                                                        style: const TextStyle(
                                                            fontSize: 11),
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
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(height: 10),
                                                // text and call icons
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    OutlinedButton.icon(
                                                      onPressed: () {
                                                        // show confirm dialog
                                                        Get.defaultDialog(
                                                          title: "Delete Ad",
                                                          middleText:
                                                              "Are you sure you want to delete this ad?",
                                                          textConfirm: "Yes",
                                                          textCancel: "No",
                                                          confirmTextColor:
                                                              Colors.white,
                                                          buttonColor: AppColor
                                                              .primaryColor,
                                                          onConfirm: () {
                                                            controller.deleteAd(
                                                                ad.id);
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(Icons
                                                          .delete_outlined),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: const BorderSide(
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        foregroundColor:
                                                            Colors.redAccent,
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                      label:
                                                          const Text("Delete"),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    OutlinedButton.icon(
                                                      onPressed: () {
                                                        updateAdController
                                                            .setAdToUpdate(ad);
                                                        Get.toNamed(
                                                            AppPage.updateAd);
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit),
                                                      label: const Text("Edit"),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: BorderSide.none,
                                                        backgroundColor:
                                                            AppColor
                                                                .primaryColor,
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              }),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
