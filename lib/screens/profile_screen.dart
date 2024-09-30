import 'package:flutter/material.dart';
import 'package:weather_flutter_front/screens/login_screen.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/widgets/button/blue_Button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // storage
  final storage = const FlutterSecureStorage();

  // 변수
  Map<String, dynamic> userInfo = {};

  // state 진입시 함수 실행
  @override
  void initState() {
    super.initState();
    getUserInfo();
    print(userInfo);
  }

  // 유저 정보 가져오기
  void getUserInfo() async {
    try {
      var token = await storage.read(key: "token");
      var getUserInfo = await AuthMethod().getUser(token: token);
      setState(() {
        userInfo = getUserInfo;
      });
    } catch (e) {
      dataPrint(text: e);
    }
  }

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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                        image: AssetImage(
                      userInfo['image'] ?? 'assets/images/user_icon1.jpg',
                    )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  userInfo['name'] ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  userInfo['email'] ?? 'Loading...',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: 200,
                    child: BlueButton(onTap: logoutSubmit, text: "로그아웃"))
              ],
            ),
          ),
        ));
  }
}
