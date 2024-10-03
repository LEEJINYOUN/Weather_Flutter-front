import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/services/bookmark.dart';
import 'package:weather_flutter_front/services/weather.dart';
import 'package:weather_flutter_front/services/location.dart';
import 'package:weather_flutter_front/utils/constant.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/widgets/card/weather_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  List<dynamic> locations = [];
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
        locations = result;
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
              children: [
                // 검색 컨테이너
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      // 검색 필드
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Text(
                          '검색',
                          style: TextStyle(color: Colors.black45, fontSize: 18),
                        ),
                        items: locations
                            .map((item) => DropdownMenuItem(
                                  value: item["location_kr"].toString(),
                                  child: Text(
                                    item["location_kr"].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                          getLocationName(value);
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 300,
                          width: 200,
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: searchController,
                          searchInnerWidgetHeight: 20,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: searchController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    getLocationName(searchController.text
                                        .replaceAll(RegExp('\\s'), ""));
                                  },
                                  child: const Icon(Icons.search,
                                      color: Colors.black54),
                                ),
                                hintText: '지역 검색',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return item.value.toString().contains(searchValue);
                          },
                        ),
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            searchController.clear();
                          }
                        },
                      )),
                    )),
              ],
            ),
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
                    child: Column(
                      children: [
                        WeatherCard(
                            weatherData: weatherData,
                            searched: searched,
                            isBookmark: isBookmark,
                            bookmarkIconClick: bookmarkIconClick),
                      ],
                    )
                    // 날씨 정보 카드
                    )
          ]),
        ),
      ),
    );
  }
}
