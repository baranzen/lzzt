import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lzzt/providers/app_provider.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/widgets/alertWidget.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';
import 'package:lzzt/widgets/bottom_bar_widget.dart';

class UserBasketPage extends ConsumerWidget {
  const UserBasketPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Center(
        child: SafeArea(
          child: ref.watch(basketNotifierProvider).isNotEmpty
              ? Stack(
                  children: [
                    ListView.builder(
                      itemCount: ref.watch(basketNotifierProvider).length,
                      itemBuilder: (context, index) {
                        var product = ref.watch(basketNotifierProvider)[index];
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  ref
                                      .read(basketNotifierProvider.notifier)
                                      .removeProduct(product, context);
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 150,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: HexColor("F3F5F7"),
                                    width: 1,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productName,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: HexColor('#333333'),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          product.productDescription.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${product.productPrice.toString()} TL',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      product.productImageURL,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      frameBuilder: (BuildContext context,
                                          Widget child,
                                          int? frame,
                                          bool wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        }
                                        return AnimatedOpacity(
                                          child: child,
                                          opacity: frame == null ? 0 : 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeOut,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: HexColor("F3F5F9"),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Toplam',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                  ),
                                  Text(
                                    '${ref.watch(basketNotifierProvider.notifier).getBasketTotalPrice()} TL',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (FirebaseAuth.instance.currentUser ==
                                        null) {
                                      alertWidget(
                                        'Giris Yap',
                                        'Siparis verebilmek icin giris zorunlu',
                                        context,
                                        () => Navigator.popAndPushNamed(
                                            context, '/logInPage'),
                                      );
                                    } else {
                                      await FireBase.userOrderBasket(
                                        ref.read(basketNotifierProvider),
                                        context,
                                      ); /* .then(
                                        (value) => ref
                                            .read(
                                                basketNotifierProvider.notifier)
                                            .cleanBasket(context),
                                      ); */
                                    }
                                  },
                                  child: const Text(
                                    'Siparişi Tamamla',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text('Sepetinizde urun yok'),
                ),
        ),
      ),
      bottomNavigationBar: BottomBarWidget(
        currentIndex: 2,
      ),
    );
  }
}
