import 'package:advantage/components/primary_button.dart';
import 'package:advantage/constants/app_color.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:advantage/screens/phone_verification/components/single_button.dart';
import 'package:advantage/screens/phone_verification/components/single_pin_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({super.key});

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("images/ill_verification_code.png"),
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 5),
              const Text(
                "Enter the verification code",
                style: TextStyle(fontSize: 28),
              ),
              const Text(
                "We have sent the code verification to your Phone number +254******443",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              // PIN fields
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SinglePinField(color: AppColor.primaryColor),
                  SinglePinField(color: AppColor.primaryLight),
                  SinglePinField(color: AppColor.primaryLight),
                  SinglePinField(color: AppColor.primaryLight),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Haven't received OTP?"),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  3,
                  (index) =>
                      SingleButton(onPressed: () {}, number: "${index + 1}"),
                ).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  3,
                  (index) =>
                      SingleButton(onPressed: () {}, number: "${index + 4}"),
                ).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  3,
                  (index) =>
                      SingleButton(onPressed: () {}, number: "${index + 7}"),
                ).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleButton(onPressed: () {}, number: ""),
                  SingleButton(onPressed: () {}, number: "0"),
                  SingleButton(onPressed: () {}, number: "del"),
                ],
              ),

              const SizedBox(height: 10),
              PrimaryButton(
                onPressed: () {
                  Get.toNamed(AppPage.verificationSuccess);
                },
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
