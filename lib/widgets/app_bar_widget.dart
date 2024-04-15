import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/providers/app_provider.dart';
import 'package:lzzt/services/firebase.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        const Spacer(),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Image.asset('assets/logo.png', width: 200, height: 200),
          ),
        ),
        Expanded(
          child: Align(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(
                  child: IsDarkIcon(),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.person_rounded),
                    onPressed: () => FireBase.appBarProfileCheck(context),
                  ),
                ),
              ],
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
          ? const Icon(Icons.light_mode, color: Colors.yellow)
          : const Icon(Icons.dark_mode),
      onPressed: ref.read(isDarkNotifierProvider.notifier).changeTheme,
    );
  }
}
