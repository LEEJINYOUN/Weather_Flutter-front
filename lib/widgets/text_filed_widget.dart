import 'package:flutter/material.dart';

class TextFiledWidget extends StatefulWidget {
  const TextFiledWidget({super.key});

  @override
  State<TextFiledWidget> createState() => _TextFiledWidgetState();
}

class _TextFiledWidgetState extends State<TextFiledWidget> {
  final focusNode = FocusNode();
  final layerLink = LayerLink();
  final TextEditingController searchController = TextEditingController();
  OverlayEntry? entry;

  // state 진입시 함수 실행
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
      builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 8),
            child: buildOverlay(),
          )),
    );

    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  // 컨트롤러 객체 제거 시 메모리 해제
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildOverlay() => Material(
      elevation: 8,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Image.network(
              'https://picsum.photos/200',
              fit: BoxFit.cover,
            ),
            title: const Text('1번 제목'),
            subtitle: const Text('1번 설명'),
            onTap: () {
              searchController.text = '1번';

              hideOverlay();
              focusNode.unfocus();
            },
          ),
          ListTile(
            leading: Image.network(
              'https://picsum.photos/200',
              fit: BoxFit.cover,
            ),
            title: const Text('2번 제목'),
            subtitle: const Text('2번 설명'),
            onTap: () {
              searchController.text = '2번';

              hideOverlay();
              focusNode.unfocus();
            },
          ),
          ListTile(
            leading: Image.network(
              'https://picsum.photos/200',
              fit: BoxFit.cover,
            ),
            title: const Text('3번 제목'),
            subtitle: const Text('4번 설명'),
            onTap: () {
              searchController.text = '3번';

              hideOverlay();
              focusNode.unfocus();
            },
          )
        ],
      ));

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: layerLink,
        child: TextField(
          focusNode: focusNode,
          controller: searchController,
          decoration: InputDecoration(
              label: const Text('이름'),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
      );
}
