import 'package:flutter/material.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('Admin Page'),
      ),
    );
  }
}
