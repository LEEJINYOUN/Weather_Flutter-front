import 'package:flutter/material.dart';
import 'package:weather_flutter_front/common/bottom_nav_bar.dart';
import 'package:weather_flutter_front/screens/register_screen.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/utils/validate.dart';
import 'package:weather_flutter_front/widgets/button/blue_Button.dart';
import 'package:weather_flutter_front/widgets/form/text_field.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';
import 'package:weather_flutter_front/widgets/icon/logo_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // storage
  final storage = const FlutterSecureStorage();

  // 입력 컨트롤러
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 입력 포커스
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  // 폼 글로벌 키
  final formField = GlobalKey<FormState>();

  // 변수
  String errorTitle = '';
  String errorDescription = '';

  // state 진입시 함수 실행
  @override
  void initState() {
    super.initState();
    isLogged();
  }

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  // 로그인 상태 확인
  void isLogged() async {
    if (await storage.read(key: "token") != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
      );
    } else {
      return;
    }
  }

  // 로그인 기능
  void loginSubmit() async {
    // db 유효성 초기화
    setState(() {
      errorTitle = '';
      errorDescription = '';
    });

    // 유효성 체크
    var isCheckValidate = CheckValidate().formCheckValidate(formField);

    if (isCheckValidate == null) {
      try {
        // 로그인 API 연동
        dynamic result = await AuthMethod().login(
            email: emailController.text, password: passwordController.text);

        if (result['statusCode'] == 201) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
          );
        } else {
          // db 유효성 체크
          setState(() {
            errorTitle = result['data']['objectOrError'];
            errorDescription = result['data']['descriptionOrOptions'];
          });

          // 알림창
          dialogBuilder(context, errorTitle, errorDescription);
        }
      } catch (e) {
        dataPrint(text: e);
      }
    } else {
      dataPrint(text: isCheckValidate);
    }
  }

  // 알림창 모달
  Future<void> dialogBuilder(
      BuildContext context, String errorTitle, String errorDescription) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(errorTitle),
            content: Text(errorDescription),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge),
                child: const Text(
                  '다시 시도',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
        appBar: const AppBarField(title: '로그인'),
        body: SafeArea(
            child: Form(
                key: formField,
                child: Column(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Center(child: LogoField(name: 'sun')),
                    ),
                    Flexible(
                      flex: 7,
                      child: Center(
                          child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: TextFieldInput(
                                  textEditingController: emailController,
                                  hintText: '이메일',
                                  textInputType: TextInputType.text,
                                  prefixIcon: Icons.email,
                                  focusNode: emailFocus,
                                  validator: (value) => CheckValidate()
                                      .validateEmail(emailFocus, value))),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Column(
                                children: [
                                  TextFieldInput(
                                      textEditingController: passwordController,
                                      hintText: '비밀번호',
                                      textInputType: TextInputType.text,
                                      prefixIcon: Icons.lock,
                                      focusNode: passwordFocus,
                                      validator: (value) => CheckValidate()
                                          .validatePassword(
                                              passwordFocus, value),
                                      isPass: true),
                                ],
                              )),
                          BlueButton(onTap: loginSubmit, text: "로그인"),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: const Text(
                                    "회원이 아닌가요?",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: const Text(
                                        "회원가입",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ))));
  }
}
