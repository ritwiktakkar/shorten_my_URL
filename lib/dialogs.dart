import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dialogs {
  // this dialog pops up when the user presses the 'paste' button and there's no URL to paste in the clipboard
  static Future<void> showNothingToPaste(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'No URL Found in Clipboard',
            ),
            content: Text(
              "This app can only paste valid URLs stored in the clipboard. Please ensure your clipboard only contains a valid URL before pressing the 'Paste' button.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'No URL Found in Clipboard',
          ),
          content: Text(
            "This app can only paste valid URLs stored in the clipboard. Please ensure your clipboard only contains a valid URL before tapping the 'Paste' icon.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
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
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'No URL To Copy',
            ),
            content: Text(
              "Your output field contains no shortened URL to copy to the clipboard. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'No URL To Copy',
          ),
          content: Text(
            "Your output field contains no shortened URL to copy to the clipboard. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
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
  static Future<void> showShorteningURLError(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'Couldn\'t Shorten URL',
            ),
            content: Text(
              "The input field does not seem to contain a valid URL. Therefore, it can't be shortened. Please ensure your entry contains a valid URL and try again.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'Couldn\'t Shorten URL',
          ),
          content: Text(
            "The input field does not seem to contain a valid URL. Therefore, it can't be shortened. Please ensure your entry contains a valid URL and try again.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
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
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'No URL To Share',
            ),
            content: Text(
              "Your output field contains no shortened URL to share. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'No URL To Share',
          ),
          content: Text(
            "Your output field contains no shortened URL to share. Please try pasting a valid URL in the input field and pressing the 'Shorten URL' button to get a shortened URL in the output field.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
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
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'Invalid Entry',
            ),
            content: Text(
              "The input field does not seem to contain a valid URL (e.g., this URL might not exist or it may already be a shortened URL). Therefore, it can't be shortened. Please ensure your entry contains a valid URL and try again.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'Invalid Entry',
          ),
          content: Text(
            "The input field does not seem to contain a valid URL (e.g., this URL might not exist or it may already be a shortened URL). Therefore, it can't be shortened. Please ensure your entry contains a valid URL and try again.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
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

  // this dialog pops up when the user presses the 'shorten url' button and there is no internet
  static Future<void> showNoInternetConnection(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'No Internet Connection',
            ),
            content: Text(
              "Your device doesn't seem to have an internet connection. Please check your network settings and try again.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'No Internet Connection',
          ),
          content: Text(
            "Your device doesn't seem to have an internet connection. Please check your network settings and try again.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
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

  static Future<void> showRepeatLongURL(
      BuildContext context,
      TextEditingController inputController,
      TextEditingController currentLongURLController) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'Duplicate Request',
            ),
            content: Text(
              "Please enter a new long URL to shorten given that the requested long URL has already been shortened below.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Got it, thanks!',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: Text(
            'Duplicate Request',
          ),
          content: Text(
            "Please enter a new long URL to shorten given that the requested long URL has already been shortened below.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got it, thanks!',
              ),
              onPressed: () {
                inputController.clear();
                currentLongURLController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // this dialog is shown when the user presses the "Clear All" button to confirm that both the input and output URL fields will be cleared
  static Future<void> showClearAll(
      BuildContext context,
      TextEditingController inputController,
      TextEditingController currentLongURLController,
      TextEditingController outputController,
      TextEditingController disclaimerController) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        HapticFeedback.mediumImpact();
        inputController.clear();
        currentLongURLController.clear();
        outputController.clear();
        disclaimerController.clear();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog androidAlert = AlertDialog(
      title: Text("Clear all?"),
      content: (outputController.text.isNotEmpty)
          ? Text("Continuing will clear both the input and output fields.")
          : Text("Continuing will clear the input field."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    CupertinoAlertDialog iOSAlert = CupertinoAlertDialog(
      title: Text("Clear all?"),
      content: (outputController.text.isNotEmpty)
          ? Text("Continuing will clear both the input and output fields.")
          : Text("Continuing will clear the input field."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return (Platform.isAndroid) ? androidAlert : iOSAlert;
      },
    );
  }

  // this dialog is shown when there is a valid URL in the clipboard to paste to confirm that doing so will rid the current URL(s) shown on screen.
  static Future<void> showPaste(
      BuildContext context,
      TextEditingController inputController,
      TextEditingController currentLongURLController,
      TextEditingController outputController,
      TextEditingController disclaimerController,
      String clipboardData) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        HapticFeedback.mediumImpact();
        inputController.clear();
        currentLongURLController.clear();
        outputController.clear();
        disclaimerController.clear();
        final snackBar = SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // <-- Radius
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange[300],
          content: Row(
            children: <Widget>[
              Icon(
                Icons.check,
                color: Colors.black54,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Pasted URL from clipboard',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        );
        inputController.text = clipboardData;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
    // set up the AlertDialog
    AlertDialog androidAlert = AlertDialog(
      title: Text("Paste URL?"),
      content: (outputController.text.isNotEmpty)
          ? Text(
              "Continuing will clear the output field and replace the contents of the input field with this URL stored in the clipboard: $clipboardData")
          : Text(
              "Continuing will replace the contents of the input field with this URL stored in the clipboard: $clipboardData"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    CupertinoAlertDialog iOSAlert = CupertinoAlertDialog(
      title: Text("Paste URL?"),
      content: (outputController.text.isNotEmpty)
          ? Text(
              "Continuing will clear the output field and replace the contents of the input field with this URL stored in the clipboard: $clipboardData")
          : Text(
              "Continuing will replace the contents of the input field with this URL stored in the clipboard: $clipboardData"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return (Platform.isAndroid) ? androidAlert : iOSAlert;
      },
    );
  }
}
