import 'package:flutter/material.dart';

snackBarMessage(_, text) {
  //snack bar message zaten ekranda ise pop yap
  ScaffoldMessenger.of(_).removeCurrentSnackBar();
  final SnackBar snackBar = SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(_).showSnackBar(snackBar);
}
