import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/models/products_model.dart';
import 'package:lzzt/providers/app_provider.dart';
import 'package:lzzt/services/firebase.dart';

class RestaurantPage extends StatefulWidget {
  Map<String, dynamic> data;

  RestaurantPage({super.key, required this.data});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // length: 2 olarak güncellendi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            bottom: TabBar(
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'Ürünler',
                ),
                Tab(
                  text: 'Yorumlar',
                ),
              ],
            ),
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
            expandedHeight: 200,
            floating: true,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 10),
              background: Hero(
                tag: widget.data['userPhotoUrl'],
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.data['userPhotoUrl']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                FutureBuilder<List<Products>>(
                  future: FireBase.getProducts(widget.data['uid']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('An error occurred.'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Ürün yok...'));
                    }

                    return CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color:
                                                            HexColor('#333333'),
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                          const SizedBox(width: 10),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              product.productImageURL,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              frameBuilder: (BuildContext
                                                      context,
                                                  Widget child,
                                                  int? frame,
                                                  bool wasSynchronouslyLoaded) {
                                                if (wasSynchronouslyLoaded) {
                                                  return child;
                                                }
                                                return AnimatedOpacity(
                                                  child: child,
                                                  opacity:
                                                      frame == null ? 0 : 1,
                                                  duration: const Duration(
                                                      seconds: 1),
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
                                                    .addToBasket(
                                                        product, context);
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
                            childCount: snapshot.data!.length,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                //! yorumlar
                Center(
                  child: FutureBuilder(
                    future: FireBase.getReviews(widget.data['uid']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('hata');
                      } else if (!snapshot.hasData) {
                        return const Text('Yorum yok...');
                      }

                      if (snapshot.data!.isEmpty) {
                        return const Text('Yorum yok...');
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text(snapshot.data![index]['userName'] ?? ''),
                              subtitle:
                                  Text(snapshot.data![index]['review'] ?? ''),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  snapshot.data![index]['userPhotoUrl'],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(snapshot.data![index]['rating']
                                      .toString()),
                                  Icon(Icons.star, color: AppHelper.appColor1),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
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
