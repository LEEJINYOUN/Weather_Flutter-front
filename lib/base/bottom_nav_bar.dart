import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:weather_flutter_front/screens/home_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // BottomNavBarContainer 불러오기
    return const MaterialApp(home: BottomNavBarContainer());
  }
}

class BottomNavBarContainer extends StatefulWidget {
  const BottomNavBarContainer({super.key});

  @override
  // _BottomNavBarState 불러오기 => state 생성 후 반환
  State<BottomNavBarContainer> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBarContainer> {
  // 하단 메뉴 리스트
  final appScreens = [
    const HomeScreen(), // 홈 스크린
    const Center(child: Text('Bookmark')),
    const Center(child: Text('Profile')),
  ];

  // 선택 인덱스 초기화
  int _selectedIndex = 0;

  // 하단 메뉴 버튼 변경
  void _onItemTapped(int index) {
    // setState => 실시간으로 변경
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: appScreens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.blueGrey,
            unselectedItemColor: const Color(0xff526400),
            showSelectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
                  activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(FluentSystemIcons.ic_fluent_heart_regular),
                  activeIcon: Icon(FluentSystemIcons.ic_fluent_heart_filled),
                  label: 'Bookmark'),
              BottomNavigationBarItem(
                  icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
                  activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
                  label: 'Profile'),
            ]));
  }
}
