import 'package:flutter/material.dart';
import 'package:weather_flutter_front/screens/login_screen.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/utils/validate.dart';
import 'package:weather_flutter_front/widgets/button/blue_Button.dart';
import 'package:weather_flutter_front/widgets/form/text_field.dart';

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

  // 로딩 체크
  bool isLoading = false;

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
  }

  // 회원가입 기능
  void registerSubmit() async {
    var isCheckValidate = CheckValidate().formCheckValidate(formField);

    if (isCheckValidate == null) {
      try {
        setState(() {
          isLoading = true;
        });

        // 회원가입 API 연동
        dynamic result = await AuthMethod().register(
            email: emailController.text,
            name: nameController.text,
            password: passwordController.text);

        if (result['statusCode'] == 201) {
          // 회원가입 성공일 경우
          dataPrint(text: '회원가입 성공!');
          dataPrint(text: result['data']['email']);
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const LoginScreen(),
          //   ),
          // );
        } else {
          // 회원가입 실패일 경우
          dataPrint(text: result['data']);
        }
      } catch (e) {
        dataPrint(text: e);
      }
    } else {
      dataPrint(text: isCheckValidate);
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
            const Text("회원가입", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
          child: Form(
              key: formField,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
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
                        validator: (value) =>
                            CheckValidate().validateName(nameFocus, value),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFieldInput(
                          textEditingController: passwordController,
                          hintText: '비밀번호',
                          textInputType: TextInputType.text,
                          prefixIcon: Icons.lock,
                          focusNode: passwordFocus,
                          validator: (value) => CheckValidate()
                              .validatePassword(passwordFocus, value),
                          isPass: true)),
                  BlueButton(onTap: registerSubmit, text: "회원가입"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("회원인가요?  "),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          " 로그인",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ))),
    );
  }
}
