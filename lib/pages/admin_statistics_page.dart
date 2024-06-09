import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';

class AdminStatisticsPage extends StatelessWidget {
  const AdminStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: FutureBuilder(
          future: FireBase.getRestaurantStatistics(
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
                child: Text('Istatistik yok!'),
              );
            }

            var statistics = snapshot.data![0];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatisticCard(
                    icon: Icons.shopping_cart,
                    title: 'Toplam Siparişler',
                    value: statistics['totalOrders'].toString(),
                  ),
                  _buildStatisticCard(
                    icon: Icons.attach_money,
                    title: 'Toplam Gelir',
                    value: '${statistics['totalIncome']}₺',
                  ),
                  _buildStatisticCard(
                    icon: Icons.fastfood,
                    title: 'Toplam Ürünler',
                    value: statistics['totalProducts'].toString(),
                  ),
                  _buildStatisticCard(
                    icon: Icons.star,
                    title: 'Toplam Puan',
                    value: statistics['totalRatings'].toString(),
                  ),
                  _buildStatisticCard(
                    icon: Icons.rate_review,
                    title: 'Toplam Yorumlar',
                    value: statistics['totalReviews'].toString(),
                  ),
                  _buildStatisticCard(
                    icon: Icons.favorite,
                    title: 'En Çok Tercih Edilen Ürün',
                    value: statistics['topProductName'],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatisticCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      shadowColor: AppHelper.appColor2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppHelper.appColor1,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
