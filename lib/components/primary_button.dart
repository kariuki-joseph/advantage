import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;

  const PrimaryButton({super.key, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: onPressed,
        child: child ?? const Text(""),
      ),
    );
  }
}
