import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/services/hive_services.dart';

class IsDarkNotifier extends StateNotifier<bool> {
  IsDarkNotifier() : super(HiveServices.isDark());

  void changeTheme() {
    state = !state;
    HiveServices.setDark(state);
    debugPrint('Dark mode: $state set in IsDarkNotifier');
  }
}
