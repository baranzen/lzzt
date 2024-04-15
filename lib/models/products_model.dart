import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String productImageURL;
  final int productStock;
  final String productOwner;
  final String productID;
  final Timestamp productDate;

  Products(
    this.productName,
    this.productDescription,
    this.productPrice,
    this.productImageURL,
    this.productStock,
    this.productOwner,
    this.productID,
    this.productDate,
  );
}
