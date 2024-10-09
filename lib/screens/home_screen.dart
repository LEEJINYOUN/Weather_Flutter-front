import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_flutter_front/models/clothes_model.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/services/bookmark.dart';
import 'package:weather_flutter_front/services/clothes.dart';
import 'package:weather_flutter_front/services/weather.dart';
import 'package:weather_flutter_front/utils/constant.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/widgets/card/weather_card.dart';
import 'package:weather_flutter_front/widgets/form/text_field.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';
import 'package:translator/translator.dart';

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
  String imagesUrl = EnvData().iconsUrl();

  // 번역관련 변수
  String inputText = '';
  String outputText = '';
  String inputLanguage = 'ko';
  String outputLanguage = 'en';

  // 기타 변수
  Map<String, dynamic> userInfo = {};
  Map<String, dynamic> weatherData = {};
  int imageNumber = 0;
  final List<ClothesModel> clothes = [];
  dynamic temp = 0;
  bool isBookmark = false;

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
      dataPrint(text: e);
    }
  }

  // 검색하기
  void searchActive() {
    translateText();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // 초기화
  void resetActive() {
    setState(() {
      weatherData = {};
      temp = 0;
      searchController.text = '';
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
      dynamic result = await WeatherMethod().getWeatherInfo(cityName);
      setState(() {
        weatherData = result;
        temp =
            double.parse((result["main"]["temp"] - 273.15).toStringAsFixed(1));
        searchController.text = '';
      });
      getClothesTemp();
      getBookmark();
    } catch (e) {
      dataPrint(text: e);
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
      dataPrint(text: e);
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
          locationKr: inputText,
          locationEn: outputText,
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
                      prefixIcon: Icons.search,
                      prefixOnTap: searchActive,
                      suffixIcon: Icons.close,
                      suffixOnTap: resetActive,
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
                            inputText: inputText,
                            isBookmark: isBookmark,
                            bookmarkIconClick: bookmarkIconClick,
                            clothes: clothes))
          ]),
        ),
      ),
    );
  }
}
