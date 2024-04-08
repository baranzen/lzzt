import 'package:firebase_auth/firebase_auth.dart';
import 'package:lzzt/widgets/alertWidget.dart';

class FireBase {
  static Future<void> userSignIn(userMail, userPassword, context) async {
    late FirebaseAuth auth;
    auth = FirebaseAuth.instance;

    try {
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
      alertWidget("Başaralı kayıt", "Lütfen emaili doğrulayınız", context);
    } on FirebaseAuthException catch (error) {
      print(error.code);
      print(error.message);
      alertWidget("Hata", "$error.message", context);
    }
  }
}
