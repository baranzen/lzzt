import 'package:flutter/material.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';
import 'package:lzzt/widgets/bottom_bar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(child: Text('Homepage')),
      bottomNavigationBar: BottomBarWidget(),
    );
  }
}
