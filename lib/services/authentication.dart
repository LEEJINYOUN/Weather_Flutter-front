import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/constants.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';

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
      dataPrint(text: e);
    }
  }

  // 로그인
  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    try {
      var url = '${backendUrl()}/login';
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{'email': email, 'password': password},
      );

      String body = response.body;

      if (response.statusCode == 201) {
        // 로그인 성공일 경우
        Map<String, dynamic> userData = {
          'data': jsonDecode(body),
          "statusCode": response.statusCode
        };

        return userData;
      } else {
        // 로그인 실패일 경우
        Map<String, dynamic> userData = {
          'data': jsonDecode(body)['message'],
          "statusCode": response.statusCode
        };

        return userData;
      }
    } catch (e) {
      dataPrint(text: e);
    }
  }
}
