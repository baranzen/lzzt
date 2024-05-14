import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/models/products_model.dart';
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
                        return Column(
                          children: [
                            Slidable(
                              startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    foregroundColor: Colors.white,
                                    autoClose: true,
                                    onPressed: (context) async {
                                      bottomSheet(
                                          context, snapshot.data![index]);
                                    },
                                    icon: Icons.edit,
                                    label: 'Düzenle',
                                    backgroundColor: AppHelper.appColor1,
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    autoClose: true,
                                    onPressed: (context) async {
                                      await FireBase.deleteProduct(
                                          snapshot.data![index].productID,
                                          context);
                                      setState(() {});
                                    },
                                    label: 'Sil',
                                    icon: Icons.delete,
                                    backgroundColor: Colors.red,
                                  ),
                                ],
                              ),
                              child: ListTile(
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
                            ),
                            Divider(
                              height: 1,
                              color: HexColor("F3F5F7"),
                            )
                          ],
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

  bottomSheet(BuildContext context, Products product) {
    final formKey = GlobalKey<FormState>();
    String productName = product.productName;
    String productDescription = product.productDescription;
    double productdPrice = product.productPrice;
    String productImageURL = product.productImageURL;
    int producktStock = product.productStock;
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              ),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //! product name
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          initialValue: productName,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          onChanged: (v) => productName = v,
                          decoration: InputDecoration(
                            labelText: 'Ürün Adı',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => value!.length < 3
                              ? 'En az 3 karakter olmali'
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          //! product description
                          initialValue: productDescription,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          onChanged: (v) => productDescription = v,
                          decoration: InputDecoration(
                            labelText: 'Ürün Aciklamasi',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => value!.length < 10
                              ? 'En az 10 karakter olmali'
                              : null,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          //! product price
                          initialValue: productdPrice.toString(),
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          onChanged: (v) => productdPrice = double.parse(v),
                          decoration: InputDecoration(
                            labelText: 'Ucret',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => value!.length < 1
                              ? 'En az 1 karakter olmali'
                              : null,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          initialValue: productImageURL,
                          //! product image
                          obscureText: false,
                          keyboardType: TextInputType.url,
                          onChanged: (v) => productImageURL = v,
                          decoration: InputDecoration(
                            labelText: 'Resim Url',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => value!.length < 10
                              ? 'En az 10 karakter olmali'
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          initialValue: producktStock.toString(),
                          //! prodcut stock
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          onChanged: (v) => producktStock = int.parse(v),
                          decoration: InputDecoration(
                            labelText: 'Stok Adedi',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => value!.length < 1
                              ? 'En az 1 karakter olmali'
                              : null,
                        ),
                      ),

                      //button
                      ElevatedButton(
                        onPressed: () async {
                          bool validate = formKey.currentState!.validate();
                          if (validate) {
                            formKey.currentState!.save();
                            //! update product
                            await FireBase.updateProduct(
                              product.productID,
                              productName,
                              productDescription,
                              productdPrice,
                              productImageURL,
                              producktStock,
                              context,
                            );
                            setState(() {});
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            formKey.currentState!.reset();
                          }
                        },
                        child: const Text(
                          'Ekle',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
