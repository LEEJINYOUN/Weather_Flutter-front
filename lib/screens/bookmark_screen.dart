import 'package:flutter/material.dart';
import 'package:weather_flutter_front/services/authentication.dart';
import 'package:weather_flutter_front/services/bookmark.dart';
import 'package:weather_flutter_front/services/weather.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/widgets/card/weather_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  // storage
  final storage = const FlutterSecureStorage();

  // 입력 컨트롤러
  final TextEditingController searchController = TextEditingController();

  // 변수
  Map<String, dynamic> userInfo = {};
  dynamic bookmarks;
  Map<String, dynamic> weatherData = {};
  bool isBookmarkList = false;

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
      var getUserInfo = await AuthMethod().user(token: token);
      setState(() {
        userInfo = getUserInfo;
      });
      getBookmarks();
    } catch (e) {
      dataPrint(text: e);
    }
  }

  // 즐겨찾기 리스트 가져오기
  void getBookmarks() async {
    try {
      dynamic result = await BookmarkMethod().getBookmarkList(userInfo['id']);
      setState(() {
        isBookmarkList = true;
        bookmarks = result;
      });
      print(bookmarks.length);
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

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/bg_image1.jpg'), // 배경 이미지
          ),
        ),
        child: Scaffold(
            backgroundColor: const Color.fromARGB(49, 232, 232, 232),
            resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
            appBar: AppBar(
              centerTitle: true,
              elevation: 5,
              title: const Text("즐겨찾기",
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  // 즐겨찾기 리스트
                  Column(
                    children: [
                      Text('즐겨찾기 개수 ( ${bookmarks.length} )',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: isBookmarkList
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  itemCount: bookmarks.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () => getWeather(
                                            '${bookmarks[index]['location_en']}'),
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/images/bg_image2.jpg'), // 배경 이미지
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              '${bookmarks[index]['location_kr']}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ))));
                                  })
                              : null)
                    ],
                  ),
                  weatherData.isEmpty
                      ? // 날씨 정보 없는 경우
                      const Center(
                          child: Column(
                            children: [
                              Text(
                                '선택하세요.',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
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
                              WeatherCard(weatherData: weatherData))
                ]))));
  }
}
