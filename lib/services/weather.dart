import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/utils/constant.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';

class WeatherMethod {
  var weatherApiKey = EnvData().weatherApiKey();
  // 검색한 날씨 정보
  Future<dynamic> getWeatherInfo(
    String cityName,
  ) async {
    try {
      var url =
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&lang=Kr&appid=$weatherApiKey';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 데이터 값 받기 성공
        dataPrint(text: ' 날씨 데이터 값 받기 성공');
        return jsonResponse;
      } else {
        // 데이터 값 받기 실패
        throw Exception('불러오는데 실패했습니다');
      }
    } catch (e) {
      dataPrint(text: e);
      rethrow;
    }
  }
}
