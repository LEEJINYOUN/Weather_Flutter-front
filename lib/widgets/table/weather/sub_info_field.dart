import 'package:flutter/material.dart';

class SubInfoField extends StatelessWidget {
  // 변수
  final String title;
  final dynamic value;

  const SubInfoField({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
          Text(value, style: const TextStyle(fontSize: 18, color: Colors.white))
        ],
      ),
    );
  }
}
