import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetLocation extends StatelessWidget {
  final LocationController locationController = Get.find<LocationController>();
  SetLocation({super.key});

  @override
  Widget build(BuildContext context) {
    // an error screen to show when the location is not set
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This app requires your location to work properly.'),
            ElevatedButton(
              onPressed: () async {
                try {
                  await locationController.checkAndRequestLocationPermissions();
                  Get.toNamed(AppRoutes.home);
                } catch (e) {
                  showErrorToast(e.toString());
                }
              },
              child: const Text('Set Location'),
            ),
          ],
        ),
      ),
    );
  }
}
