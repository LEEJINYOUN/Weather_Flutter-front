import 'package:flutter/material.dart';

class EmptyTextField extends StatelessWidget {
  // 변수
  final String content;

  const EmptyTextField({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          content,
          style: const TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
