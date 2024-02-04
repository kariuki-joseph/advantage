import 'package:advantage/constants/app_color.dart';
import 'package:advantage/screens/home/controller/post_ad_controller.dart';
import 'package:advantage/widgets/my_btn_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostAdTab extends StatelessWidget {
  PostAdTab({super.key});
  final PostAdController controller = Get.put(PostAdController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Post Ad"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Ad Title",
                      hintText: "Enter Ad Title",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                    controller: controller.titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Ad Title";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Ad Description",
                      hintText: "Enter Ad Description",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    controller: controller.descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Ad Description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                      "Discovery radius is the radius within which your ad will be visible to other users."),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Discovery Radius (Metres)",
                      hintText: "Discovery Radius (Metres)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: controller.discoveryRadiusController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter discovery radius";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => OutlinedButton.icon(
                      label: Text(
                        controller.isLocationSelected.value
                            ? "Location Added"
                            : "Add location",
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        foregroundColor: controller.locationError.value
                            ? Colors.red
                            : AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: controller.isLocationLoading.value
                          ? const MyBtnLoader()
                          : controller.isLocationSelected.value
                              ? const Icon(
                                  Icons.check_circle_outline,
                                )
                              : const Icon(
                                  Icons.add_location_alt_outlined,
                                ),
                      onPressed: () {
                        controller.getLocation();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                      "Location: ${controller.lat.value}, ${controller.lng.value}")),
                  const SizedBox(height: 16),
                  Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        controller.postAd();
                      },
                      child: controller.isLoading.value
                          ? const MyBtnLoader(color: Colors.white, large: true)
                          : const Text(
                              "Post",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
