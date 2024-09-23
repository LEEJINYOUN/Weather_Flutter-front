import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/constants.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';

Future<List<dynamic>> getLocationList() async {
  var url = '${backendUrl()}/location';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    dataPrint(text: 'API 연결 성공, 지역리스트 값 받기 성공');
    return json.decode(response.body);
  } else {
    throw Exception('불러오는데 실패했습니다');
  }
}
