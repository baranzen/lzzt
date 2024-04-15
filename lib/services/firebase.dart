import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lzzt/constans/app_helper.dart';
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

  static Future<void> userLogIn(userMail, userPassword, context) async {
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
      userCheck(context);
      snackBarMessage(context, 'Giriş başarılı');
    } on FirebaseAuthException catch (error) {
      debugPrint(error.code);
      debugPrint(error.message);
      await alertWidget("Hata", "$error.message", context);
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

  static Future<void> userCheck(_) async {
    //! user Check
    var userData = await getUserData(); // Kullanıcı verilerini bekleyin
    if (userData!['isAdmin'] == true) {
      debugPrint('admin logged in');
      HiveServices.setAdmin(true);
      Navigator.pushReplacementNamed(_, '/adminPage');
    }
  }

  static changeProfilePicture(String value, BuildContext context) {}
}
