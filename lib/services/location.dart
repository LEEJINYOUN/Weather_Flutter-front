import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/constants.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';

class LocationMethod {
  // 지역 리스트
  Future<dynamic> getLocationList() async {
    try {
      var url = '${backendUrl()}/location';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        dataPrint(text: 'API 연결 성공, 지역리스트 값 받기 성공');
        return jsonResponse;
      } else {
        throw Exception('불러오는데 실패했습니다');
      }
    } catch (e) {
      dataPrint(text: e);
      rethrow;
    }
  }
}
