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
              children: [
                // 검색 컨테이너
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:
                      // 검색
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SearchField<LocationModel>(
                            maxSuggestionsInViewPort: 5,
                            itemHeight: 80,
                            hint: '지역 선택',
                            suggestionsDecoration: SuggestionDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8),
                              ),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            suggestionItemDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                    color: Colors.transparent,
                                    style: BorderStyle.solid,
                                    width: 1.0)),
                            searchInputDecoration: SearchInputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.2),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            marginColor: Colors.grey.shade300,
                            suggestions: locations
                                .map((e) => SearchFieldListItem<LocationModel>(
                                    e.location_kr,
                                    child: LocationTile(location: e)))
                                .toList(),
                          )),
                ),
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

class LocationTile extends StatelessWidget {
  final LocationModel location;

  const LocationTile({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          print({
            'kr': location.location_kr,
            'en': location.location_en,
          });
        },
        child: ListTile(
          title: Text(location.location_kr),
          subtitle: Text(location.location_en),
        ));
  }
}
