import 'package:flutter/material.dart';
import 'package:weather_flutter_front/models/clothes_model.dart';

import 'package:weather_flutter_front/services/bookmark.dart';
import 'package:weather_flutter_front/services/clothes.dart';
import 'package:weather_flutter_front/services/weather.dart';
import 'package:weather_flutter_front/utilities/bg_change.dart';
import 'package:weather_flutter_front/utilities/celsius_conversion.dart';
import 'package:weather_flutter_front/utilities/env_constant.dart';
import 'package:weather_flutter_front/utilities/user_info.dart';
import 'package:weather_flutter_front/widgets/card/weather_card.dart';

import 'package:weather_flutter_front/widgets/container/bookmark_container_field.dart';
import 'package:weather_flutter_front/widgets/container/clothes_container_field.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';
import 'package:weather_flutter_front/widgets/text/empty_text_field.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  // cdn 주소
  var imagesUrl = EnvConstant().imageFrontUrl();

  // 번역관련 변수
  dynamic inputText = '';
  dynamic outputText = '';
  dynamic outputNumber = '';

  // 기타 변수
  Map<String, dynamic> userInfo = {};
  dynamic bookmarks;
  int bookmarkLen = 0;
  Map<String, dynamic> weatherData = {};
  bool isBookmarkList = false;
  bool isBookmark = true;
  final List<ClothesModel> clothes = [];
  double currentTemp = 0;
  String errorMessage = '';
  bool isClick = false;

  // state 진입시 함수 실행
  @override
  void initState() {
    super.initState();
    userData();
  }

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    super.dispose();
  }

  // 유저 정보 가져오기
  void userData() async {
    dynamic data = await getUserInfo();
    setState(() {
      userInfo = data;
    });
    getBookmarks();
  }

  // 즐겨찾기 리스트 가져오기
  void getBookmarks() async {
    try {
      dynamic result = await BookmarkMethod().getBookmarks(userInfo['id']);
      setState(() {
        isBookmarkList = true;
        bookmarks = result;
        bookmarkLen = bookmarks.length;
      });
    } catch (e) {
      debugPrint(e as dynamic);
      rethrow;
    }
  }

  // 날씨 정보 가져오기
  void getWeather(String cityName) async {
    try {
      dynamic result = await WeatherMethod().getWeatherInfo(cityName);
      setState(() {
        weatherData = result;
        currentTemp =
            double.parse(celsiusConversion(temp: weatherData["main"]["temp"]));
        isClick = true;
      });
      getClothesTemp();
    } catch (e) {
      debugPrint(e as dynamic);
    }
  }

  // 즐겨찾기 지역 조회
  void getBookmark() async {
    try {
      dynamic result = await BookmarkMethod()
          .getBookmarkLocation(userId: userInfo['id'], locationKr: inputText);
      if (result != 0) {
        setState(() {
          isBookmark = true;
        });
      }
    } catch (e) {
      debugPrint(e as dynamic);
    }
  }

  // 선택한 지역 이름 번역
  void changeKrToEn(Map<String, String> data) {
    setState(() {
      inputText = data['locationKr'];
      outputText = data['locationEn'];
      outputNumber = data['imageNumber'];
    });
    getBookmark();
    getWeather(outputText);
  }

  // 즐겨찾기 기능
  void bookmarkIconClick() async {
    try {
      // 즐겨찾기 추가 및 삭제 API 연동
      dynamic result = await BookmarkMethod().editBookmark(
        userId: userInfo['id'],
        locationKr: inputText,
        locationEn: outputText,
        imageNumber: int.parse(outputNumber),
      );

      if (result == true) {
        setState(() {
          isBookmark = false;
          isClick = false;
          weatherData = {};
        });
        getBookmarks();
      }
    } catch (e) {
      debugPrint(e as dynamic);
    }
  }

  // 기온 별 옷 리스트 가져오기
  void getClothesTemp() async {
    if (weatherData.isNotEmpty) {
      try {
        dynamic result = await ClothesMethod().getClothesByTemp(currentTemp);
        setState(() {
          clothes.clear();
          result.forEach((element) {
            clothes.add(ClothesModel.fromJson(element));
          });
        });
      } catch (e) {
        debugPrint(e as dynamic);
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                '$imagesUrl/images/${!isClick ? 'bg-main.jpg' : bgChange(isClick: isClick, currentIcon: weatherData['weather'][0]['icon'])}'), // 배경 이미지
          ),
        ),
        child: Scaffold(
            backgroundColor: const Color.fromARGB(155, 147, 147, 147),
            resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
            appBar: const AppBarField(title: '즐겨찾기', isActions: true),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  // 상단 컨테이너
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Column(
                      children: [
                        // 즐겨찾기 개수
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, left: 20),
                                child: Text(
                                  '즐겨찾기 ( $bookmarkLen )',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )),
                          ],
                        ),

                        // 즐겨찾기 리스트 컨테이너
                        BookmarkContainerField(
                          isBookmarkList: isBookmarkList,
                          bookmarks: bookmarks,
                          changeKrToEn: changeKrToEn,
                        )
                      ],
                    ),
                  ),

                  // 하단 컨테이너
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height - 300,
                      child: weatherData.isEmpty
                          ? // 날씨 정보 없는 경우
                          const EmptyTextField(content: '지역을 선택해 주세요.')
                          : // 날씨 정보 있는 경우
                          SizedBox(
                              child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                    // 날씨 정보
                                    WeatherCard(
                                      weatherData: weatherData,
                                      inputText: inputText,
                                      isBookmark: isBookmark,
                                      bookmarkIconClick: bookmarkIconClick,
                                    ),

                                    // 옷 컨테이너
                                    ClothesContainerField(clothes: clothes)
                                  ])),
                            ))
                ]))));
  }
}
