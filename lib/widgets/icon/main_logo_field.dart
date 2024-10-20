import 'package:flutter/material.dart';
import 'package:weather_flutter_front/utilities/env_constant.dart';

class MainLogoField extends StatelessWidget {
  const MainLogoField({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '${EnvConstant().imageFrontUrl()}/icons/logo.gif',
      width: 170,
      height: 170,
    );
  }
}
