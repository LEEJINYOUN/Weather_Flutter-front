import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/utils/constant.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthMethod {
  final storage = const FlutterSecureStorage();

  var backendUrl = EnvData().backendApi();

  // 회원가입
  Future<dynamic> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      var url = '$backendUrl/register';
      var reqBody = {'email': email, 'name': name, 'password': password};

      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // 회원가입 성공
        Map<String, dynamic> registerData = {
          "data": jsonResponse,
          "statusCode": response.statusCode
        };

        return registerData;
      } else {
        // 회원가입 실패
        Map<String, dynamic> registerData = {
          "data": jsonResponse['message'],
          "statusCode": response.statusCode
        };

        return registerData;
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
      var url = '$backendUrl/login';
      var reqBody = {'email': email, 'password': password};

      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);
      var token = jsonResponse['token'];

      if (response.statusCode == 201) {
        // 로그인 성공

        if (token != null) {
          await storage.deleteAll();
          await storage.write(key: 'token', value: token);
        } else {
          token = null;
          await storage.deleteAll();
        }

        Map<String, dynamic> userData = {
          "data": jsonResponse,
          "statusCode": response.statusCode
        };

        return userData;
      } else {
        // 로그인 실패
        Map<String, dynamic> userData = {
          "data": jsonResponse['message'],
          "statusCode": response.statusCode
        };

        return userData;
      }
    } catch (e) {
      dataPrint(text: e);
    }
  }

  // 유저 정보 가져오기
  Future<dynamic> user({required dynamic token}) async {
    try {
      var url = '$backendUrl/user';
      var reqBody = {'token': token};

      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      return jsonResponse;
    } catch (e) {
      dataPrint(text: e);
    }
  }

  // 로그아웃
  Future<dynamic> logout() async {
    try {
      var url = '$backendUrl/logout';

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = jsonDecode(response.body);

      await storage.deleteAll();
      return jsonResponse;
    } catch (e) {
      dataPrint(text: e);
    }
  }
}
