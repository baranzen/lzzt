import 'package:flutter/material.dart';

Future<void> alertWidget(title, text, context, [Function? function]) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Tamam'),
            onPressed: function == null
                ? () {
                    Navigator.of(context).pop();
                  }
                : () {
                    function();
                  },
          ),
        ],
      );
    },
  );
}
