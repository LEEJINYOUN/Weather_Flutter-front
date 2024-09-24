import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/constants.dart';

class AuthMethod {
  // 회원가입
  Future<dynamic> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      var url = '${backendUrl()}/register';
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'email': email,
          'name': name,
          'password': password
        },
      );

      String body = response.body;

      if (response.statusCode == 201) {
        // 회원가입 성공일 경우
        Map<String, dynamic> userData = {
          'data': jsonDecode(body),
          "statusCode": response.statusCode
        };

        return userData;
      } else {
        // 회원가입 실패일 경우
        Map<String, dynamic> userData = {
          'data': jsonDecode(body)['message'],
          "statusCode": response.statusCode
        };

        return userData;
      }
    } catch (e) {
      print(e);
    }
  }

  // 로그인
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String message = "오류 발생!";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        message = "success";
      } else {
        message = "빈칸이 있습니다.";
      }
    } catch (err) {
      return err.toString();
    }
    return message;
  }
}
