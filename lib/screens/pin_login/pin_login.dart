import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/pin_login/components/pin_button.dart';
import 'package:advantage/screens/pin_login/components/pin_field.dart';
import 'package:advantage/screens/pin_login/controller/pin_login_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinLogin extends StatefulWidget {
  const PinLogin({super.key});

  @override
  State<PinLogin> createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin> {
  final PinLoginController controller =
      Get.put(PinLoginController(phoneNumber: Get.arguments ?? ""));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(
              Icons.lock_outline,
              size: 100,
              color: Get.theme.colorScheme.onPrimary,
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Text(
                controller.isPinWrong.value
                    ? "Wrong PIN. Please try again."
                    : controller.isLoginSuccess.value
                        ? "Login Successful"
                        : "Enter your PIN to unlock",
                style: TextStyle(
                  fontSize: 16,
                  color: controller.isPinWrong.value
                      ? Get.theme.colorScheme.error
                      : controller.isLoginSuccess.value
                          ? Colors.green
                          : Get.theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => PinField(
                    isFilled: controller.loginPin.isNotEmpty,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => PinField(
                    isFilled: controller.loginPin.length > 1,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => PinField(
                    isFilled: controller.loginPin.length > 2,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => PinField(
                    isFilled: controller.loginPin.length > 3,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(3, (index) {
                return PinButton(
                  onPressed: () {
                    controller.loginPin.add(index + 1);
                  },
                  number: (index + 1).toString(),
                );
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(3, (index) {
                return PinButton(
                  onPressed: () {
                    controller.loginPin.add(index + 4);
                  },
                  number: (index + 4).toString(),
                );
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(3, (index) {
                return PinButton(
                  onPressed: () {
                    controller.loginPin.add(index + 7);
                  },
                  number: (index + 7).toString(),
                );
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PinButton(onPressed: () {}, number: "fingerPrint"),
                PinButton(
                  onPressed: () {
                    controller.loginPin.add(0);
                  },
                  number: "0",
                ),
                PinButton(
                  onPressed: () {
                    controller.deleteLastPin();
                  },
                  number: "del",
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "Forgot PIN? ",
                    style: Get.theme.textTheme.labelLarge?.copyWith(
                      color: Get.theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.toNamed(AppRoutes.phoneLogin);
                      },
                  ),
                ]),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
