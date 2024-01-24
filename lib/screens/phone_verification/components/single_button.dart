import 'package:flutter/material.dart';

class SingleButton extends StatefulWidget {
  final Function() onPressed;
  final String number;

  const SingleButton({
    super.key,
    required this.onPressed,
    required this.number,
  });

  @override
  State<SingleButton> createState() => _SingleButtonState();
}

class _SingleButtonState extends State<SingleButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(10),
      onPressed: widget.onPressed,
      child: widget.number == "del"
          ? IconButton(
              onPressed: widget.onPressed,
              icon: const Icon(Icons.backspace_outlined),
              padding: const EdgeInsets.all(10),
            )
          : Text(
              widget.number,
              style: const TextStyle(fontSize: 24),
            ),
    );
  }
}
