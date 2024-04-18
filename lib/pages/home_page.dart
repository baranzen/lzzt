import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/providers/app_provider.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/services/hive_services.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';
import 'package:lzzt/widgets/bottom_bar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: FutureBuilderWidget()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBarWidget(),
    );
  }
}

class FutureBuilderWidget extends StatefulWidget {
  const FutureBuilderWidget({
    super.key,
  });

  @override
  State<FutureBuilderWidget> createState() => _FutureBuilderWidgetState();
}

class _FutureBuilderWidgetState extends State<FutureBuilderWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireBase.getProducts(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("None");
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Text("Error");
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                            '${snapshot.data![index].productName} · ${snapshot.data![index].productPrice}'),
                        leading: Image.network(
                            snapshot.data![index].productImageURL),
                        subtitle:
                            Text(snapshot.data![index].productDescription),
                        trailing: Consumer(
                          builder: (context, ref, child) {
                            return IconButton(
                              icon:
                                  const Icon(Icons.add_shopping_cart_outlined),
                              onPressed: () async {
                                await ref
                                    .read(basketNotifierProvider.notifier)
                                    .addToBasket(
                                        snapshot.data![index].productID);
                              },
                            );
                          },
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
            }
        }
      },
    );
  }
}
