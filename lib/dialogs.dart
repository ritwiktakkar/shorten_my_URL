import 'package:flutter/material.dart';

class Dialogs {
  // this dialog pops up when the user presses the 'paste' button and there's no URL to paste in the clipboard
  static Future<void> showNothingToPaste(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Row(
            children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Text(
                'No URL To Paste',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          content: Text(
            "This app can only paste valid URLs stored in the clipboard. Please make sure your clipboard only contains a valid URL before pressing the 'Paste' button.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Got it, thanks!',
                style: TextStyle(fontSize: 18),
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Row(
            children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Text(
                'No URL To Copy',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          content: Text(
            "Your output field contains no shortened URL to copy to the clipboard. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Got it, thanks!',
                style: TextStyle(fontSize: 18),
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

  // this dialog pops up when the user presses the 'shorten URL' button and the api returns an error
  static Future<void> showError(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Row(
            children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Text(
                'Couldn\'t shorten URL',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          content: Text(
            "Your input URL failed to shorten. This could be due to an invalid URL. Please ensure that your input URL is valid and try again.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Got it, thanks!',
                style: TextStyle(fontSize: 18),
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Row(
            children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Text(
                'No URL To Share',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          content: Text(
            "Your output field contains no shortened URL to share. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Got it, thanks!',
                style: TextStyle(fontSize: 18),
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Row(
            children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Text(
                'Invalid Entry',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          content: Text(
            "The input field does not seem to contain a valid URL. Therefore, it can't be shortened. Please make sure your entry contains a valid URL and try again.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Got it, thanks!',
                style: TextStyle(fontSize: 18),
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
