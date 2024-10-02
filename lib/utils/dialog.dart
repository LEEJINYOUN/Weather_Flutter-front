import 'package:flutter/material.dart';
import 'package:weather_flutter_front/widgets/button/green_button.dart';
import 'package:weather_flutter_front/widgets/button/red_button.dart';

class DialogType {
  // 성공 알림창 모달
  Future<void> successDialog(
    BuildContext context, {
    required String titleText,
    required String contentText,
    required dynamic successOk,
    required String actionText,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              titleText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            )),
            content: Text(
              contentText,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            actions: [
              GreenButton(onTap: successOk, text: actionText),
            ],
          );
        });
  }

  // 실패 알림창 모달
  Future<void> failDialog(
    BuildContext context, {
    required String titleText,
    required String contentText,
    required dynamic failOk,
    required String actionText,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              titleText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            )),
            content: Text(
              contentText,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            actions: [
              RedButton(onTap: failOk, text: actionText),
            ],
          );
        });
  }
}
