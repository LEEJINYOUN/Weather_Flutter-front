import 'package:flutter/material.dart';
import 'package:weather_flutter_front/base/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // BottomNavBar 불러오기
    return const MaterialApp(home: BottomNavBar());
  }
}
