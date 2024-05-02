import 'package:flutter/material.dart';
import 'package:lzzt/constans/app_helper.dart';

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
            pinned: true,
            backgroundColor: AppHelper.appColor1,
            expandedHeight: 300,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.all(0),
              title: Text(
                data['userName'],
                style: const TextStyle(color: Colors.white, shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ]),
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
        ],
      ),
    );
  }
}
