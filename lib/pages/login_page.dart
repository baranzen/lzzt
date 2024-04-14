import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:lzzt/services/firebase.dart';

class LoginPage extends StatelessWidget {
  final userGmailController = TextEditingController();
  final passwordController = TextEditingController();
  var _userMail;
  var _userPassword;
  final _formKey = GlobalKey<FormState>();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/logo2.png',
                fit: BoxFit.cover,
              ),
            ),
            //!form
            Expanded(
              flex: 2,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //! Email
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (newValue) {
                          _userMail = newValue!;
                        },
                        decoration: const InputDecoration(
                          label: Text(
                            'Email',
                          ),
                        ),
                        validator: (value) {
                          if (!EmailValidator.validate(value!)) {
                            return 'Geçerli bir email giriniz';
                          }
                        }),

                    //! Password
                    TextFormField(
                      obscureText: true,
                      onSaved: (newValue) {
                        _userPassword = newValue!;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        labelText: 'Şifre',
                      ),
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Şifre en az 6 karakter olmali';
                        }
                      },
                    ),

                    //!login in
                    ElevatedButton(
                      onPressed: () async {
                        bool validate = _formKey.currentState!.validate();
                        if (validate) {
                          _formKey.currentState!.save();
                          debugPrint('$_userMail, $_userPassword');
                          await FireBase.userLogIn(
                              _userMail, _userPassword, context);
                          _formKey.currentState!.reset();
                        } else {
                          debugPrint('validate false');
                        }
                      },
                      child: const Text('Giriş Yap',
                          style: TextStyle(color: Colors.white)),
                    ),

                    const SizedBox(height: 12),
                    const Divider(),
                    const Text("Hesabınız yok mu?"),
                    TextButton(
                      child: const Text("Kayıt ol"),
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, '/signInPage'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
