import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/models/products_model.dart';
import 'package:lzzt/services/hive_services.dart';
import 'package:lzzt/widgets/alertWidget.dart';
import 'package:lzzt/widgets/snackbar_message.dart';

class FireBase {
  static Future<void> userSignIn(userMail, userPassword, context) async {
    late FirebaseAuth auth;
    late FirebaseFirestore firestore;
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;

    try {
      progressIndicator(context);
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userMail,
        password: userPassword,
      );
      var user = userCredential.user;

      if (user!.emailVerified == false) {
        await user.sendEmailVerification();
      } else {
        debugPrint('user is already verified');
      }
      debugPrint('user created ${user.email}');
      //!firestore
      await firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'uid': user.uid,
        'userName': '',
        'userSurname': '',
        'userPhotoUrl': '',
        'userPhone': '',
        'userAddress': '',
        'userType': 'user',
        'isAdmin': false,
        'isEmailVerified': user.emailVerified,
        'userRegisterDate': DateTime.now(),
      });
      Navigator.pop(context);
      await alertWidget("Başaralı kayıt", "Lütfen emaili doğrulayınız", context)
          .then((value) => Navigator.pop(context));
    } on FirebaseAuthException catch (error) {
      debugPrint(error.code);
      debugPrint(error.message);
      await alertWidget("Hata", "$error.message", context)
          .then((value) => Navigator.pop(context));
    }
  }

  static Future<void> changeUserData(
      userName, userSurname, userPhone, userAddress, context) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'userName': userName,
        'userSurname': userSurname,
        'userPhone': userPhone,
        'userAddress': userAddress,
      });
      snackBarMessage(context, 'Kullanıcı bilgileri güncellendi');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> changePassword(newPassword, context) async {
    try {
      progressIndicator(context);
      var user = FirebaseAuth.instance.currentUser;
      await user!.reload();
      await user.updatePassword(newPassword);
      snackBarMessage(context, 'Şifre güncellendi');
    } catch (e) {
      debugPrint(e.toString());
      snackBarMessage(context, e);
    } finally {
      Navigator.pop(context);
    }
  }

  static Future<void> resetPassword(email, context) async {
    try {
      progressIndicator(context);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      snackBarMessage(context, 'Şifre sıfırlama maili gönderildi');
    } catch (e) {
      debugPrint(e.toString());
      snackBarMessage(context, e);
    } finally {
      Navigator.pop(context);
    }
  }

  static Future<void> changeProfilePhoto(userPhotoUrl, context) async {
    try {
      progressIndicator(context);
      var user = FirebaseAuth.instance.currentUser;
      await user!.updatePhotoURL(userPhotoUrl);
      snackBarMessage(context, 'Profil fotoğrafı güncellendi');
    } catch (e) {
      debugPrint(e.toString());
      snackBarMessage(context, e);
    } finally {
      Navigator.pop(context);
    }
  }

  static Future<bool> userLogIn(
      userMail, userPassword, BuildContext context) async {
    try {
      progressIndicator(context);
      var userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userMail,
        password: userPassword,
      );
      debugPrint(userCredential.user!.email);
      if (userCredential.user != null) {
        Navigator.pop(context);
      }
      snackBarMessage(context, 'Giriş başarılı');
      return await userCheck();
    } on FirebaseAuthException catch (error) {
      debugPrint(error.code);
      debugPrint(error.message);
      await alertWidget("Hata", "$error.message", context);
      return false;
    } finally {
      Navigator.pop(context);
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    var user = FirebaseAuth.instance.currentUser;
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userData.data()!;
  }

  static Future<void> logOut(BuildContext _) async {
    try {
      progressIndicator(_);
      await FirebaseAuth.instance.signOut();
      snackBarMessage(_, 'Oturum sonlandirildi');
      Navigator.pop(_);
    } catch (e) {
      debugPrint(e.toString());
      snackBarMessage(_, e);
    } finally {
      Navigator.pop(_);
    }
  }

  static appBarProfileCheck(context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushNamed(context, '/logInPage');
    } else {
      Navigator.pushNamed(context, '/userPage');
    }
  }

  static Future<dynamic> progressIndicator(context) {
    return showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: CircularProgressIndicator(
            color: AppHelper.appColor1,
          ),
        );
      },
    );
  }

  static Future<bool> userCheck() async {
    //! user Check
    var userData = await getUserData(); // Kullanıcı verilerini bekleyin
    if (userData!['isAdmin']) {
      debugPrint('admin logged in');
      await HiveServices.setAdmin(true);
      return true;
    }
    return false;
  }

  static Future<void> addProductsCollection(productName, productDescription,
      productPrice, productImageURL, productStock, context) async {
    try {
      progressIndicator(context);
      FirebaseFirestore fireStore = FirebaseFirestore.instance;

      await fireStore.collection('products').add({
        'productName': productName,
        'productDescription': productDescription,
        'productPrice': productPrice,
        'productImageURL': productImageURL,
        'productStock': productStock,
        'productOwner': FirebaseAuth.instance.currentUser!.uid,
        'productID': UniqueKey().toString(),
        'productDate': DateTime.now(),
      });

      debugPrint('product added');
      snackBarMessage(context, 'Ürün eklendi');
    } on FirebaseAuthException catch (error) {
      debugPrint(error.code);
      debugPrint(error.message);
      snackBarMessage(context, error.message);
    } finally {
      Navigator.pop(context);
    }
  }

  static Future<List<Products>> getProducts(BuildContext context) async {
    try {
      List<Products> products = [];
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      var querySnapshot = fireStore.collection('products');
      await querySnapshot.get().then((value) {
        for (var element in value.docs) {
          products.add(Products(
            element['productName'],
            element['productDescription'],
            element['productPrice'],
            element['productImageURL'],
            element['productStock'],
            element['productOwner'],
            element['productID'],
            element['productDate'],
          ));
        }
      });

      return products;
    } catch (error) {
      print('Error getting products: $error');
      return [];
    }
  }

  static Future<List<Products>> getAdminsProducts() async {
    try {
      List<Products> adminProducts = [];
      var uID = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      debugPrint('uID: $uID');
      var querySnapshot = fireStore
          .collection('products')
          .where('productOwner', isEqualTo: uID);
      await querySnapshot.get().then((value) {
        for (var element in value.docs) {
          adminProducts.add(Products(
            element['productName'],
            element['productDescription'],
            element['productPrice'],
            element['productImageURL'],
            element['productStock'],
            element['productOwner'],
            element['productID'],
            element['productDate'],
          ));
        }
      });
      debugPrint('admin products length: ${adminProducts[0].productName}');
      return adminProducts;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  static Future<void> deleteProduct(productID, context) async {
    try {
      progressIndicator(context);
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      await fireStore
          .collection('products')
          .where('productID', isEqualTo: productID)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
      snackBarMessage(context, 'Ürün silindi');
    } catch (error) {
      debugPrint(error.toString());
      snackBarMessage(context, error.toString());
    } finally {
      Navigator.pop(context);
    }
  }
}
