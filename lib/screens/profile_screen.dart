import 'package:flutter/material.dart';
import 'package:weather_flutter_front/screens/login_screen.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/widgets/button/blue_Button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 로그아웃 기능
  void logoutSubmit() async {
    try {
      dynamic result = await AuthMethod().logout();

      if (result['statusCode'] == 201) {
        dataPrint(text: result['message']);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        dataPrint(text: '오류 발생!');
      }
    } catch (e) {
      dataPrint(text: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
        appBar: AppBar(
          centerTitle: true,
          elevation: 5,
          title:
              const Text("프로필", style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: BlueButton(onTap: logoutSubmit, text: "로그아웃"),
          ),
        ));
  }
}
