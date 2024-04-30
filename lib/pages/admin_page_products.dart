import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';

class AdminPageProducts extends StatelessWidget {
  const AdminPageProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              ListViewWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({
    super.key,
  });

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: FireBase.getAdminsProducts(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('none');
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return const Text('active');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Text('error');
              } else {
                if (snapshot.data!.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Ürün bulunamadı'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Ürün Ekle',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  await FireBase.deleteProduct(
                                      snapshot.data![index].productID, context);
                                  setState(() {});
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                horizontalTitleGap: 10,
                                contentPadding: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  snapshot.data![index].productName,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                subtitle: Text(
                                  snapshot.data![index].productDescription,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${snapshot.data![index].productPrice} ₺',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      'Stok: ${snapshot.data![index].productStock}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                leading: ConstrainedBox(
                                  constraints: const BoxConstraints(),
                                  child: Image.network(
                                    snapshot.data![index].productImageURL,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Divider()
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              }
          }
        },
      ),
    );
  }
}
