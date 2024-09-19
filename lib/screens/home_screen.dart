import 'package:flutter/material.dart';
import 'package:weather_flutter_front/constants.dart';
import 'package:weather_flutter_front/utils/celsiusConversion.dart';
import 'package:weather_flutter_front/services/fetchWeather.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 변수
  final TextEditingController searchController = TextEditingController();
  Map<String, dynamic> weatherData = {};

  // 체크
  bool isLoading = false;
  bool isSearch = false;

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  // 날씨 정보 가져오기
  Future<void> fetchData(String cityName) async {
    try {
      Map<String, dynamic> data = await fetchWeather(cityName, apiKey());
      setState(() {
        weatherData = data;
      });
    } catch (error) {
      dataPrint(text: error);
    }
  }

  // 날씨 검색
  void searchSubmit() async {
    setState(() {
      isLoading = true;
      isSearch = true;
    });

    if (searchController.text != '') {
      fetchData(searchController.text);
      dataPrint(text: searchController.text);
    }
  }

  // 검색 초기화
  void resetSubmit() {
    searchController.text = '';
    dataPrint(text: '초기화');
    setState(() {
      isSearch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        title: const Text("홈", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 15),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      onTap: searchSubmit,
                      child: const Icon(Icons.search, color: Colors.black54),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: resetSubmit,
                      child: const Icon(Icons.close, color: Colors.black54),
                    ),
                    hintText: '지역 검색',
                    hintStyle:
                        const TextStyle(color: Colors.black45, fontSize: 18),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
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
                  keyboardType: TextInputType.text,
                  obscureText: false,
                ),
              ),
            ],
          ),
          isSearch == false && weatherData.isEmpty
              ? const Text('검색하세요.')
              : SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height - 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 메인 정보
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${weatherData["name"]}',
                                  style: const TextStyle(fontSize: 18)),
                              Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png")),
                                  )),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    celsiusConversion(
                                        temp: weatherData["main"]["temp"]),
                                    style: const TextStyle(fontSize: 18))
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '최고 ${celsiusConversion(temp: weatherData["main"]["temp_max"])}',
                                    style: const TextStyle(fontSize: 18)),
                                Text(
                                    '최저 ${celsiusConversion(temp: weatherData["main"]["temp_min"])}',
                                    style: const TextStyle(fontSize: 18))
                              ],
                            ),
                          )
                        ]),
                      ),

                      // 서브 정보
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('습도',
                                      style: TextStyle(fontSize: 18)),
                                  Text('${weatherData["main"]["humidity"]} %',
                                      style: const TextStyle(fontSize: 18))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('풍속',
                                      style: TextStyle(fontSize: 18)),
                                  Text('${weatherData["wind"]["speed"]} m/s',
                                      style: const TextStyle(fontSize: 18))
                                ],
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('구름',
                                        style: TextStyle(fontSize: 18)),
                                    Text('${weatherData["clouds"]["all"]} %',
                                        style: const TextStyle(fontSize: 18))
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('날씨',
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                      '${weatherData["weather"][0]["description"]}',
                                      style: const TextStyle(fontSize: 18))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
        ]),
      ),
    );
  }
}
