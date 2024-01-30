import 'package:advantage/constants/app_color.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:advantage/screens/pin_login/components/pin_button.dart';
import 'package:advantage/screens/pin_login/components/pin_field.dart';
import 'package:advantage/screens/pin_login/controller/pin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmPin extends StatefulWidget {
  const ConfirmPin({super.key});

  @override
  State<ConfirmPin> createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> {
  final PinController controller = Get.find();

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
              "Confirm your PIN",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => PinField(
                    isFilled: controller.repeatPin.isNotEmpty,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => PinField(
                    isFilled: controller.repeatPin.length > 1,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => PinField(
                    isFilled: controller.repeatPin.length > 2,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => PinField(
                    isFilled: controller.repeatPin.length > 3,
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
                    controller.repeatPin.add(index + 1);
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
                    controller.repeatPin.add(index + 4);
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
                    controller.repeatPin.add(index + 7);
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
                PinButton(onPressed: () {}, number: ""),
                PinButton(
                  onPressed: () {
                    controller.repeatPin.add(0);
                  },
                  number: "0",
                ),
                PinButton(
                  onPressed: () {
                    controller.deleteLastRepeatPin();
                  },
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
