import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/constants.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';

class BookmarkMethod {
  var backendUrl = BACKEND_URL();

  // 유저 별 즐겨찾기 리스트
  Future<dynamic> getBookmarkList(int userId) async {
    try {
      var url = '$backendUrl/bookmark/$userId';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 데이터 값 받기 성공
        dataPrint(text: '즐겨찾기 값 받기 성공');
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
