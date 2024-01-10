import 'package:flutter/material.dart';

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
              icon: const Icon(
                Icons.backspace_outlined,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10),
            )
          : (widget.number == "fingerPrint")
              ? IconButton(
                  onPressed: widget.onPressed,
                  icon: const Icon(
                    Icons.fingerprint,
                    color: Colors.white,
                    size: 30,
                  ),
                  padding: const EdgeInsets.all(10),
                )
              : Text(
                  widget.number,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
    );
  }
}
