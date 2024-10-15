import 'package:flutter/material.dart';
import 'package:weather_flutter_front/utilities/env_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationMethod {
  var backendUrl = EnvConstant().backendApi();

  // 나라 별 지역리스트 조회
  Future<dynamic> getLocationByCountryId(countryId) async {
    try {
      var url = '$backendUrl/location/$countryId';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 데이터 값 받기 성공
        debugPrint('나라 별 지역리스트 받기 성공' as dynamic);
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
