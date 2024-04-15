import 'package:flutter/material.dart';

Future<dynamic> bottomSheet(
  ValueChanged<String> buttonOnPressed,
  String labelText,
  bool obscureText,
  TextInputType inputType,
  BuildContext context,
) {
  final _formKey = GlobalKey<FormState>();
  var value = '';
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    context: context,
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    obscureText: obscureText,
                    keyboardType: inputType,
                    onChanged: (v) => value = v,
                    decoration: InputDecoration(
                      labelText: labelText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) =>
                        value!.length < 6 ? 'En az 6 karakter olmali' : null,
                  ),
                ),
                //button
                ElevatedButton(
                  onPressed: () {
                    bool validate = _formKey.currentState!.validate();
                    if (validate) {
                      buttonOnPressed(value);
                      _formKey.currentState!.reset();
                    }
                  },
                  child: const Text(
                    'Değiştir',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
