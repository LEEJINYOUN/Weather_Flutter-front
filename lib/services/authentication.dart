import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/utilities/env_constant.dart';

class AuthMethod {
  final storage = const FlutterSecureStorage();

  var backendUrl = EnvConstant().backendApi();

  // 회원가입
  Future<dynamic> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      var url = '$backendUrl/auth/register';
      var reqBody = {
        'email': email,
        'name': name,
        'role': 'user',
        'password': password
      };

      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      Map<String, dynamic> registerData = {
        "data": jsonResponse,
        "statusCode": response.statusCode
      };

      return registerData;
    } catch (e) {
      debugPrint(e as dynamic);
    }
  }

  // 로그인
  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    try {
      var url = '$backendUrl/auth/login';
      var reqBody = {'email': email, 'password': password};

      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      var accessToken = jsonResponse['result']['accessToken'];
      var refreshToken = jsonResponse['result']['refreshToken'];

      Map<String, dynamic> userData = {
        "data": jsonResponse,
        "statusCode": response.statusCode
      };

      if (response.statusCode == 201) {
        // 로그인 성공

        if (accessToken != null) {
          await storage.deleteAll();
          await storage.write(key: 'accessToken', value: accessToken);
          await storage.write(key: 'refreshToken', value: refreshToken);
        } else {
          accessToken = null;
          refreshToken = null;
          await storage.deleteAll();
        }

        return userData;
      } else {
        // 로그인 실패

        return userData;
      }
    } catch (e) {
      debugPrint(e as dynamic);
    }
  }

  // 유저 정보 가져오기
  Future<dynamic> getUser(tokens) async {
    try {
      bool isGetData;
      isGetData = false;
      var response;
      var jsonResponse;

      if (isGetData == false) {
        response = await getToken(tokens['accessToken']);
        jsonResponse = jsonDecode(response);
      }
      isGetData = true;

      if (isGetData == true && jsonResponse['message'] == '토큰 만료') {
        response = await getToken(tokens['refreshToken']);
        jsonResponse = jsonDecode(response);
      }
      isGetData = false;

      return jsonResponse;
    } catch (e) {
      debugPrint(e as dynamic);
    }
  }

  // 토큰 정보 가져오기
  dynamic getToken(token) async {
    var reqBody = {'accessToken': token};
    var url = '$backendUrl/auth/getUser';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode(reqBody));
    return response.body;
  }

  // 로그아웃
  Future<dynamic> logout() async {
    try {
      var url = '$backendUrl/auth/logout';

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
      debugPrint(e as dynamic);
    }
  }
}
