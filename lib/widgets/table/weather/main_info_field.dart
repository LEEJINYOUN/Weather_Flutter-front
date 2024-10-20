import 'package:flutter/material.dart';

class MainInfoField extends StatelessWidget {
  // 변수
  final dynamic value;
  final double fontSize;

  const MainInfoField({
    super.key,
    required this.value,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(value,
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontWeight: FontWeight.w600));
  }
}
