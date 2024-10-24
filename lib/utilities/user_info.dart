import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/services/authentication.dart';

Future<dynamic> getUserInfo() async {
  // storage
  const storage = FlutterSecureStorage();

  try {
    var accessToken = await storage.read(key: "accessToken");
    var refreshToken = await storage.read(key: "refreshToken");
    var tokens = {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
    var getUserInfo = await AuthMethod().getUser(tokens);
    return getUserInfo;
  } catch (e) {
    debugPrint(e as dynamic);
  }
}
