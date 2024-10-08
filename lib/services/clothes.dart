import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/utils/constant.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';

class ClothesMethod {
  var backendUrl = EnvData().backendApi();

  // 지역 이름으로 조회
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
        dataPrint(text: '기온 별 옷 받기 성공');
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
