import 'package:flutter/material.dart';
import 'package:weather_flutter_front/screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_flutter_front/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 메인 초기화
  await dotenv.load(fileName: ".env"); // env 파일 경로 설정
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // BottomNavBar 불러오기
    return const MaterialApp(
        debugShowCheckedModeBanner: false, // 디버그 배너 삭제
        home: RegisterScreen()); // 기본 화면
  }
}
