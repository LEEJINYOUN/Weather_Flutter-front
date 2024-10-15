import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<dynamic> countries = [];
  List<dynamic> stateMasters = [];
  List<dynamic> states = [];
  String? countryId;
  String? stateId;

  bool countriesSelect = false;

  @override
  void initState() {
    super.initState();
    countries.add({'id': 1, 'name': '한국'});
    countries.add({'id': 2, 'name': '일본'});
    countries.add({'id': 3, 'name': '중국'});

    stateMasters = [
      {'ID': 1, 'Name': '대구', 'ParentId': 1},
      {'ID': 2, 'Name': '서울', 'ParentId': 1},
      {'ID': 3, 'Name': '포항', 'ParentId': 1},
      {'ID': 1, 'Name': '오사카', 'ParentId': 2},
      {'ID': 2, 'Name': '도쿄', 'ParentId': 2},
      {'ID': 1, 'Name': '베이징', 'ParentId': 3},
      {'ID': 2, 'Name': '난징', 'ParentId': 3},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('테스트'),
          backgroundColor: Colors.redAccent,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              FormHelper.dropDownWidgetWithLabel(
                context,
                '나라',
                "나라 선택",
                countryId,
                countries,
                (onChangedVal) {
                  setState(() {
                    countriesSelect = true;
                  });
                  countryId = onChangedVal;
                  print('선택한 나라 : $onChangedVal');

                  states = stateMasters
                      .where((stateItem) =>
                          stateItem['ParentId'].toString() ==
                          onChangedVal.toString())
                      .toList();
                  stateId = null;
                },
                (onValidateVal) {
                  if (onValidateVal == null) {
                    return '나라를 선택하세요.';
                  }

                  return null;
                },
                borderFocusColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
                borderRadius: 10,
              ),
              FormHelper.dropDownWidgetWithLabel(
                  context, '지역', '지역 선택', stateId, states, (onChangedVal) {
                if (countriesSelect == true) {
                  stateId = onChangedVal;
                  print('선택한 지역 : $onChangedVal');
                }
                setState(() {
                  countriesSelect = false;
                });
              }, (onValidate) {
                return null;
              },
                  borderFocusColor: Theme.of(context).primaryColor,
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: 10,
                  optionValue: 'ID',
                  optionLabel: 'Name')
            ],
          ),
        ));
  }
}
