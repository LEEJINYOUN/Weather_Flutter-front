import 'package:flutter/material.dart';
import 'package:weather_flutter_front/screens/login_screen.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/utilities/dialog.dart';
import 'package:weather_flutter_front/utilities/validation.dart';
import 'package:weather_flutter_front/widgets/button/blue_button.dart';
import 'package:weather_flutter_front/widgets/form/text_field.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';
import 'package:weather_flutter_front/widgets/icon/main_logo_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 입력 컨트롤러
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 입력 포커스
  FocusNode emailFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  // 폼 글로벌 키
  final formField = GlobalKey<FormState>();

  // 변수
  String errorTitle = '';
  String errorDescription = '';

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
  }

  // 성공 모달 버튼
  void successOk() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  // 실패 모달 버튼
  void failOk() {
    Navigator.of(context).pop();
  }

  // 회원가입 기능
  void registerSubmit() async {
    // db 유효성 초기화
    setState(() {
      errorTitle = '';
      errorDescription = '';
    });

    // 유효성 체크
    var isCheckValidate = CheckValidate().formCheckValidate(formField);

    if (isCheckValidate == null) {
      try {
        // 회원가입 API 연동
        dynamic result = await AuthMethod().register(
            email: emailController.text,
            name: nameController.text,
            password: passwordController.text);

        if (result['statusCode'] == 201) {
          // 성공 알림창
          DialogType().successDialog(
            context,
            titleText: '성공!',
            contentText: '회원가입을 축하합니다.',
            successOk: successOk,
            actionText: '로그인 하러 가기',
          );
        } else {
          // db 유효성 체크
          setState(() {
            errorTitle = result['data']['objectOrError'];
            errorDescription = result['data']['descriptionOrOptions'];
          });

          // 실패 알림창
          DialogType().failDialog(
            context,
            titleText: errorTitle,
            contentText: errorDescription,
            failOk: failOk,
            actionText: '확인',
          );
        }
      } catch (e) {
        debugPrint(e as dynamic);
      }
    } else {
      debugPrint(isCheckValidate as dynamic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
      appBar: const AppBarField(title: '회원가입', isActions: false),
      body: SafeArea(
          child: Form(
              key: formField,
              child: Column(
                children: [
                  // 로고 아이콘
                  const Flexible(
                    flex: 3,
                    child: Center(child: MainLogoField()),
                  ),

                  // 폼 컨테이너
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
                            child: TextFieldInput(
                              textEditingController: nameController,
                              hintText: '이름',
                              textInputType: TextInputType.text,
                              prefixIcon: Icons.person,
                              focusNode: nameFocus,
                              validator: (value) => CheckValidate()
                                  .validateName(nameFocus, value),
                            )),
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
                                        .validatePassword(passwordFocus, value),
                                    isPass: true),
                              ],
                            )),
                        BlueButton(onTap: registerSubmit, text: "회원가입"),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: const Text(
                                  "회원인가요?",
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
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: const Text(
                                      "로그인",
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
              ))),
    );
  }
}
