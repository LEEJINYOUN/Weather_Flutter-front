import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_flutter_front/screens/test_screen.dart';
import 'package:weather_flutter_front/utilities/login_status.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 메인 초기화
  await dotenv.load(fileName: ".env"); // env 파일 경로 설정
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, // 디버그 배너 삭제
        home: LoginStatus()); // 기본 화면 (로그인 확인 체크)
  }
}
