import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    List<Products> updatedBasketList = await HiveServices.getBasket();

    //ayni restoran olup olmamasini kontrol et
    if (updatedBasketList.isNotEmpty) {
      if (updatedBasketList[0].productOwner != product.productOwner) {
        snackBarMessage(context, 'Farklı restorandan ürün ekleyemezsiniz');
        return;
      }
    }

    //ayni urun eklenip eklenmedigini kontrol et
    if (updatedBasketList.contains(product)) {
      snackBarMessage(context, 'Ürün zaten sepetinizde var');
      return;
    }

    updatedBasketList.add(product);
    state = updatedBasketList;
    // Sepete ekleyin
    await HiveServices.addBasket(product, context);
    debugPrint('Ürün sepete eklendi');
    snackBarMessage(context, 'Ürün sepetinize eklendi');
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
