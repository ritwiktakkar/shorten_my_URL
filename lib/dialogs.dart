import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shorten_my_url/Analytics/constants.dart' as Constants;

class Dialogs {
  static Text noURLFoundInClipboardTitle = Text(
    'No URL Found in Clipboard',
  );

  static Text noURLFoundinClipboardContent = Text(
    "While your clipboard is not empty, this app can only parse valid URLs stored there. Please ensure your clipboard only contains a valid URL and try again.",
  );

  static Text shorteningURLTitle = Text(
    'Couldn\'t Shorten URL',
  );

  static Text shorteningURLContent = Text(
    "The input field does not seem to contain a valid URL. Therefore, it can't be shortened. Please ensure your entry contains a valid and complete URL and try again.",
  );

  static Text invalidInputTitle = Text(
    'Invalid Entry',
  );

  static Text invalidInputContent = Text(
    "The input field might not exist or it may already be a shortened URL. Please ensure your entry contains a valid URL and try again.",
  );

  static Text emptyClipboardTitle = Text(
    'Empty Clipboard',
  );

  static Text emptyClipboardContent = Text(
    "There is nothing in the clipboard to paste. Please copy a valid URL to the clipboard and try again.",
  );

  static Text duplicateClipboardTitle = Text(
    'Duplicate URL in Clipboard',
  );

  static Text duplicateClipboardContent = Text(
    "The URL stored in the clipboard matches the current long URL you entered.",
  );

  static Text networkErrorTitle = Text(
    'Network Error',
  );

  static Text networkErrorContent = Text(
    "There was an error connecting to the internet. Please check your network settings and try again. If the problem persists, there may be an issue in the server.",
  );

  static Text gotItThanks = Text(
    'Got it, thanks!',
  );

  // this dialog pops up when the user presses the 'paste' button and there's no URL to paste in the clipboard
  static Future<void> showNothingToPaste(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: noURLFoundInClipboardTitle,
            content: noURLFoundinClipboardContent,
            actions: <Widget>[
              TextButton(
                child: gotItThanks,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: noURLFoundInClipboardTitle,
          content: noURLFoundinClipboardContent,
          actions: <Widget>[
            TextButton(
              child: gotItThanks,
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
            title: shorteningURLTitle,
            content: shorteningURLContent,
            actions: <Widget>[
              TextButton(
                child: gotItThanks,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: shorteningURLTitle,
          content: shorteningURLContent,
          actions: <Widget>[
            TextButton(
              child: gotItThanks,
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
            title: invalidInputTitle,
            content: invalidInputContent,
            actions: <Widget>[
              TextButton(
                child: gotItThanks,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: invalidInputTitle,
          content: invalidInputContent,
          actions: <Widget>[
            TextButton(
              child: gotItThanks,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showEmptyClipboard(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: emptyClipboardTitle,
            content: emptyClipboardContent,
            actions: <Widget>[
              TextButton(
                child: gotItThanks,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: emptyClipboardTitle,
          content: emptyClipboardContent,
          actions: <Widget>[
            TextButton(
              child: gotItThanks,
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
  static Future<void> showNetworkError(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: networkErrorTitle,
            content: networkErrorContent,
            actions: <Widget>[
              TextButton(
                child: gotItThanks,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: networkErrorTitle,
          content: networkErrorContent,
          actions: <Widget>[
            TextButton(
              child: gotItThanks,
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showDuplicateClipboard(BuildContext context,
      TextEditingController inputController, String clipboardData) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: duplicateClipboardTitle,
            content: duplicateClipboardContent,
            actions: <Widget>[
              TextButton(
                child: gotItThanks,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: duplicateClipboardTitle,
          content: duplicateClipboardContent,
          actions: <Widget>[
            TextButton(
              child: gotItThanks,
              onPressed: () {
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
        debugPrint("Clearing all fields from dialog");
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
      title: (outputController.text.isNotEmpty)
          ? Text("Clear all?")
          : Text("Clear input?"),
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> showContactDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: duplicateClipboardTitle,
            content: duplicateClipboardContent,
            actions: <Widget>[
              TextButton(
                child: gotItThanks,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return CupertinoAlertDialog(
          title: const Text("Get in Touch"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss dialog first
                  Future.delayed(const Duration(milliseconds: 300), () {
                    launchUrl(Uri.parse(Constants.twitterUrl),
                        mode: LaunchMode.externalApplication);
                  });
                },
                child: const Text('Twitter / X'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss dialog first
                  Future.delayed(const Duration(milliseconds: 300), () {
                    launchUrl(Uri.parse(Constants.formUrl));
                  });
                },
                child: const Text('Feedback form'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss dialog first
                  Future.delayed(const Duration(milliseconds: 300), () {
                    launchUrl(Uri.parse(Constants.appStoreUrl));
                  });
                },
                child: const Text('My other apps'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
