import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lzzt/models/products_model.dart';
import 'package:lzzt/services/hive_services.dart';
import 'package:lzzt/widgets/snackbar_message.dart';

class BasketNotifier extends StateNotifier<List<Products>> {
  BasketNotifier() : super([]) {
    initialize();
  }

  Future<void> initialize() async {
    // Sepet ürün listesini başlatın
    List<Products> basketList = await HiveServices.getBasket();
    state = basketList;
  }

  Future<void> addToBasket(Products product, context) async {
    // Ürünü sepete ekleyin
    // ayni restoranda olup olmadığını kontrol edin
    List<Products> updatedBasketList = await HiveServices.getBasket();
    if (updatedBasketList.isNotEmpty) {
      if (updatedBasketList[0].productOwner != product.productOwner) {
        snackBarMessage(context, 'Farklı restorandan ürün ekleyemezsiniz');
        return;
      }
      await HiveServices.addBasket(product);
      // Sepeti güncelleyin
      snackBarMessage(context, 'Ürün sepete eklendi');
      state = updatedBasketList;
    }
  }

  getBasket() {
    return state;
  }

  double getBasketTotalPrice() {
    double totalPrice = 0;
    state.forEach((element) {
      totalPrice += element.productPrice;
    });
    return totalPrice;
  }

  removeProduct(Products product, context) async {
    // Ürünü sepetten kaldırın
    HiveServices.removeBasketProduct(product);
    // Sepeti güncelleyin
    List<Products> updatedBasketList = await HiveServices.getBasket();
    state = updatedBasketList;
    debugPrint('Sepetten kaldırıldı');
    snackBarMessage(context, 'Ürün sepetten kaldırıldı');
  }

  cleanBasket(context) async {
    // Sepeti temizleyin
    await HiveServices.cleanBasket();
    // Sepeti güncelleyin
    List<Products> updatedBasketList = await HiveServices.getBasket();
    state = updatedBasketList;
  }
}
