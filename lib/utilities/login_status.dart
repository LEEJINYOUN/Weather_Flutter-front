import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/common/bottom_nav_bar.dart';
import 'package:weather_flutter_front/screens/login_screen.dart';

class LoginStatus extends StatefulWidget {
  const LoginStatus({super.key});

  @override
  State<LoginStatus> createState() => _LoginStatusState();
}

class _LoginStatusState extends State<LoginStatus> {
  // storage
  final storage = const FlutterSecureStorage();

  // 변수
  bool logLoginStatusCheck = false;

  // state 진입시 함수 실행
  @override
  void initState() {
    super.initState();
    isLogged();
  }

  // 로그인 상태 확인
  Future<void> isLogged() async {
    if (await storage.read(key: "token") != null) {
      setState(() {
        logLoginStatusCheck = true;
      });
    } else {
      setState(() {
        logLoginStatusCheck = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return logLoginStatusCheck ? const BottomNavBar() : const LoginScreen();
  }
}
