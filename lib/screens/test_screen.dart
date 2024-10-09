import 'package:flutter/material.dart';
import 'package:weather_flutter_front/models/book_model.dart';
import 'package:weather_flutter_front/widgets/header/app_bar_field.dart';
import 'package:weather_flutter_front/widgets/text_filed_widget.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // 입력 컨트롤러
  final TextEditingController searchController = TextEditingController();

  List<Book> books = allBooks;
  bool isOpen = false;

  void searchBook(String query) {
    final suggestions = allBooks.where((book) {
      final bookTitle = book.title.toLowerCase();
      final input = query.toLowerCase();
      return bookTitle.contains(input);
    }).toList();

    setState(() => books = suggestions);
  }

  void searchedBook(String text) {
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false, // 가상 키보드 오버플로우 제거
        appBar: const AppBarField(title: '테스트'),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            Container(
              height: 120,
              color: Colors.blue,
            ),
            Container(
              height: 120,
              color: Colors.red,
            ),
            Container(
              height: 120,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            const TextFiledWidget(),
            const SizedBox(height: 12),
            Container(
              height: 120,
              color: Colors.teal,
            ),
            Container(
              height: 120,
              color: Colors.cyan,
            ),
            Container(
              height: 120,
              color: Colors.blue,
            ),
            Container(
              height: 120,
              color: Colors.red,
            ),
            Container(
              height: 120,
              color: Colors.green,
            ),
          ],
        )
        // GestureDetector(
        //   onTap: () {
        //     FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
        //   },
        //   child: Column(
        //     children: <Widget>[
        //       Container(
        //         margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        //         child: TextField(
        //           textInputAction: TextInputAction.done,
        //           controller: searchController,
        //           decoration: InputDecoration(
        //               prefixIcon: GestureDetector(
        //                 onTap: () {
        //                   print('내용 검색!');
        //                   setState(() {
        //                     searchController.text = '';
        //                     books = allBooks;
        //                     isOpen = false;
        //                   });
        //                   FocusManager.instance.primaryFocus
        //                       ?.unfocus(); // 키보드 닫기 이벤트
        //                 },
        //                 child: const Icon(Icons.search),
        //               ),
        //               suffixIcon: GestureDetector(
        //                 onTap: () {
        //                   print('내용 초기화!');
        //                   setState(() {
        //                     searchController.text = '';
        //                     books = allBooks;
        //                     isOpen = false;
        //                   });
        //                   FocusManager.instance.primaryFocus
        //                       ?.unfocus(); // 키보드 닫기 이벤트
        //                 },
        //                 child: const Icon(Icons.close),
        //               ),
        //               hintText: '책 이름',
        //               border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(20),
        //                   borderSide: const BorderSide(color: Colors.blue))),
        //           onChanged: searchBook,
        //           onTap: () {
        //             print('키보드 켜기');
        //             setState(() {
        //               isOpen = true;
        //             });
        //           },
        //         ),
        //       ),
        //       isOpen == true
        //           ? Expanded(
        //               child: GestureDetector(
        //               onTap: () {
        //                 FocusManager.instance.primaryFocus
        //                     ?.unfocus(); // 키보드 닫기 이벤트
        //               },
        //               child: ListView.builder(
        //                 itemCount: books.length,
        //                 itemBuilder: (context, index) {
        //                   final book = books[index];

        //                   return GestureDetector(
        //                       onTap: () {
        //                         FocusManager.instance.primaryFocus
        //                             ?.unfocus(); // 키보드 닫기 이벤트
        //                         searchedBook(book.title);
        //                         setState(() {
        //                           searchController.text = '';
        //                           books = allBooks;
        //                           isOpen = false;
        //                         });
        //                       },
        //                       child: ListTile(
        //                         leading: Image.network(
        //                           book.urlImage,
        //                           fit: BoxFit.cover,
        //                           width: 50,
        //                           height: 50,
        //                         ),
        //                         title: Text(book.title),
        //                       ));
        //                 },
        //               ),
        //             ))
        //           : const Text('검색하세요.'),
        //       Container(
        //         margin: const EdgeInsets.all(15),
        //         padding: const EdgeInsets.all(15),
        //         height: 200,
        //         decoration: const BoxDecoration(color: Colors.blueGrey),
        //         child: const Center(
        //           child: Text('테스트중입니다.'),
        //         ),
        //       )
        //     ],
        //   ),
        // )
        );
  }
}
