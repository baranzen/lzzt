import 'package:flutter/material.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/widgets/app_bar_widget.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: [
              ElevatedButton(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                    Text(
                      'Ürün Ekle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                onPressed: () => bottomSheet(context),
              ),
              ElevatedButton(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                    Text(
                      'Ürünler',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, '/adminPageProducts'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                    Text(
                      'Siparişler',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                    Text(
                      'Istatistikler',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bottomSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String productName = '';
    String productDescription = '';
    double productdPrice = 0;
    String productImageURL = '';
    int producktStock = 0;
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (_) {
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
                            //! add product
                            await FireBase.addProductsCollection(
                              productName,
                              productDescription,
                              productdPrice,
                              productImageURL,
                              producktStock,
                              context,
                            );
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
