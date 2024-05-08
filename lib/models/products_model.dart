import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'products_model.g.dart';

@HiveType(typeId: 1)
class Products {
  @HiveField(0)
  final String productName;
  @HiveField(1)
  final String productDescription;
  @HiveField(2)
  final double productPrice;
  @HiveField(3)
  final String productImageURL;
  @HiveField(4)
  final int productStock;
  @HiveField(5)
  final String productOwner;
  @HiveField(6)
  final String productID;
  @HiveField(7)
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
