import 'package:flutter/material.dart';

class MyBtnLoader extends StatelessWidget {
  final bool? large;
  const MyBtnLoader({
    super.key,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: large! ? 30 : 20,
      width: large! ? 30 : 20,
      child: const CircularProgressIndicator(),
    );
  }
}
