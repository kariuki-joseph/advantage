import 'package:flutter/material.dart';

class PinField extends StatelessWidget {
  final bool isFilled;
  const PinField({super.key, this.isFilled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isFilled ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white),
      ),
    );
  }
}
