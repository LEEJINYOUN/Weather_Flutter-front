import 'package:flutter/material.dart';
import 'package:weather_flutter_front/utilities/env_constant.dart';
import 'package:weather_flutter_front/widgets/card/bookmark_card.dart';

class BookmarkContainerField extends StatelessWidget {
  // 변수
  final bool isBookmarkList;
  final dynamic bookmarks;
  final dynamic changeKrToEn;

  const BookmarkContainerField({
    super.key,
    required this.isBookmarkList,
    required this.bookmarks,
    required this.changeKrToEn,
  });

  @override
  Widget build(BuildContext context) {
    // cdn 주소
    var imagesUrl = EnvConstant().imageFrontUrl();

    return Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: isBookmarkList
            ?
            // 즐겨찾기 리스트
            BookmarkCard(
                bookmarks: bookmarks,
                changeKrToEn: changeKrToEn,
                imagesUrl: imagesUrl)
            : null);
  }
}
