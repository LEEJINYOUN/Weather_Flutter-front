import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_flutter_front/models/location_model.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/services/bookmark.dart';
import 'package:weather_flutter_front/services/weather.dart';
import 'package:weather_flutter_front/services/location.dart';
import 'package:weather_flutter_front/utils/constant.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/widgets/card/weather_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';
import 'package:searchfield/searchfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // storage
  final storage = const FlutterSecureStorage();

  // 입력 컨트롤러
  final TextEditingController searchController = TextEditingController();

  // cdn 주소
  var imagesUrl = EnvData().iconsUrl();

  // 변수
  Map<String, dynamic> userInfo = {};
  final List<LocationModel> locations = [];
  Map<String, dynamic> weatherData = {};
  Map<String, dynamic> searched = {
    'id': 0,
    'location_kr': "",
    'location_en': "",
  };
  bool isBookmark = false;
  int imageNumber = 0;
  String? selectedValue;

  // state 진입시 함수 실행
  @override
  void initState() {
    getLocations();
    getUserInfo();
    super.initState();
  }

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // 유저 정보 가져오기
  void getUserInfo() async {
    try {
      var token = await storage.read(key: "token");
      var getUserInfo = await AuthMethod().getUser(token: token);
      setState(() {
        userInfo = getUserInfo;
      });
    } catch (e) {
      dataPrint(text: e);
    }
  }

  // 지역 리스트 가져오기
  void getLocations() async {
    try {
      dynamic result = await LocationMethod().getLocationList();
      setState(() {
        result.forEach((element) {
          locations.add(LocationModel.fromJson(element));
        });
      });
    } catch (e) {
      dataPrint(text: e);
      rethrow;
    }
  }

  // 날씨 정보 가져오기
  void getWeather(String cityName) async {
    try {
      dynamic result = await WeatherMethod().getWeatherInfo(cityName);
      setState(() {
        weatherData = result;
      });
    } catch (e) {
      dataPrint(text: e);
    }
  }

  // 즐겨찾기 지역 조회
  void getBookmark() async {
    try {
      dynamic result = await BookmarkMethod().getBookmarkLocation(
          userId: userInfo['id'], locationId: searched['id']);
      if (result != 0) {
        setState(() {
          isBookmark = true;
        });
      }
    } catch (e) {
      dataPrint(text: e);
    }
  }

  // 이름으로 지역 검색
  void getLocationName(name) async {
    try {
      dynamic result = await LocationMethod().getLocationByName(name);
      setState(() {
        searched['id'] = result['id'];
        searched['location_kr'] = result['location_kr'];
        searched['location_en'] = result['location_en'];
      });
      getBookmark();
      getWeather(searched['location_en']);
      setState(() {
        isBookmark = false;
      });
    } catch (e) {
      dataPrint(text: e);
      rethrow;
    }
  }

  // 즐겨찾기 기능
  void bookmarkIconClick() async {
    try {
      // 랜덤 숫자
      setState(() {
        imageNumber = Random().nextInt(5) + 1;
      });

      // 즐겨찾기 추가 및 삭제 API 연동
      dynamic result = await BookmarkMethod().editBookmark(
          userId: userInfo['id'],
          locationId: searched['id'],
          locationKr: searched['location_kr'],
          locationEn: searched['location_en'],
          imageNumber: imageNumber);

      if (result != true) {
        setState(() {
          isBookmark = true;
        });
      } else {
        setState(() {
          isBookmark = false;
        });
      }
    } catch (e) {
      dataPrint(text: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage('$imagesUrl/images/bg_image1.jpg'), // 배경 이미지
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(49, 232, 232, 232),
        resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
        appBar: const AppBarField(title: '홈'),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 80,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.red),
                  ),

                  // 검색
                  child: SearchField<LocationModel>(
                    dynamicHeight: true,
                    showEmpty: false,
                    controller: searchController,
                    marginColor: Colors.blue,
                    maxSuggestionsInViewPort: 5,
                    searchInputDecoration: SearchInputDecoration(
                      // suffixIcon: GestureDetector(
                      //   onTap: () {
                      //     getLocationName(searchController.text);
                      //   },
                      //   child: const Icon(Icons.search),
                      // ),
                      hintText: '지역 검색',
                      hintStyle:
                          const TextStyle(color: Colors.black45, fontSize: 18),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFedf0f8),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                    suggestionItemDecoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            color: Colors.transparent,
                            style: BorderStyle.solid,
                            width: 1)),
                    suggestions: locations
                        .map((e) => SearchFieldListItem<LocationModel>(
                            e.location_kr,
                            child: Text(e.location_kr)))
                        .toList(),
                  ),
                ),
              ],
            ),
            // 검색 컨테이너

            weatherData.isEmpty
                ? // 날씨 정보 없는 경우
                const Center(
                    child: Column(
                      children: [
                        Text(
                          '검색하세요.',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : // 날씨 정보 있는 경우
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height - 300,
                    child:
                        // 날씨 정보 카드
                        WeatherCard(
                            weatherData: weatherData,
                            searched: searched,
                            isBookmark: isBookmark,
                            bookmarkIconClick: bookmarkIconClick))
          ]),
        ),
      ),
    );
  }
}
