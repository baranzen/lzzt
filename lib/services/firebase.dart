import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lzzt/widgets/alertWidget.dart';

class FireBase {
  static Future<void> userSignIn(userMail, userPassword, context) async {
    late FirebaseAuth auth;
    auth = FirebaseAuth.instance;

    try {
      showDialog(
        context: context,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        },
      );
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userMail,
        password: userPassword,
      );
      var user = userCredential.user;

      if (user!.emailVerified == false) {
        await user.sendEmailVerification();
      } else {
        print('user is already verified');
      }

      print(userCredential.user!.email);
      print('user created ');
      print(user.displayName);
      alertWidget("Başaralı kayıt", "Lütfen emaili doğrulayınız", context)
          .then((value) => Navigator.pop(context));
    } on FirebaseAuthException catch (error) {
      print(error.code);
      print(error.message);
      alertWidget("Hata", "$error.message", context);
    }
  }

  static Future<void> userLogIn(userMail, userPassword, context) async {
    try {
      showDialog(
        context: context,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        },
      );
      var userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userMail,
        password: userPassword,
      );
      debugPrint(userCredential.user!.email);
    } on FirebaseAuthException catch (error) {
      debugPrint(error.code);
      debugPrint(error.message);
      alertWidget("Hata", "$error.message", context);
    }
  }
}
