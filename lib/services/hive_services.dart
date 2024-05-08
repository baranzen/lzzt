import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lzzt/models/products_model.dart';

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

//! basket
  static Future<void> addBasket(Products products) async {
    var box = await Hive.openBox<Products>('basket');
    String productID = products.productID;

    if (box.containsKey(productID)) {
      debugPrint('Product already in basket');
      return;
    } else {
      box.put(productID, products);
      debugPrint('Product added to basket');
    }
    box.toMap().forEach((key, value) {
      debugPrint('Product: $key, ${value.productName}');
    });
  }

  static Future<List<Products>> getBasket() async {
    var box = await Hive.openBox<Products>('basket');
    var products = box.values.toList();
    return products;
  }

  static removeBasketProduct(Products products) async {
    var box = await Hive.openBox<Products>('basket');
    box.delete(products.productID);
  }

  static Future<void> cleanBasket() async {
    var box = await Hive.openBox<Products>('basket');
    await box.clear();
  }
}
