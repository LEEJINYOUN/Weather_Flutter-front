import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/services/authentication.dart';

Future<dynamic> getUserInfo() async {
  // storage
  const storage = FlutterSecureStorage();

  try {
    var token = await storage.read(key: "token");
    var getUserInfo = await AuthMethod().getUser(token: token);
    return getUserInfo;
  } catch (e) {
    debugPrint(e as dynamic);
  }
}
