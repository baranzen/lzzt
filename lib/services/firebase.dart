import 'dart:async';

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

  static Future<void> logOut(_) async {
    try {
      progressIndicator(_);
      await FirebaseAuth.instance.signOut();
      alertWidget('Oturum sonlandirildi', '', _)
          .then((value) => Navigator.pop(_));
      await HiveServices.setAdmin(false);
      Navigator.pop(_);
      snackBarMessage(_, 'Oturum sonlandirildi');
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

      DocumentReference userDocRef = fireStore
          .collection('products')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      await userDocRef.collection('adminProducts').add({
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

  static Future<List<Products>> getAdminsProducts() async {
    try {
      List<Products> adminProducts = [];
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      DocumentReference userDocRef = fireStore
          .collection('products')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      QuerySnapshot userProductsSnapshot =
          await userDocRef.collection('adminProducts').get();

      userProductsSnapshot.docs.forEach((productDoc) {
        Map<String, dynamic> productData =
            productDoc.data() as Map<String, dynamic>;
        adminProducts.add(Products(
          productData['productName'],
          productData['productDescription'],
          productData['productPrice'],
          productData['productImageURL'],
          productData['productStock'],
          productData['productOwner'],
          productData['productID'],
          productData['productDate'],
        ));
      });
      return adminProducts;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  static Stream<List<Products>> getAdminsProductsRealTime() {
    StreamController<List<Products>> _adminProductsController =
        StreamController<List<Products>>.broadcast();
    List<Products> adminProducts = [];

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    fireStore
        .collection('products')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('adminProducts')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
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
      });
      _adminProductsController.add(adminProducts);
    });
    return _adminProductsController.stream;
  }
}
