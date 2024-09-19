import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/utils/logPrint.dart';

Future<Map<String, dynamic>> fetchWeather(
  String cityName,
  String apiKey,
) async {
  final response = await http.get(
    Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&lang=Kr&appid=$apiKey'),
  );

  if (response.statusCode == 200) {
    dataPrint(text: 'API 연결 성공, 날씨 데이터 값 받기 성공');
    return json.decode(response.body);
  } else {
    dataPrint(text: response.body);
    throw Exception('연결 실패');
  }
}
