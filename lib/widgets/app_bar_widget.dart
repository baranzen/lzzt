import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lzzt/services/firebase.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        const SizedBox(width: 12),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.wb_sunny, color: Colors.yellow.shade700),
              onPressed: () {},
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Image.asset('assets/logo.png', width: 200, height: 200),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.person_rounded),
              onPressed: () => FireBase.appBarProfileCheck(context),
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
