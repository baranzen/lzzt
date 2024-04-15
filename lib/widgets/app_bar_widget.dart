import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lzzt/providers/app_provider.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/services/hive_services.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        const SizedBox(width: 12),
        const Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: IsDarkIcon(),
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

class IsDarkIcon extends ConsumerWidget {
  const IsDarkIcon({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return IconButton(
      icon: ref.watch<bool>(isDarkNotifierProvider)
          ? const Icon(Icons.light_mode, color: Colors.white)
          : const Icon(Icons.dark_mode, color: Colors.black),
      onPressed: ref.read(isDarkNotifierProvider.notifier).changeTheme,
    );
  }
}
