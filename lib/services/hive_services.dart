import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveServices {
  static bool isDark() {
    var box = Hive.box('lzzt');
    // debugPrint('Dark mode: ${box.get('isDark') ?? false} read from Hive');
    return box.get('isDark') ?? false;
  }

  static void setDark(bool value) {
    var box = Hive.box('lzzt');
    box.put('isDark', value);
    debugPrint('Dark mode: $value set in Hive');
  }

  static isAdmin() {
    var box = Hive.box('lzzt');
    debugPrint('isAdmin: ${box.get('isAdmin') ?? false} read from Hive');
    return box.get('isAdmin') ?? false;
  }

  static void setAdmin(bool value) {
    var box = Hive.box('lzzt');
    box.put('isAdmin', value);
    debugPrint('isAdmin: $value set in Hive');
  }
}
