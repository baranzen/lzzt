import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';
import 'package:lzzt/widgets/bottom_bar_widget.dart';

class UserOrdersPage extends StatelessWidget {
  const UserOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: FirebaseAuth.instance.currentUser?.uid != null
            ? Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: FireBase.getUserOrders(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const Text('none');
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());
                          case ConnectionState.active:
                            return const Text('active');
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return const Text('error');
                            } else {
                              if (snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text('Siparişiniz bulunmamaktadır.'),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var order = snapshot.data![index];

                                    return FutureBuilder(
                                      future: FireBase.getRestaurantDetails(
                                          order['productOwner']),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                            return const Text('none');
                                          case ConnectionState.waiting:
                                            return Container();
                                          case ConnectionState.active:
                                            return const Text('active');
                                          case ConnectionState.done:
                                            if (snapshot.hasError) {
                                              return const Text('error');
                                            } else {
                                              var restaurant = snapshot.data!;

                                              //!format date
                                              var formattedDate = DateFormat(
                                                "dd.MM.yyyy HH:mm",
                                              ).format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      order['orderDate']
                                                              .seconds *
                                                          1000));

                                              return Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: HexColor("F3F5F7"),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                margin: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            //! restaurant name
                                                            Text(
                                                                restaurant[
                                                                    'userName'],
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleLarge!),
                                                            Text(formattedDate),
                                                            Text(
                                                                '${order['productTotalPrice'].toString()} TL'),
                                                            Text(
                                                              'Detaylar >',
                                                              style: TextStyle(
                                                                color: AppHelper
                                                                    .appColor1,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        //!restaurant image
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child: Image.network(
                                                            restaurant[
                                                                'userPhotoUrl'],
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.cover,
                                                            frameBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    int? frame,
                                                                    bool
                                                                        wasSynchronouslyLoaded) {
                                                              if (wasSynchronouslyLoaded) {
                                                                return child;
                                                              }
                                                              return AnimatedOpacity(
                                                                child: child,
                                                                opacity:
                                                                    frame ==
                                                                            null
                                                                        ? 0
                                                                        : 1,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                curve: Curves
                                                                    .easeOut,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: HexColor("F3F5F7"),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.check,
                                                              color: AppHelper
                                                                  .appColor1,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            const Text(
                                                                'Teslim Edildi'),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        //! reoder button
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: AppHelper
                                                                  .appColor1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            shape: BoxShape
                                                                .rectangle,
                                                          ),
                                                          child: TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          10),
                                                            ),
                                                            onPressed: () {},
                                                            child: const Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(
                                                                  Icons.refresh,
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  'Tekrarla',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    // print the order details with loop
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          order['orderProducts']
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var product = order[
                                                                'orderProducts']
                                                            [index];

                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                product[
                                                                    'productName'],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                        }
                                      },
                                    );
                                  },
                                );
                              }
                            }
                        }
                      },
                    ),
                  )
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Üye girişi yapınız.'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/logInPage');
                      },
                      child: const Text(
                        'Giriş Yap',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomBarWidget(
        currentIndex: 1,
      ),
    );
  }
}
