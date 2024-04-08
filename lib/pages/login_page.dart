import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
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
                ElevatedButton(
                  onPressed: () async {
                    bool _validate = _formKey.currentState!.validate();
                    if (_validate) {
                      _formKey.currentState!.save();
                      debugPrint("başarılı giril");

                      _formKey.currentState!.reset();
                    }
                  },
                  child: const Text('Giriş Yap'),
                ),

                const SizedBox(
                  height: 12,
                ),
                const Divider(),
                const Text("Hesabınız yok mu?"),
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Kayıt ol"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
