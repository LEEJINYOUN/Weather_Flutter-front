import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_flutter_front/constants.dart';
import 'package:weather_flutter_front/widgets/button/blue_Button.dart';
import 'package:weather_flutter_front/widgets/form/text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 날씨 api 설정
  final WeatherFactory _wf = WeatherFactory(apiKey, language: Language.KOREAN);
  Weather? _weather;

  // 입력 컨트롤러
  final TextEditingController searchController = TextEditingController();

  String cityName = 'Seoul';

  // 로딩 체크
  bool isLoading = false;

  // 날씨 정보 가져오기
  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  // 입력 값 체크 (임시)
  void dataPrint(String text) {
    log(text);
  }

  // 날씨 검색
  void searchSubmit() {
    setState(() {
      isLoading = true;
    });

    if (searchController.text != '') {
      dataPrint(searchController.text);
    }
  }

  // 검색 초기화
  void resetSubmit() {
    searchController.text = '';
    dataPrint('초기화');
  }

  @override
  Widget build(BuildContext context) {
    if (_weather == null) {
      return const Center(
        child: Text('검색하세요.'),
      );
    }
    return ListView(
      children: [
        // 검색 컨테이너
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              TextFieldInput(
                  icon: Icons.search,
                  textEditingController: searchController,
                  hintText: '지역 검색',
                  textInputType: TextInputType.text),
              BlueButton(onTap: searchSubmit, text: "검색"),
              BlueButton(onTap: resetSubmit, text: "초기화"),
            ],
          ),
        ),

        // 공백
        const SizedBox(height: 10),

        // 날씨 컨테이너
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 1행
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 1행 1열
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('지역 : ${_weather?.areaName}',
                            style: const TextStyle(fontSize: 18)),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png")),
                          ),
                          child: const Text('날씨 아이콘 : ',
                              style: TextStyle(fontSize: 18)),
                        )
                      ]),
                  // 1행 2열
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('기온 : ${_weather?.temperature}',
                            style: const TextStyle(fontSize: 18)),
                        Text('최고 기온 :  ${_weather?.tempMax}',
                            style: const TextStyle(fontSize: 18)),
                        Text('최저 기온 :  ${_weather?.tempMin}',
                            style: const TextStyle(fontSize: 18)),
                      ])
                ],
              ),

              // 공백
              const SizedBox(
                height: 15,
              ),

              // 2행
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 2행 1열
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('습도 : ${_weather?.humidity} %',
                            style: const TextStyle(fontSize: 20)),
                        Text('풍속 :  ${_weather?.windSpeed} m/s',
                            style: const TextStyle(fontSize: 20)),
                      ]),
                  // 2행 2열
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('구름 : ${_weather?.cloudiness} %',
                            style: const TextStyle(fontSize: 18)),
                        Text(' :  ${_weather?.tempMax}',
                            style: const TextStyle(fontSize: 18)),
                      ])
                ],
              ),

              // 공백
              const SizedBox(
                height: 15,
              ),

              // 3행
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 3행 1열
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('날씨 설명 :  ${_weather?.weatherDescription}',
                            style: const TextStyle(fontSize: 17))
                      ]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
