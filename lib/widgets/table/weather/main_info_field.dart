import 'package:flutter/material.dart';

class MainInfoField extends StatelessWidget {
  const MainInfoField({
    super.key,
    required this.value,
    required this.fontSize,
  });

  // 변수
  final dynamic value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(value,
        style: TextStyle(fontSize: fontSize, color: Colors.white));
  }
}
