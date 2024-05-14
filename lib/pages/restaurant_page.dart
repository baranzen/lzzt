import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/models/products_model.dart';
import 'package:lzzt/providers/app_provider.dart';
import 'package:lzzt/services/firebase.dart';

// ignore: must_be_immutable
class RestaurantPage extends StatelessWidget {
  Map<String, dynamic> data;
  RestaurantPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(
              size: 30,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black,
                  offset: Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ],
            pinned: true,
            expandedHeight: 300,
            floating: true,
            centerTitle: true,
            backgroundColor: AppHelper.appColor1,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 10),
              title: Text(
                data['userName'],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: data['userPhotoUrl'],
                child: Image.network(
                  data['userPhotoUrl'],
                  fit: BoxFit.cover,
                  frameBuilder: (BuildContext context, Widget child, int? frame,
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
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          FutureBuilder(
            future: FireBase.getProducts(data['uid']),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const SliverToBoxAdapter(
                    child: Text('none'),
                  );
                case ConnectionState.waiting:
                  return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()));
                case ConnectionState.active:
                  return const Text('active');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return const Text('error');
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text('Ürün yok...'),
                        ),
                      );
                    } else {
                      return SliverList.builder(
                        itemBuilder: (context, index) {
                          Products product = snapshot.data![index];
                          return ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 150,
                            ),
                            child: Stack(
                              children: [
                                Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              product.productDescription
                                                  .toString(),
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
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.easeOut,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 15,
                                  child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: Consumer(
                                      builder: (context, ref, child) {
                                        return IconButton.filled(
                                          padding: EdgeInsets.zero,
                                          iconSize: 20,
                                          alignment: Alignment.center,
                                          onPressed: () {
                                            ref
                                                .read(basketNotifierProvider
                                                    .notifier)
                                                .addToBasket(product, context);
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data!.length,
                      );
                    }
                  }
              }
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer(
        builder: (context, ref, child) => ref
                .watch(basketNotifierProvider)
                .isNotEmpty
            ? FloatingActionButton.extended(
                isExtended: true,
                extendedPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15,
                ),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/userBasketPage', (route) => false),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.red,
                      child: Text(
                        ref.watch(basketNotifierProvider).length.toString(),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Text(
                      'Sepete Git',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            wordSpacing: 1,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(width: 30),
                    Text(
                      '${ref.watch(basketNotifierProvider.notifier).getBasketTotalPrice()} TL',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
