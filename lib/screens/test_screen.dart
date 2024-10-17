import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:weather_flutter_front/services/country.dart';
import 'package:weather_flutter_front/services/location.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late List<dynamic> states = [];
  String? countryId;
  String? stateName;

  bool countriesSelect = false;

  final List<dynamic> countries = [];
  final List<dynamic> locations = [];

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
  void getAllLocationByCountryId() async {
    try {
      dynamic result = await LocationMethod().getAllLocationByCountryId(0);

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

  @override
  void initState() {
    super.initState();
    getAllCountry();
    getAllLocationByCountryId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
        appBar: const AppBarField(title: '테스트', isActions: false),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: FormHelper.dropDownWidgetWithLabel(
                        context,
                        '',
                        "나라 선택",
                        countryId,
                        countries,
                        (onChangedVal) {
                          setState(() {
                            countriesSelect = true;
                          });
                          countryId = onChangedVal;
                          print('선택한 나라 : $countryId');

                          states = locations
                              .where((stateItem) =>
                                  stateItem['countryId'].toString() ==
                                  onChangedVal)
                              .toList();
                          stateName = null;
                        },
                        (onValidateVal) {
                          if (onValidateVal == null) {
                            return '나라를 선택하세요.';
                          }
                          return null;
                        },
                        borderFocusColor: Colors.lightBlueAccent,
                        borderColor: Colors.black,
                        borderRadius: 10,
                        labelFontSize: 0,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: FormHelper.dropDownWidgetWithLabel(
                          context, '', '지역 선택', stateName, states,
                          (onChangedVal) {
                        if (countriesSelect == true) {
                          setState(() {
                            stateName = onChangedVal;
                            print('선택한 지역 : $onChangedVal');
                          });
                        }
                      }, (onValidate) {
                        return null;
                      },
                          borderFocusColor: Colors.lightBlueAccent,
                          borderColor: Colors.black,
                          borderRadius: 10,
                          labelFontSize: 0,
                          optionValue: 'locationName',
                          optionLabel: 'locationName'),
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
