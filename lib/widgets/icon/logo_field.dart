import 'package:flutter/material.dart';
import 'package:weather_flutter_front/utils/constant.dart';

// ignore: must_be_immutable
class LogoField extends StatelessWidget {
  // 변수
  final String name;

  LogoField({super.key, required this.name});

  // cdn 주소
  var iconsUrl = EnvData().iconsUrl();

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '$iconsUrl/icons/$name.gif',
      width: 170,
      height: 170,
    );
  }
}
