import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_front/utilities/env_constant.dart';

class BookmarkMethod {
  var backendUrl = EnvConstant().backendApi();

  // 유저별 모든 즐겨찾기 조회
  Future<dynamic> getBookmarks(int userId) async {
    try {
      var url = '$backendUrl/bookmark/all/$userId';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 데이터 값 받기 성공
        debugPrint('즐겨찾기 목록 조회 성공' as dynamic);
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

  // 유저별 즐겨찾기 지역 조회
  Future<dynamic> getBookmarkLocation(
      {required int userId, required String locationKr}) async {
    try {
      var url = '$backendUrl/bookmark/$userId?locationKr=$locationKr';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 데이터 값 받기 성공
        debugPrint('즐겨찾기 지역 조회 성공' as dynamic);
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

  // 즐겨찾기 추가 및 삭제
  Future<dynamic> editBookmark({
    required int userId,
    required String locationKr,
    required String locationEn,
    required int imageNumber,
  }) async {
    try {
      var url = '$backendUrl/bookmark/update/$userId';

      var reqBody = {
        locationKr,
        locationEn,
        imageNumber,
      };
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // 데이터 값 받기 성공
        debugPrint('즐겨찾기 수정 성공' as dynamic);
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
