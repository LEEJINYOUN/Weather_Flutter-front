import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/utils/constant.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';

class BookmarkMethod {
  var backendUrl = EnvData().backendApi();

  // 유저별 즐겨찾기 목록 조회
  Future<dynamic> getBookmarks(int userId) async {
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
        dataPrint(text: '즐겨찾기 목록 조회 성공');
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

  // 유저별 즐겨찾기 지역 조회
  Future<dynamic> getBookmarkLocation(
      {required int userId, required int locationId}) async {
    try {
      var url = '$backendUrl/bookmark/$userId/$locationId';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 데이터 값 받기 성공
        dataPrint(text: '즐겨찾기 지역 조회 성공');
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

  // 즐겨찾기 추가 및 삭제
  Future<dynamic> editBookmark(
      {required int userId,
      required int locationId,
      required String locationKr,
      required String locationEn}) async {
    try {
      var url = '$backendUrl/bookmark/$userId';

      var reqBody = {
        'location_id': locationId,
        'location_kr': locationKr,
        'location_en': locationEn
      };
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // 데이터 값 받기 성공
        dataPrint(text: '즐겨찾기 수정 성공');
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
