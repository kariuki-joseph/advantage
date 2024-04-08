import 'package:advantage/components/primary_button.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationSuccess extends StatelessWidget {
  const VerificationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 3,
            ),
            const Image(
              image: AssetImage("images/ill_verification_success.png"),
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Phone number has been verified successfully",
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Continue to finish setting up your account",
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            PrimaryButton(
              onPressed: () {
                Get.toNamed(AppRoutes.finishProfile);
              },
              child: const Text("Continue"),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
