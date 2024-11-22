import 'package:flutter/material.dart';

void showMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('Notification'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    ),
  );
}