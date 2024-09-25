import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  // 입력 컨트롤러
  final TextEditingController textEditingController;

  // 변수
  final TextInputType textInputType;
  final String hintText;
  final dynamic prefixOnTap;
  final IconData? prefixIcon;
  final dynamic suffixOnTap;
  final IconData? suffixIcon;
  final dynamic focusNode;
  final dynamic validator;
  final bool isPass;

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    required this.textInputType,
    required this.hintText,
    this.prefixOnTap,
    this.prefixIcon,
    this.suffixOnTap,
    this.suffixIcon,
    this.focusNode,
    this.validator,
    this.isPass = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 20),
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: GestureDetector(
          onTap: prefixOnTap,
          child: Icon(prefixIcon, color: Colors.black54),
        ),
        suffixIcon: GestureDetector(
          onTap: suffixOnTap,
          child: Icon(suffixIcon, color: Colors.black54),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: const Color(0xFFedf0f8),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
      ),
      validator: validator,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      obscureText: isPass,
    );
  }
}
