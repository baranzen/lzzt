import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';
import 'package:lzzt/widgets/bottom_bar_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  Map mutfakdata = {
    'Burger':
        'https://static.vecteezy.com/system/resources/previews/024/280/420/non_2x/hot-and-fresh-tasty-delicious-grilled-hamburger-ai-generated-png.png',
    'Döner': 'https://pngimg.com/uploads/kebab/kebab_PNG45.png',
    'Pizza':
        'https://pngfre.com/wp-content/uploads/pizza-png-from-pngfre-3.png',
    'Burger2':
        'https://static.vecteezy.com/system/resources/previews/024/280/420/non_2x/hot-and-fresh-tasty-delicious-grilled-hamburger-ai-generated-png.png',
    'Döner2': 'https://pngimg.com/uploads/kebab/kebab_PNG45.png',
    'Pizza2':
        'https://pngfre.com/wp-content/uploads/pizza-png-from-pngfre-3.png',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //!Mutfaklar
                MutfakWidget(mutfakdata: mutfakdata),
                //!Restoranlar
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Restoranlar',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Hepsini Gör',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppHelper.appColor1,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder(
                      future: FireBase.getRestaurants(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const Text('none');
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                            return const Text('active');
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return const Text('error');
                            } else {
                              return ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 250,
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var data = snapshot.data![index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: HexColor("F3F5F7"),
                                        ),
                                      ),
                                      width: 300,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/restaurantPage',
                                              arguments: data);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //! restaurant image
                                            Expanded(
                                              child: Hero(
                                                tag: data['userPhotoUrl'],
                                                child: Image.network(
                                                  semanticLabel:
                                                      data['userName'],
                                                  data['userPhotoUrl'],
                                                  fit: BoxFit.fitWidth,
                                                  width: 300,
                                                  frameBuilder: (context,
                                                          child,
                                                          frame,
                                                          wasSynchronouslyLoaded) =>
                                                      wasSynchronouslyLoaded
                                                          ? child
                                                          : AnimatedOpacity(
                                                              opacity:
                                                                  frame == null
                                                                      ? 0
                                                                      : 1,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                              curve: Curves
                                                                  .easeOut,
                                                              child: child,
                                                            ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),

                                            //! restaurant informations
                                            RestaurantWidget(data: data),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBarWidget(currentIndex: 0),
    );
  }
}

class RestaurantWidget extends StatelessWidget {
  const RestaurantWidget({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data['userName'],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppHelper.appColor1,
                  ),
                  FutureBuilder(
                    future: FireBase.getRatingRestaurants(data['uid']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Text(
                            '0.0',
                            style: Theme.of(context).textTheme.bodyLarge,
                          );
                        }
                        double rating =
                            double.parse(snapshot.data!.toStringAsFixed(1));
                        return Text(
                          rating.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                      } else {
                        return Text(
                          '0.0',
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  FutureBuilder(
                    future: FireBase.getReviews(data['uid']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Text(
                            '(0)',
                            style: Theme.of(context).textTheme.bodyLarge,
                          );
                        }
                        return Text(
                          '(${snapshot.data!.length.toString()})',
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                      } else {
                        return Text(
                          '(0)',
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text('210TL minimum sipariş'),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.timelapse,
                color: AppHelper.appColor1,
              ),
              const SizedBox(width: 5),
              Text(
                '30-40 dk',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MutfakWidget extends StatelessWidget {
  const MutfakWidget({
    super.key,
    required this.mutfakdata,
  });

  final Map mutfakdata;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Mutfaklar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            mutfakdata.isNotEmpty && mutfakdata.length > 1
                ? Text(
                    'Hepsini Gör',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppHelper.appColor1,
                        ),
                  )
                : Container(),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 91,
          child: ListView.builder(
            physics: const ScrollPhysics(),
            itemCount: mutfakdata.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("F3F5F7"),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Image.network(
                      mutfakdata.entries.elementAt(index).value,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) =>
                              wasSynchronouslyLoaded
                                  ? child
                                  : AnimatedOpacity(
                                      opacity: frame == null ? 0 : 1,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeOut,
                                      child: child,
                                    ),
                    ),
                  ),
                  Text(mutfakdata.entries.elementAt(index).key),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
