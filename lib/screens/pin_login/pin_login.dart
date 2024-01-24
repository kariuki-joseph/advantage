import 'package:advantage/constants/app_color.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:advantage/screens/pin_login/components/pin_button.dart';
import 'package:advantage/screens/pin_login/components/pin_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinLogin extends StatefulWidget {
  const PinLogin({super.key});

  @override
  State<PinLogin> createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(
              Icons.lock_outline,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Enter your PIN to unlock",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PinField(),
                SizedBox(width: 10),
                PinField(),
                SizedBox(width: 10),
                PinField(),
                SizedBox(width: 10),
                PinField(),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(3, (index) {
                return PinButton(
                  onPressed: () {},
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
                  onPressed: () {},
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
                  onPressed: () {},
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
                PinButton(
                    onPressed: () {
                      Get.toNamed(AppPage.home);
                    },
                    number: "fingerPrint"),
                PinButton(
                  onPressed: () {},
                  number: "0",
                ),
                PinButton(
                  onPressed: () {},
                  number: "del",
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
