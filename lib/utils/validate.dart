import 'package:flutter/material.dart';

class CheckValidate {
  // 유효성 체크 확인
  String? formCheckValidate(GlobalKey<FormState> formField) {
    String message = '유효성 체크 실패! 다시 확인하세요.';
    if (formField.currentState!.validate()) {
      return null;
    } else {
      return message;
    }
  }

  // email 형식 체크
  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '잘못된 이메일 형식입니다.';
      } else {
        return null;
      }
    }
  }

  // name 형식 체크
  String? validateName(FocusNode focusNode, String value) {
    String pattern = r'[!@#$%^&*(),.?":{}|<>]';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이름을 입력하세요.';
    } else if (regExp.hasMatch(value)) {
      focusNode.requestFocus();
      return '특수문자는 이름에 포함할 수 없습니다.';
    } else {
      return null;
    }
  }

  // password 형식 체크
  String? validatePassword(FocusNode focusNode, String value) {
    String pattern =
        r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else if (value.length < 8) {
      return '비밀번호는 8자리 이상이어야 합니다.';
    } else if (!regExp.hasMatch(value)) {
      focusNode.requestFocus();
      return '특수문자, 문자, 숫자를 포함한 8자 이상 입력하세요.';
    } else {
      return null;
    }
  }
}
