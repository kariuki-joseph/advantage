import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinButton extends StatefulWidget {
  final Function() onPressed;
  final String number;

  const PinButton({super.key, required this.onPressed, required this.number});

  @override
  State<PinButton> createState() => _PinButtonState();
}

class _PinButtonState extends State<PinButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(10),
      onPressed: widget.onPressed,
      child: (widget.number == "del")
          ? IconButton(
              onPressed: widget.onPressed,
              icon: Icon(
                Icons.backspace_outlined,
                color: Get.theme.colorScheme.onPrimary,
              ),
              padding: const EdgeInsets.all(10),
            )
          : (widget.number == "fingerPrint")
              ? IconButton(
                  onPressed: widget.onPressed,
                  icon: Icon(
                    Icons.fingerprint,
                    color: Get.theme.colorScheme.onPrimary,
                    size: 30,
                  ),
                  padding: const EdgeInsets.all(10),
                )
              : Text(
                  widget.number,
                  style: Get.theme.textTheme.titleSmall?.copyWith(
                    fontSize: 24,
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                ),
    );
  }
}
