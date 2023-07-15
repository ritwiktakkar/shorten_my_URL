import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shorten_my_url/url_model.dart' as url_model;
import 'package:shorten_my_url/api_requests.dart' as API;
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';
import 'package:shorten_my_url/dialogs.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug banner from top left
      theme: ThemeData.dark(),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<url_model.ShortenedURL> shortenedURL;

  // Create a text controller and use it to retrieve the current value of the TextField.
  final inputController = TextEditingController();
  final currentLongURLController = TextEditingController();
  final outputController = TextEditingController();
  // text controller for disclaimer about shortened url veracity
  final disclaimerController = TextEditingController();

  late String longURL = "";
  late url_model.ShortenedURL shortURL;

  Future<String> _getFromClipboard() async {
    Map<String, dynamic> result =
        await SystemChannels.platform.invokeMethod('Clipboard.getData');
    debugPrint('Clipboard content: \'${result['text'].toString()}\'');
    if (isURL(result['text'].toString())) {
      return result['text'].toString();
    }
    return '';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputController.dispose();
    outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // final buttonHeightP = screenHeight * 0.08;
    // final buttonHeightLS = screenHeight * 0.1;
    // final buttonWidthLS = screenWidth * 0.15;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black, // make background color black
      body: Column(
        // column contains ALL widgets
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
            ),
            child: Column(
              // first half widgets columns
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Tooltip(
                        message:
                            'The shortened URLs are received from the cleanuri.com API thus rendering this app exempt from any and all responsibility regarding the given content and accuracy of the shortened URL. By using this app, you agree to the previous statement, this app\'s privacy policy, and the policies set forth at cleanuri.com.',
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                          size: 14,
                        )),
                  ],
                ),
                Text("Long URL ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w500)),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    autocorrect: false, // URL so no need
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    controller: inputController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(40.0),
                        ),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                      hintText: "Enter the URL to shorten here",
                      fillColor: Colors.white12,
                    ),
                    style: TextStyle(
                      color: Colors.lightGreen[100],
                      fontSize: 15,
                    ),
                  ),
                ),
                TextField(
                  controller: currentLongURLController,
                  readOnly: true,
                  decoration: new InputDecoration.collapsed(
                    hintText: "",
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey[200],
                    fontSize: 12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: (inputController.text.isNotEmpty ||
                          outputController.text.isNotEmpty),
                      child: Tooltip(
                        message: "Clear all fields",
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 35,
                            color: Colors.grey[100],
                          ),
                          onPressed: () {
                            setState(() {
                              inputController.clear();
                              currentLongURLController.clear();
                              outputController.clear();
                              disclaimerController.clear();
                              longURL = "";
                            });
                          },
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Paste clipboard content to input field",
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(
                            Icons.paste_outlined,
                            size: 35,
                            color: Colors.grey[200],
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            String clipboardData = await _getFromClipboard();
                            if (clipboardData.isEmpty) {
                              Dialogs.showNothingToPaste(context);
                            } else if (isURL(clipboardData)) {
                              if (inputController.text.isNotEmpty) {
                                if (clipboardData == inputController.text) {
                                  Dialogs.showDuplicateClipboard(
                                      context, inputController, clipboardData);
                                } else {
                                  Dialogs.showPaste(
                                      context,
                                      inputController,
                                      currentLongURLController,
                                      outputController,
                                      disclaimerController,
                                      clipboardData);
                                }
                              } else {
                                setState(() {
                                  inputController.text = clipboardData;
                                });
                                HapticFeedback.mediumImpact();
                                final snackBar = SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(25), // <-- Radius
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
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } else {
                              // print below if paste button returns empty string
                              debugPrint(
                                  "Clipboard doesn't contain valid URL.");
                              // show dialog
                              Dialogs.showNothingToPaste(context);
                              setState(() {
                                currentLongURLController.clear();
                                outputController.clear();
                                disclaimerController.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Shorten URL in input field",
                      child: Visibility(
                        visible: (inputController.text.isNotEmpty),
                        child: Builder(
                          builder: (context) => Container(
                            width: 90,
                            child: GestureDetector(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                if (isURL(inputController.text)) {
                                  // CHECK 1: check if device has internet connection
                                  var result =
                                      await Connectivity().checkConnectivity();
                                  if (result == ConnectivityResult.none) {
                                    // Show no internet connection error dialog
                                    Dialogs.showNoInternetConnection(context);
                                  } else {
                                    // device has network connectivity (android passes this even if only connected to hotel WiFi)
                                    if (inputController.text
                                            .contains("cleanuri.com/") ||
                                        inputController.text
                                            .contains("shorturl.at/") ||
                                        inputController.text
                                            .contains("bit.ly/")) {
                                      // CHECK 2: check if longURL is already a shortened URL
                                      Dialogs.showInvalidInput(context);
                                    } else if (longURL ==
                                        inputController.text) {
                                      // CHECK 3: check if longURL is the same as the previous longURL
                                      Dialogs.showRepeatLongURL(
                                          context,
                                          inputController,
                                          currentLongURLController);
                                    } else {
                                      longURL = inputController.text;
                                      shortURL =
                                          (await API.getShortenedURL(longURL))!;
                                      // CHECK 4: check if API returned null
                                      if (shortURL.shortenedURL.isEmpty) {
                                        Dialogs.showShorteningURLError(context);
                                      } else if (shortURL
                                          .shortenedURL.isNotEmpty) {
                                        HapticFeedback.lightImpact();
                                        final snackBar = SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                25), // <-- Radius
                                          ),
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
                                                'URL successfully shortened',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          currentLongURLController.text =
                                              "Submitted: $longURL";
                                          outputController.text =
                                              shortURL.shortenedURL;
                                          disclaimerController.text =
                                              "If this URL redirects to an ad, open it in a new browser window";
                                        });
                                      }
                                    }
                                  }
                                } else {
                                  Dialogs.showInvalidInput(context);
                                  setState(() {
                                    currentLongURLController.clear();
                                    outputController.clear();
                                    disclaimerController.clear();
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.link_outlined,
                                      size: 45, color: Colors.blue[200]),
                                  Icon(
                                    Icons.arrow_forward_outlined,
                                    size: 15,
                                  ),
                                  Icon(Icons.link_outlined,
                                      size: 30, color: Colors.blue[200]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            // divider between first and second half of widgets
            color: Colors.grey[800],
            thickness: 2,
          ),
          Column(
            // column for second half of widgets
            children: <Widget>[
              Text("Short URL",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 6),
              Container(
                width: (screenWidth < 1000)
                    ? screenWidth * 0.7
                    : screenWidth * 0.3,
                child: Column(
                  children: [
                    TextField(
                      textAlign: TextAlign.center,
                      readOnly: true,
                      controller: outputController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(40.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(5),
                        filled: true,
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        hintText: "The shortened URL will appear here",
                        fillColor: Colors.white12,
                      ),
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: disclaimerController,
                readOnly: true,
                decoration: new InputDecoration.collapsed(
                  hintText: null,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey[400],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Visibility(
                visible: outputController.text.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Tooltip(
                      message: "Open the shortened URL in a browser",
                      child: IconButton(
                        icon: Icon(
                          Icons.open_in_browser_outlined,
                          size: 35,
                          color: Colors.grey[200],
                        ),
                        onPressed: () {
                          // open shortened URL in browser
                          // API.openURL(outputController.text);
                          debugPrint(
                              "Opening URL in browser: ${shortURL.shortenedURL}");
                          debugPrint(
                              "screenWidth: $screenWidth , screenHeight: $screenHeight");
                          launchUrl(
                            Uri.parse(shortURL.shortenedURL),
                          );
                        },
                      ),
                    ),
                    Tooltip(
                      message: "Copy the shortened URL to clipboard",
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(
                            Icons.copy_outlined,
                            size: 35,
                            color: Colors.grey[200],
                          ),
                          onPressed: () async {
                            if (isURL(outputController.text)) {
                              Clipboard.setData(new ClipboardData(
                                      text: outputController.text))
                                  .then(
                                (result) {
                                  HapticFeedback.mediumImpact();
                                  final snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          25), // <-- Radius
                                    ),
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
                                          'Copied short URL to clipboard',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                              );
                            } else {
                              // show dialog
                              Dialogs.showNothingToCopy(context);
                            }
                          },
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Share the shortened URL",
                      child: Container(
                        width: 70,
                        child: IconButton(
                          icon: Icon(
                            Platform.isIOS
                                ? Icons.ios_share_outlined
                                : Icons.share_outlined,
                            size: 35,
                            color: Colors.grey[200],
                          ),
                          onPressed: () {
                            Share.share(outputController.text);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              )
            ],
          ),
        ],
      ),
    );
  }
}
