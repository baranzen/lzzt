import 'package:flutter/material.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';
import 'package:lzzt/widgets/bottom_bar_widget.dart';

class UserOrdersPage extends StatelessWidget {
  const UserOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('User Orders Page'),
      ),
      appBar: const AppBarWidget(),
      bottomNavigationBar: BottomBarWidget(
        currentIndex: 1,
      ),
    );
  }
}
