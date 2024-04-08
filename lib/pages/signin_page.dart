import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lzzt/services/firebase.dart';

class SignInPage extends StatelessWidget {
  final userGmailController = TextEditingController();
  final passwordController = TextEditingController();
  var _userMail;
  var _userPassword;
  final _formKey = GlobalKey<FormState>();
  SignInPage({super.key});

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
                    icon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    label: Text(
                      'Email',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (value) => value!.length < 6
                      ? 'Şifre en az 6 karakter olmali'
                      : null,
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
                  validator: (value) => value!.length < 6
                      ? 'Şifre en az 6 karakter olmali'
                      : null,
                ),
                const SizedBox(
                  height: 25,
                ),
                //! kayit ol
                ElevatedButton(
                  onPressed: () async {
                    bool validate = _formKey.currentState!.validate();
                    if (validate) {
                      _formKey.currentState!.save();
                      await FireBase.userSignIn(
                          _userMail, _userPassword, context);
                      _formKey.currentState!.reset();
                    }
                  },
                  child: const Text('Kayıt Ol'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
