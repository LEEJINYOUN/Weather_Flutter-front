import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/utilities/env_constant.dart';

class ClothesMethod {
  var backendUrl = EnvConstant().backendApi();

  // 기온 별 옷 조회
  Future<dynamic> getClothesByTemp(temp) async {
    try {
      var url = '$backendUrl/clothes/$temp';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 데이터 값 받기 성공
        debugPrint('기온 별 옷 받기 성공' as dynamic);
        return jsonResponse;
      } else {
        // 데이터 값 받기 실패
        throw Exception('불러오는데 실패했습니다');
      }
    } catch (e) {
      debugPrint(e as dynamic);
      rethrow;
    }
  }
}
