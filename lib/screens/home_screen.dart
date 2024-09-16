import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:weather/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_flutter_front/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 날씨 api 설정
  final WeatherFactory _wf = WeatherFactory(apiKey, language: Language.KOREAN);

  Weather? _weather;

  @override
  // 날씨 정보 가져오기
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName("Daegu").then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      children: [
        // 공백
        const SizedBox(height: 40),

        // 상단 컨테이너
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 1번 1행
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1번 1행 1열
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('지역 : ${_weather?.areaName}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png")),
                        ),
                        child: const Text('날씨 아이콘 : '),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('기온 : ${_weather?.temperature}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('최고 기온 :  ${_weather?.tempMax}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('최저 기온 :  ${_weather?.tempMin}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('습도 :  ${_weather?.humidity} %',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('풍속 :  ${_weather?.windSpeed} m/s',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('구름 :  ${_weather?.cloudiness} %',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('날씨 설명 :  ${_weather?.weatherDescription}',
                          style: const TextStyle(fontSize: 20))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
