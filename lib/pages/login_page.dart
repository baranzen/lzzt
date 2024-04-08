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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                //! Email
                TextFormField(
                  onSaved: (newValue) {
                    _userMail = newValue!;
                  },
                  decoration: const InputDecoration(
                    label: Text(
                      'Email',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (value) => EmailValidator.validate(value!) == false
                      ? 'geçerli email giriniz'
                      : '',
                ),
                const SizedBox(
                  height: 25,
                ),
                //! Password
                TextFormField(
                  obscureText: true,
                  onSaved: (newValue) {
                    _userPassword = newValue!;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Şifre en az 6 karakter olmali';
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                //!login in
                ElevatedButton(
                  onPressed: () async {
                    bool validate = _formKey.currentState!.validate();
                    if (validate) {
                      _formKey.currentState!.save();
                      await FireBase.userLogIn(
                          _userMail, _userPassword, context);
                      _formKey.currentState!.reset();
                    }
                    debugPrint('başarısız giriş');
                  },
                  child: const Text('Giriş Yap',
                      style: TextStyle(color: Colors.white)),
                ),

                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
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
      ),
    );
  }
}
