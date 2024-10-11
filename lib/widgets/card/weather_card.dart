import 'package:flutter/material.dart';
import 'package:weather_flutter_front/utils/celsiusConversion.dart';
import 'package:weather_flutter_front/widgets/table/weather/main_info_field.dart';
import 'package:weather_flutter_front/widgets/table/weather/sub_info_field.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

class WeatherCard extends StatelessWidget {
  // 변수
  final dynamic weatherData;
  final String? inputText;
  final bool isBookmark;
  final VoidCallback bookmarkIconClick;

  const WeatherCard({
    super.key,
    required this.weatherData,
    this.inputText,
    required this.isBookmark,
    required this.bookmarkIconClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단 컨테이너 (메인 정보)
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(170, 205, 205, 205),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            // 즐겨찾기 아이콘
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isBookmark == true
                    ? IconButton(
                        icon: const Icon(
                          FluentSystemIcons.ic_fluent_heart_filled,
                        ),
                        color: Colors.red,
                        onPressed: bookmarkIconClick,
                      )
                    : IconButton(
                        icon: const Icon(
                          FluentSystemIcons.ic_fluent_heart_regular,
                        ),
                        color: Colors.red,
                        onPressed: bookmarkIconClick,
                      ),
              ],
            ),

            // 지역, 날씨 아이콘
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MainInfoField(value: inputText, fontSize: 25),
                Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png")),
                    )),
              ],
            ),

            // 현재 기온
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainInfoField(
                      value:
                          celsiusConversion(temp: weatherData["main"]["temp"]),
                      fontSize: 25),
                ],
              ),
            ),

            // 최고, 최저 기온
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainInfoField(
                      value:
                          '최고 ${celsiusConversion(temp: weatherData["main"]["temp_max"])}',
                      fontSize: 22),
                  MainInfoField(
                      value:
                          '최저 ${celsiusConversion(temp: weatherData["main"]["temp_min"])}',
                      fontSize: 22),
                ],
              ),
            )
          ]),
        ),

        // 하단 컨테이너 (서브 정보)
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(170, 205, 205, 205),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SubInfoField(
                title: '습도',
                value: '${weatherData["main"]["humidity"]} %',
              ),
              SubInfoField(
                title: '풍속',
                value: '${weatherData["wind"]["speed"]} m/s',
              ),
              SubInfoField(
                title: '구름',
                value: '${weatherData["clouds"]["all"]} %',
              ),
              SubInfoField(
                title: '날씨',
                value: '${weatherData["weather"][0]["description"]}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
