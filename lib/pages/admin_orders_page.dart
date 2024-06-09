import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: FutureBuilder(
          future: FireBase.getRestaurantOrders(
            FirebaseAuth.instance.currentUser!.uid,
          ),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            debugPrint('snapshot: $snapshot');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Hata oluştu!'),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Sipariş yok!'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var order = snapshot.data![index];
                var userPhotoUrl = order['userPhotoUrl'];
                var userName = order['userName'];
                var userAddress = order['userAddress'];
                var productTotalPrice = order['productTotalPrice'].toString();
                var orderStatus = order['orderStatus'];
                var productImageUrl =
                    order['orderProducts'][0]['productImageURL'];
                var productName = order['orderProducts'][0]['productName'];
                var orderDate = (order['orderDate'] as Timestamp).toDate();
                var formattedDate =
                    DateFormat('dd.MM.yyyy HH:mm').format(orderDate);
                var userPhone = order['userPhone'];

                return Card(
                  shadowColor: AppHelper.appColor2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(userPhotoUrl),
                              radius: 25,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '₺${productTotalPrice}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: order['orderProducts'].length,
                          itemBuilder: (context, index) {
                            var product = order['orderProducts'][index];
                            return Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Image.network(
                                    product['productImageURL'],
                                    height: 55,
                                    width: 55,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    product['productName'],
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Divider(color: AppHelper.appColor2),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.locationDot,
                              color: AppHelper.appColor1,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                userAddress,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors
                                      .grey[600], // Adres rengini gri yaptım
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.phone,
                              color: AppHelper.appColor1,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              userPhone.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors
                                    .grey[600], // Telefon rengini gri yaptım
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
