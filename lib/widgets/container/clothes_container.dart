import 'package:flutter/material.dart';
import 'package:weather_flutter_front/models/clothes_model.dart';
import 'package:weather_flutter_front/utils/constant.dart';

class ClothesContainer extends StatelessWidget {
  final List<ClothesModel> clothes;

  const ClothesContainer({
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
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: const Text(
                '- 오늘의 옷 추천 -',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            // 옷 리스트 박스
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  itemCount: clothes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          top: 5, left: 15, right: 15, bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 5,
                              offset: const Offset(0, 1),
                            )
                          ]),
                      alignment: Alignment.center,
                      width: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.network(
                                '${EnvData().iconsUrl()}/clothes/${clothes[index].image}'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            clothes[index].name,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}
