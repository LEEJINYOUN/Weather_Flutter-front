import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/models/clothes_model.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/services/bookmark.dart';
import 'package:weather_flutter_front/services/clothes.dart';
import 'package:weather_flutter_front/services/country.dart';
import 'package:weather_flutter_front/services/location.dart';
import 'package:weather_flutter_front/services/weather.dart';
import 'package:weather_flutter_front/utilities/bg_change.dart';
import 'package:weather_flutter_front/utilities/celsius_conversion.dart';
import 'package:weather_flutter_front/utilities/env_constant.dart';
import 'package:weather_flutter_front/widgets/card/weather_card.dart';
import 'package:weather_flutter_front/widgets/container/clothes_container_field.dart';
import 'package:weather_flutter_front/widgets/container/select_box_container_field.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';
import 'package:translator/translator.dart';
import 'package:weather_flutter_front/widgets/text/empty_text_field.dart';

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
  String imagesUrl = EnvConstant().imageFrontUrl();

  // 나라, 지역 선택관련 변수
  late List<dynamic> states = [];
  dynamic countryId;
  dynamic stateName;
  bool countriesSelect = false;
  final List<dynamic> countries = [];
  final List<dynamic> locations = [];

  // 구글 번역 선언
  final translator = GoogleTranslator();

  // 번역관련 변수
  String inputText = '';
  String outputText = '';
  String inputLanguage = 'ko';
  String outputLanguage = 'en';

  // 기타 변수
  Map<String, dynamic> userInfo = {};
  Map<String, dynamic> weatherData = {};
  final List<ClothesModel> clothes = [];
  double currentTemp = 0;
  bool isBookmark = false;
  bool isClick = false;
  String errorMessage = '';

  // state 진입시 함수 실행
  @override
  void initState() {
    super.initState();
    getUserInfo();
    getAllCountry();
    getAllLocation();
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
      debugPrint(e as dynamic);
    }
  }

  // 모든 나라 조회
  void getAllCountry() async {
    try {
      dynamic result = await CountryMethod().getAllCountry();

      setState(() {
        countries.clear();
        result.forEach((element) {
          countries.add(element);
        });
      });
    } catch (e) {
      debugPrint(e as dynamic);
      rethrow;
    }
  }

  // 나라별 모든 지역 조회
  void getAllLocation() async {
    try {
      dynamic result = await LocationMethod().getAllLocation();

      setState(() {
        locations.clear();
        result.forEach((element) {
          locations.add(element);
        });
      });
    } catch (e) {
      debugPrint(e as dynamic);
      rethrow;
    }
  }

  // 선택 대분류 값 변경
  void mainSelectOnChangedVal(onChangedVal) {
    setState(() {
      countriesSelect = true;
    });
    countryId = onChangedVal;

    states = locations
        .where((stateItem) => stateItem['countryId'].toString() == onChangedVal)
        .toList();
    stateName = '지역 선택';
  }

  // 선택 소분류 값 변경
  void subSelectOnChangedVal(onChangedVal) {
    if (countriesSelect == true) {
      setState(() {
        stateName = onChangedVal;
        translateText();
      });
    }
  }

  // 검색할 지역 번역
  Future<void> translateText() async {
    final translated = await translator.translate(stateName,
        from: inputLanguage, to: outputLanguage);

    setState(() {
      inputText = stateName;
      outputText = translated.text;
    });
    getWeather(outputText);
  }

  // 날씨 정보 가져오기
  void getWeather(String cityName) async {
    try {
      // 정보 초기화
      setState(() {
        weatherData = {};
        currentTemp = 0;
        errorMessage = '';
        isClick = false;
      });
      dynamic result = await WeatherMethod().getWeatherInfo(cityName);
      setState(() {
        weatherData = result;
        currentTemp =
            double.parse(celsiusConversion(temp: weatherData["main"]["temp"]));
        searchController.text = '';
        isClick = true;
      });
      getClothesTemp();
      getBookmark();
    } catch (e) {
      setState(() {
        errorMessage = '등록된 지역이 없습니다.';
      });
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
      } else {
        setState(() {
          isBookmark = false;
        });
      }
    } catch (e) {
      debugPrint(e as dynamic);
    }
  }

  // 즐겨찾기 기능
  void bookmarkIconClick() async {
    try {
      // 즐겨찾기 추가 및 삭제 API 연동
      dynamic result = await BookmarkMethod().editBookmark(
          userId: userInfo['id'],
          locationKr: inputText,
          locationEn: outputText,
          imageNumber: 1);

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
              '$imagesUrl/images/${!isClick ? 'bg-image.jpg' : bgChange(isClick: isClick, currentIcon: weatherData['weather'][0]['icon'])}'), // 배경 이미지
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(155, 147, 147, 147),
        resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
        appBar: const AppBarField(title: '홈', isActions: true),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 상단 컨테이너
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child:
                    // 선택 박스 컨테이너
                    SelectBoxContainerField(
                  states: states,
                  countryId: countryId,
                  stateName: stateName,
                  countries: countries,
                  mainSelectOnChangedVal: mainSelectOnChangedVal,
                  subSelectOnChangedVal: subSelectOnChangedVal,
                )),

            // 하단 컨테이너
            SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height - 300,
                child:
                    // 검색 전
                    weatherData.isEmpty && errorMessage == ''
                        ? const EmptyTextField(content: '지역을 검색해 주세요.')

                        // 검색 후 에러 발생
                        : weatherData.isEmpty && errorMessage != ''
                            ? EmptyTextField(content: errorMessage)

                            // 검색 후 데이터 호출
                            : SizedBox(
                                child: SingleChildScrollView(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  ],
                                )),
                              ))
          ],
        )),
      ),
    );
  }
}
