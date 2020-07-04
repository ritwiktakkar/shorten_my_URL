import 'package:flutter/material.dart';

class Dialogs {
  // this dialog pops up when the user presses the 'paste' button and there's no URL to paste in the clipboard
  static Future<void> showNothingToPaste(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error: No URL To Paste'),
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

  // this dialog pops up when the user presses the 'copy' button and there's nothing to copy to the clipboard
  static Future<void> showNothingToCopy(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error: No URL To Copy'),
          content: Text(
              "Your output field contains no shortened URL to copy to the clipboard. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field."),
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

  // this dialog pops up when the user presses the 'share url' button and there's nothing to share
  static Future<void> showNothingToShare(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error: No URL To Share',
          ),
          content: Text(
            "Your output field contains no shortened URL to share. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field.",
          ),
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

  // this dialog pops up when the user presses the 'shorten url' button and the input field doesn't contain a URL
  static Future<void> showInvalidInput(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error: Invalid Entry'),
          content: Text(
              "The input field does not seem to contain a valid URL. Therefore, it can't be shortened. Please make sure your entry contains a valid URL and try again."),
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
