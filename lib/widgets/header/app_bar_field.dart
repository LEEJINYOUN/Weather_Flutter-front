import 'package:flutter/material.dart';
import 'package:weather_flutter_front/screens/login_screen.dart';
import 'package:weather_flutter_front/services/authentication.dart';

class AppBarField extends StatelessWidget implements PreferredSizeWidget {
  // 변수
  final String title;
  final bool isActions;

  const AppBarField({
    super.key,
    required this.title,
    required this.isActions,
  });

  @override
  Widget build(BuildContext context) {
    // 로그아웃 기능
    void logout() async {
      try {
        dynamic result = await AuthMethod().logout();

        if (result['statusCode'] == 201) {
          debugPrint(result['message'] as dynamic);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } else {
          debugPrint('오류 발생!' as dynamic);
        }
      } catch (e) {
        debugPrint(e as dynamic);
      }
    }

    return AppBar(
      toolbarHeight: 60,
      titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
      centerTitle: true,
      elevation: 5,
      automaticallyImplyLeading: false,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      actions: isActions == true
          ? <Widget>[
              IconButton(onPressed: logout, icon: const Icon(Icons.exit_to_app))
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
