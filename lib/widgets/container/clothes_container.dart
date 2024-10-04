import 'package:flutter/material.dart';

class ClothesContainer extends StatelessWidget {
  const ClothesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> clothesArr = [
      {
        "name": "털모자",
        "url": "assets/images/clothes/털모자.jpg",
      },
      {
        "name": "코트",
        "url": "assets/images/clothes/코트.jpg",
      },
      {
        "name": "구두",
        "url": "assets/images/clothes/구두.jpg",
      },
      {
        "name": "하이힐",
        "url": "assets/images/clothes/하이힐.jpg",
      },
    ];

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
                  itemCount: clothesArr.length,
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
                          Image.asset(
                            '${clothesArr[index]["url"]}',
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${clothesArr[index]["name"]}',
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
