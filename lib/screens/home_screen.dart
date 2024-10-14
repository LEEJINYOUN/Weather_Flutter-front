import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/models/clothes_model.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/services/bookmark.dart';
import 'package:weather_flutter_front/services/clothes.dart';
import 'package:weather_flutter_front/services/weather.dart';
import 'package:weather_flutter_front/utilities/bg_change.dart';
import 'package:weather_flutter_front/utilities/celsius_conversion.dart';
import 'package:weather_flutter_front/utilities/env_constant.dart';
import 'package:weather_flutter_front/widgets/card/clothes_card.dart';
import 'package:weather_flutter_front/widgets/card/weather_card.dart';
import 'package:weather_flutter_front/widgets/form/text_field.dart';
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

  // 구글 번역 선언
  final translator = GoogleTranslator();

  // cdn 주소
  String imagesUrl = EnvConstant().imageFrontUrl();

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

  // 검색하기
  void searchActive() {
    setState(() {
      errorMessage = '';
    });
    translateText();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // 초기화
  void resetActive() {
    setState(() {
      resetList();
      searchController.text = '';
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // 초기화 목록
  void resetList() {
    setState(() {
      weatherData = {};
      currentTemp = 0;
      errorMessage = '';
      isClick = false;
    });
  }

  // 검색어 번역
  Future<void> translateText() async {
    final translated = await translator.translate(searchController.text,
        from: inputLanguage, to: outputLanguage);

    setState(() {
      inputText = searchController.text;
      outputText = translated.text;
    });
    getWeather(outputText);
  }

  // 날씨 정보 가져오기
  void getWeather(String cityName) async {
    try {
      resetList();
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            // 상단 컨테이너
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 150,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    child:

                        // 검색 창
                        TextFieldInput(
                      textEditingController: searchController,
                      hintText: '지역 검색',
                      textInputType: TextInputType.text,
                      prefixIcon: Icons.search,
                      prefixOnTap: searchActive,
                      suffixIcon: Icons.close,
                      suffixOnTap: resetActive,
                    )),
              ),
            ),

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
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 250,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        margin: const EdgeInsets.only(
                                            top: 30, bottom: 20),
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            // 옷 타이틀
                                            Container(
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 10),
                                              child: const Text(
                                                '- 오늘의 옷 추천 -',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),

                                            // 옷 리스트
                                            ClothesCard(clothes: clothes)
                                          ],
                                        ))
                                  ],
                                )),
                              ))
          ]),
        ),
      ),
    );
  }
}
