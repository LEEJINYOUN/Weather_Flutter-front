import 'package:flutter/material.dart';
import 'package:weather_flutter_front/models/clothes_model.dart';
import 'package:weather_flutter_front/utils/celsiusConversion.dart';
import 'package:weather_flutter_front/widgets/container/clothes_container.dart';
import 'package:weather_flutter_front/widgets/table/weather/main_info_field.dart';
import 'package:weather_flutter_front/widgets/table/weather/sub_info_field.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

class WeatherCard extends StatelessWidget {
  // 변수
  final dynamic weatherData;
  final String? inputText;
  final bool isBookmark;
  final VoidCallback bookmarkIconClick;
  final List<ClothesModel> clothes;

  const WeatherCard({
    super.key,
    required this.weatherData,
    this.inputText,
    required this.isBookmark,
    required this.bookmarkIconClick,
    required this.clothes,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  MainInfoField(value: inputText, fontSize: 25),
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
                    MainInfoField(
                        value: celsiusConversion(
                            temp: weatherData["main"]["temp"]),
                        fontSize: 25),
                  ],
                ),
              ),
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

          // 서브 정보
          Container(
            margin: const EdgeInsets.only(top: 50),
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

          // 옷 추천 정보
          ClothesContainer(clothes: clothes),
        ],
      ),
    );
  }
}
