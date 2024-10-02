import 'package:flutter/material.dart';

class AppBarField extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarField({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
      centerTitle: true,
      elevation: 5,
      automaticallyImplyLeading: false,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
