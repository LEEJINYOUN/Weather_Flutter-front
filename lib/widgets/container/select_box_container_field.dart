import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class SelectBoxContainerField extends StatelessWidget {
  // 변수
  final dynamic countryName;
  final dynamic stateName;
  final List<dynamic> countries;
  final List<dynamic> states;
  final dynamic mainSelectOnChangedVal;
  final dynamic subSelectOnChangedVal;

  const SelectBoxContainerField({
    super.key,
    required this.countryName,
    required this.stateName,
    required this.countries,
    required this.states,
    required this.mainSelectOnChangedVal,
    required this.subSelectOnChangedVal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 선택 대분류
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width / 3,
            child: FormHelper.dropDownWidget(
                context,
                "나라 선택",
                countryName,
                countries,
                (onChangedVal) => mainSelectOnChangedVal(onChangedVal),
                (onValidateVal) {
              if (onValidateVal == null) {
                return '나라를 선택하세요.';
              }
              return null;
            },
                optionValue: 'name',
                optionLabel: 'name',
                borderColor: Colors.grey,
                borderFocusColor: Colors.red,
                borderRadius: 10,
                paddingLeft: 0,
                paddingRight: 0,
                contentPadding: 12),
          ),

          // 선택 소분류
          Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width / 3,
              child: FormHelper.dropDownWidget(
                context,
                '지역 선택',
                stateName,
                states,
                (onChangedVal) => subSelectOnChangedVal(onChangedVal),
                (onValidate) {
                  return null;
                },
                optionValue: 'locationName',
                optionLabel: 'locationName',
                borderColor: Colors.grey,
                borderFocusColor: Colors.red,
                borderRadius: 10,
                paddingLeft: 0,
                paddingRight: 0,
                contentPadding: 12,
              ))
        ]);
  }
}
