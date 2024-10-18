import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class SelectBoxContainerField extends StatelessWidget {
  // 변수
  final List<dynamic> states;
  final dynamic countryId;
  final dynamic stateName;
  final List<dynamic> countries;
  final dynamic mainSelectOnChangedVal;
  final dynamic subSelectOnChangedVal;

  const SelectBoxContainerField({
    super.key,
    required this.states,
    required this.countryId,
    required this.stateName,
    required this.countries,
    required this.mainSelectOnChangedVal,
    required this.subSelectOnChangedVal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 선택 대분류
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: FormHelper.dropDownWidget(
              context,
              "나라 선택",
              countryId,
              countries,
              (onChangedVal) => mainSelectOnChangedVal(onChangedVal),
              (onValidateVal) {
                if (onValidateVal == null) {
                  return '나라를 선택하세요.';
                }
                return null;
              },
              borderColor: Colors.black,
              borderFocusColor: Colors.redAccent,
              borderRadius: 10,
            ),
          ),

          // 선택 소분류
          SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: FormHelper.dropDownWidget(
                context,
                '지역 선택',
                stateName,
                states,
                (onChangedVal) => subSelectOnChangedVal(onChangedVal),
                (onValidate) {
                  return null;
                },
                borderColor: Colors.black,
                borderFocusColor: Colors.redAccent,
                borderRadius: 10,
                optionValue: 'locationName',
                optionLabel: 'locationName',
              ))
        ]);
  }
}
