import 'package:flutter/material.dart';

class BookmarkCard extends StatelessWidget {
  // 변수
  final dynamic bookmarks;
  final dynamic changeKrToEn;
  final String imagesUrl;
  final dynamic textColor;

  const BookmarkCard({
    super.key,
    required this.bookmarks,
    required this.changeKrToEn,
    required this.imagesUrl,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        itemCount: bookmarks.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () => changeKrToEn({
                    'location_kr': '${bookmarks[index]['location_kr']}',
                    'location_en': '${bookmarks[index]['location_en']}',
                    'image_number': '${bookmarks[index]['image_number']}',
                  }),
              child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('$imagesUrl/images/bg-image.jpg')),
                  ),
                  child: Center(
                      child: Text(
                    '${bookmarks[index]['location_kr']}',
                    style: TextStyle(
                        color: textColor(bookmarks[index]['image_number']),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ))));
        });
  }
}
