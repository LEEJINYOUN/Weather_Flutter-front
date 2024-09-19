import 'package:flutter/material.dart';
import 'package:weather_flutter_front/common/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // BottomNavBar 불러오기
    return const MaterialApp(
        debugShowCheckedModeBanner: false, // 디버그 배너 삭제
        home: BottomNavBar()); // 기본 화면
  }
}
