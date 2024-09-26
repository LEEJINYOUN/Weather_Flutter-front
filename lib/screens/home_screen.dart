import 'package:flutter/material.dart';
import 'package:weather_flutter_front/services/weather.dart';
import 'package:weather_flutter_front/services/location.dart';
import 'package:weather_flutter_front/utils/logPrint.dart';
import 'package:weather_flutter_front/widgets/card/weather_card.dart';
import 'package:weather_flutter_front/widgets/form/text_field.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  // 변수
  Map<String, dynamic> userInfo = {};
  dynamic locations;
  Map<String, dynamic> weatherData = {};
  bool isLoading = false;
  bool isSearch = false;

  // state 진입시 함수 실행
  @override
  void initState() {
    super.initState();
    getLocations();
  }

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  // 지역 리스트 가져오기
  void getLocations() async {
    try {
      dynamic result = await LocationMethod().getLocationList();
      setState(() {
        locations = result;
      });
    } catch (e) {
      dataPrint(text: e);
      rethrow;
    }
  }

  // 날씨 정보 가져오기
  void fetchData(String cityName) async {
    try {
      dynamic result = await WeatherMethod().getWeatherInfo(cityName);
      setState(() {
        weatherData = result;
      });
    } catch (e) {
      dataPrint(text: e);
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
      searchController.text = '';
    }
  }

  // 검색 초기화
  void resetSubmit() {
    weatherData = {};
    dataPrint(text: '초기화');
    setState(() {
      isSearch = false;
    });
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
          title: const Text("홈", style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              children: [
                // 검색 컨테이너
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child:
                        // 검색 필드
                        TextFieldInput(
                      textEditingController: searchController,
                      textInputType: TextInputType.text,
                      hintText: '지역 검색',
                      prefixOnTap: searchSubmit,
                      prefixIcon: Icons.search,
                      suffixOnTap: resetSubmit,
                      suffixIcon: Icons.close,
                    )),
              ],
            ),
            isSearch == false && weatherData.isEmpty
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
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height - 300,
                    child:
                        // 날씨 정보 카드
                        WeatherCard(weatherData: weatherData))
          ]),
        ),
      ),
    );
  }
}
