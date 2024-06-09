import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/models/products_model.dart';
import 'package:lzzt/providers/app_provider.dart';
import 'package:lzzt/services/firebase.dart';

class RestaurantPage extends StatefulWidget {
  final Map<String, dynamic> data;

  RestaurantPage({super.key, required this.data});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List reviews = [];
  late double rating = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FireBase.getReviews(widget.data['uid']).then((value) {
        setState(() {
          reviews = value;
        });
      });
      FireBase.getRatingRestaurants(widget.data['uid']).then((value) {
        setState(() {
          rating = value;
          rating = double.parse(rating.toStringAsFixed(1));
        });
      });
    });

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppHelper.appColor1,
            iconTheme: const IconThemeData(color: Colors.white),
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.data['userName'],
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    const Shadow(
                      color: Colors.black,
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
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
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                dividerColor: AppHelper.appColor2,
                indicatorColor: AppHelper.appColor1,
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      'Menü',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Hakkında',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Yorumlar',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                ],
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
                //! hakkında
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Restoran Görseli

                    // Restoran Adı ve Puanı
                    const Text(
                      'Restoran 1',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppHelper.appColor1,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.star,
                                color: Colors.white,
                                size: 23,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppHelper.appColor1,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.comments,
                                color: Colors.white,
                                size: 23,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${reviews.length.toString()} +',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Teslimat, Servis, Lezzet Puanları
                    Text(
                      'Teslimat: 4.4\nServis: 4.3\nLezzet: 4.1',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Ödeme Yöntemleri
                    const Text(
                      'Ödeme Yöntemleri:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PaymentMethods(),
                    const SizedBox(height: 16),
                    // Çalışma Saatleri, Minimum Tutar, Teslimat Süresi
                    Text(
                      'Çalışma Saatleri: 11:15 - 02:00\nMin Tutar: 100 TL\nTeslimat Süresi: 30-40dk',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Lorem Ipsum Metni
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
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
                          padding: const EdgeInsets.all(0),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var reviewDate =
                                snapshot.data![index]['reviewDate'];
                            var formattedDate;

                            if (reviewDate is Timestamp) {
                              formattedDate =
                                  DateFormat('dd MMM yyyy, HH:mm', 'tr')
                                      .format(reviewDate.toDate().toLocal());
                            } else if (reviewDate is String) {
                              formattedDate = DateFormat(
                                      'dd MMM yyyy, HH:mm', 'tr')
                                  .format(DateTime.parse(reviewDate).toLocal());
                            } else {
                              // Handle other types or throw an error
                              formattedDate = '';
                            }

                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: HexColor("F3F5F7"),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                title: Text(
                                  snapshot.data![index]['userName'] ?? '',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index]['review'] ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    )
                                  ],
                                ),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    snapshot.data![index]['userPhotoUrl'],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        snapshot.data![index]['rating']
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            )),
                                    Icon(Icons.star,
                                        color: AppHelper.appColor1),
                                  ],
                                ),
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
                      'Sepetim',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class PaymentMethods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            PaymentMethodIcon(Icons.credit_card, 'Banka & Kredi Kartı'),
            PaymentMethodIcon(
                Icons.restaurant_menu, 'Edenred Ticket Restaurant'),
          ],
        ),
        Row(
          children: [
            PaymentMethodIcon(Icons.credit_card, 'Multinet'),
            PaymentMethodIcon(Icons.restaurant_menu, 'Pluxee (Sodexo)'),
          ],
        ),
      ],
    );
  }
}

class PaymentMethodIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  PaymentMethodIcon(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 36, color: Colors.green),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
