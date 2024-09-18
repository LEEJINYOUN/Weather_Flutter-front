import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:weather_flutter_front/screens/login_screen.dart';
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

  // 입력 값 체크 (임시)
  void dataPrint(String text) {
    log(text);
  }

  // 회원가입 기능
  void registerSubmit() async {
    setState(() {
      isLoading = true;
    });

    if (emailController.text != '' &&
        nameController.text != '' &&
        passwordController.text != '') {
      dataPrint(emailController.text);
      dataPrint(nameController.text);
      dataPrint(passwordController.text);
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
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            padding: const EdgeInsets.only(top: 20, bottom: 20),
          ),
          TextFieldInput(
              icon: Icons.email,
              textEditingController: emailController,
              hintText: '이메일',
              textInputType: TextInputType.text),
          TextFieldInput(
              icon: Icons.person,
              textEditingController: nameController,
              hintText: '이름',
              textInputType: TextInputType.text),
          TextFieldInput(
            icon: Icons.lock,
            textEditingController: passwordController,
            hintText: '비밀번호',
            textInputType: TextInputType.text,
            isPass: true,
          ),
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
      )),
    );
  }
}
