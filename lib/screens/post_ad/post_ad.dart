import 'package:advantage/constants/app_color.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/screens/post_ad/controller/post_ad_controller.dart';
import 'package:advantage/widgets/my_btn_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PostAd extends StatelessWidget {
  PostAd({super.key});
  final PostAdController controller = Get.find<PostAdController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Post Ad"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    maxLines: 3,
                    controller: controller.descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Ad Description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                      "Tags are keywords that will help users find your ad."),
                  const SizedBox(height: 12),
                  Obx(
                    () => TextFormField(
                      controller: controller.tagsController,
                      enabled: controller.tags.length < controller.maxTags,
                      maxLength: 15,
                      // do not allow spaces
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"\s")),
                      ],
                      onFieldSubmitted: (value) {
                        controller.addTag();
                      },
                      decoration: InputDecoration(
                        prefix: const Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Text("#"),
                        ),
                        hintText: "Tag",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.addTag();
                          },
                          icon: const Icon(
                            Icons.add_circle_outlined,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                        "Tags added: ${controller.tags.length}/${controller.maxTags}"),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.tags
                          .map(
                            (tag) => GestureDetector(
                              onTap: () {
                                // add the tag to the text field
                                controller.tagsController.text = tag;
                                controller.tags.remove(tag);
                              },
                              child: Chip(
                                label: Text(tag),
                                onDeleted: () {
                                  controller.tags.remove(tag);
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                      "Discovery radius is the radius within which your ad will be visible to other users."),
                  const SizedBox(height: 12),
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
                            : controller.isLocationLoading.value
                                ? "Getting location..."
                                : controller.locationError.value
                                    ? "Error getting location"
                                    : "Add location",
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        foregroundColor: controller.locationError.value
                            ? Get.theme.colorScheme.error
                            : Get.theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: controller.isLocationLoading.value
                          ? const MyBtnLoader()
                          : Icon(
                              controller.isLocationSelected.value
                                  ? Icons.check_circle_outline
                                  : Icons.add_location_alt_outlined,
                            ),
                      onPressed: () {
                        controller.getLocation();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Center(
                      child: Text(
                          "Location: ${controller.locationController.userLocation.value.latitude}, ${controller.locationController.userLocation.value.longitude}"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Get.theme.colorScheme.primary,
                        foregroundColor: Get.theme.colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        controller.postAd();
                      },
                      child: controller.isLoading.value
                          ? const MyBtnLoader(large: true)
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
