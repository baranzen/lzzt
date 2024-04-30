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

  static bool isAdmin() {
    var box = Hive.box('lzzt');
    debugPrint('isAdmin: ${box.get('isAdmin') ?? false} read from Hive');
    return box.get('isAdmin') ?? false;
  }

  static Future<void> setAdmin(bool value) async {
    var box = Hive.box('lzzt');
    await box.put('isAdmin', value);
    debugPrint('isAdmin: $value set in Hive');
  }

  static Future<void> addBasket(productID) async {
    var box = Hive.box('lzzt');
    var basket = box.get('basket') ?? [];
    if (!basket.contains(productID)) {
      basket.add(productID);
    }
    box.put('basket', basket);
    debugPrint(box.get('basket').toString());
  }

  static getBasket() {
    var box = Hive.box('lzzt');
    debugPrint('Basket: ${box.get('basket')} read from Hive');
    return box.get('basket') ?? [];
  }
}
