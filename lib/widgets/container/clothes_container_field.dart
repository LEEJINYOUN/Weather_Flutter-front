import 'package:flutter/material.dart';
import 'package:weather_flutter_front/models/clothes_model.dart';
import 'package:weather_flutter_front/widgets/card/clothes_card.dart';

class ClothesContainerField extends StatelessWidget {
  // 변수
  final List<ClothesModel> clothes;

  const ClothesContainerField({
    super.key,
    required this.clothes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(top: 30, bottom: 20),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // 옷 타이틀
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: const Text(
                '- 오늘의 옷 추천 -',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),

            // 옷 리스트
            ClothesCard(clothes: clothes)
          ],
        ));
  }
}
