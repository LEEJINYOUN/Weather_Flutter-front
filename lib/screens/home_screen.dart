import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_flutter_front/models/clothes_model.dart';
import 'package:weather_flutter_front/models/location_model.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/services/bookmark.dart';
import 'package:weather_flutter_front/services/clothes.dart';
import 'package:weather_flutter_front/services/weather.dart';
import 'package:weather_flutter_front/services/location.dart';
import 'package:weather_flutter_front/utils/constant.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/widgets/card/weather_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/widgets/form/text_field.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';

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
  final List<ClothesModel> clothes = [];
  dynamic temp = 0;

  // state 진입시 함수 실행
  @override
  void initState() {
    super.initState();
    getLocations();
    getUserInfo();
  }

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
        temp =
            double.parse((result["main"]["temp"] - 273.15).toStringAsFixed(1));
        searchController.text = '';
      });
      getClothesTemp();
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

  // 기온 별 옷 리스트 가져오기
  void getClothesTemp() async {
    if (weatherData.isNotEmpty) {
      try {
        dynamic result = await ClothesMethod().getClothesByTemp(temp);
        setState(() {
          result.forEach((element) {
            clothes.add(ClothesModel.fromJson(element));
          });
        });
      } catch (e) {
        dataPrint(text: e);
        rethrow;
      }
    }
  }

  void searchClick() {
    // print(searchController.text);
    FocusManager.instance.primaryFocus?.unfocus();
    getLocationName(searchController.text);
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
                // 검색 컨테이너
                Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 80,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    // 검색
                    child: TextFieldInput(
                      textEditingController: searchController,
                      hintText: '지역 검색',
                      textInputType: TextInputType.text,
                      suffixIcon: Icons.search,
                      suffixOnTap: searchClick,
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
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height - 300,
                    child:
                        // 날씨 정보 카드
                        WeatherCard(
                            weatherData: weatherData,
                            searched: searched,
                            isBookmark: isBookmark,
                            bookmarkIconClick: bookmarkIconClick,
                            clothes: clothes))
          ]),
        ),
      ),
    );
  }
}
