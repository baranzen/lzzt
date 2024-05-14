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
                        Products product = snapshot.data![index];
                        return Slidable(
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                foregroundColor: Colors.white,
                                autoClose: true,
                                onPressed: (context) async {
                                  bottomSheet(context, snapshot.data![index]);
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
                                      snapshot.data![index].productID, context);
                                  setState(() {});
                                },
                                label: 'Sil',
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 150,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: HexColor("F3F5F7"),
                                    width: 1,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productName,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: HexColor('#333333'),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          product.productDescription.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${product.productPrice.toString()} TL',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      product.productImageURL,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      frameBuilder: (BuildContext context,
                                          Widget child,
                                          int? frame,
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
                                ],
                              ),
                            ),
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
