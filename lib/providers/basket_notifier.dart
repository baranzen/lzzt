import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/services/hive_services.dart';

class BasketNotifier extends StateNotifier<int> {
  BasketNotifier() : super(HiveServices.getBasket().length);

  Future<void> addToBasket(String productID) async {
    //gelen her productID yi basket a ekler
    await HiveServices.addBasket(productID);
    state = HiveServices.getBasket().length;
  }
}
