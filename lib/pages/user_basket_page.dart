import 'package:flutter/material.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';
import 'package:lzzt/widgets/bottom_bar_widget.dart';

class UserBasketPage extends StatelessWidget {
  const UserBasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: const Center(
        child: Text('Sepetim'),
      ),
      bottomNavigationBar: BottomBarWidget(
        currentIndex: 2,
      ),
    );
  }
}
