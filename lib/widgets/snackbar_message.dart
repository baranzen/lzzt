import 'package:flutter/material.dart';

snackBarMessage(_, text) {
  final SnackBar snackBar = SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(_).showSnackBar(snackBar);
}
