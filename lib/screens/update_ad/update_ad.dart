import 'package:advantage/constants/app_color.dart';
import 'package:advantage/screens/update_ad/controller/controller/update_ad_controller.dart';
import 'package:advantage/widgets/my_btn_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateAd extends StatelessWidget {
  UpdateAd({super.key});

  final UpdateAdController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text("Up Adate Ad"),
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
                        controller.updateAd();
                      },
                      child: controller.isLoading.value
                          ? const MyBtnLoader(color: Colors.white, large: true)
                          : const Text(
                              "Update",
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
