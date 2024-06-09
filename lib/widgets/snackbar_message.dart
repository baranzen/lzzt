import 'package:flutter/material.dart';
import 'package:lzzt/constans/app_helper.dart';

snackBarMessage(_, text) {
  //snack bar message zaten ekranda ise pop yap
  ScaffoldMessenger.of(_).removeCurrentSnackBar();
  final SnackBar snackBar = SnackBar(
    elevation: 0,
    backgroundColor: AppHelper.appColor1,
    content: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(_).showSnackBar(snackBar);
}
