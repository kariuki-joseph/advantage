import 'package:flutter/material.dart';

class MyBtnLoader extends StatelessWidget {
  final Color? color;
  final bool? large;
  const MyBtnLoader({
    Key? key,
    this.color,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: large! ? 30 : 20,
      width: large! ? 30 : 20,
      child: CircularProgressIndicator(color: color),
    );
  }
}
