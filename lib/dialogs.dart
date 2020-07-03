import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clipboard: No URL Found'),
          content: Text(
              "This app can only paste valid URLs stored in the clipboard. Please make sure your clipboard only contains a valid URL before pressing the 'Paste' button. Don't worry, this app neither stores your clipboard content on its server nor does anything with it except for shortening the URL."),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Got it, thanks!',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
