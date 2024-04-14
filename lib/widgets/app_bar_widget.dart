import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lzzt/services/firebase.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.white,
      backgroundColor: HexColor('#FFFFFF'),
      automaticallyImplyLeading: false,
      actions: [
        const SizedBox(width: 12),
        Spacer(),
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
