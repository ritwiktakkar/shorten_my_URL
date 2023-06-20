import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shorten_my_url/url_model.dart' as url_model;
import 'package:shorten_my_url/api_requests.dart' as API;
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';
import 'package:shorten_my_url/dialogs.dart';
import 'package:share/share.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
  final outputController = TextEditingController();
  // text controller for disclaimer about shortened url veracity
  final disclaimerController = TextEditingController();

  late String longURL;
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

    final buttonHeightP = screenHeight * 0.1;
    final buttonWidthP = screenWidth * 0.25;
    final buttonHeightLS = screenHeight * 0.1;
    final buttonWidthLS = screenWidth * 0.15;

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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Long URL",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700)),
                SizedBox(
                  height: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 8
                      : 0,
                ),
                Text(
                  "Enter a URL to shorten",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
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
                      contentPadding: EdgeInsets.fromLTRB(25, 8, 20, 8),
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                      hintText: "Enter the URL to shorten here",
                      fillColor: Colors.white12,
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? buttonWidthP
                          : (buttonWidthLS),
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? buttonHeightP
                          : (buttonHeightLS),
                      child: Tooltip(
                        message: "Clear input and output field",
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (outputController.text.isNotEmpty ||
                                inputController.text.isNotEmpty) {
                              Dialogs.showClearAll(context, inputController,
                                  outputController, disclaimerController);
                              debugPrint(
                                  "current input and output controller: ${inputController.text} ${outputController.text}");
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    AutoSizeText(
                                      "Clear",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    AutoSizeText(
                                      "All",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : (AutoSizeText(
                                  "Clear All",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                        ),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? buttonWidthP
                          : (buttonWidthLS),
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? buttonHeightP
                          : (buttonHeightLS),
                      child: Tooltip(
                        message: "Paste clipboard content to input field",
                        child: Builder(
                          builder: (context) => TextButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              String clipboardData = await _getFromClipboard();
                              if (isURL(clipboardData)) {
                                if (inputController.text.isNotEmpty) {
                                  Dialogs.showPaste(
                                      context,
                                      inputController,
                                      outputController,
                                      disclaimerController,
                                      clipboardData);
                                } else {
                                  inputController.text = clipboardData;
                                  HapticFeedback.mediumImpact();
                                  final snackBar = SnackBar(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          25), // <-- Radius
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
                                        AutoSizeText(
                                          'Pasted URL from clipboard',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                          maxLines: 1,
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
                                outputController.clear();
                                disclaimerController.clear();
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.cyan[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: AutoSizeText(
                              "Paste",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? buttonWidthP
                          : (buttonWidthLS),
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? buttonHeightP
                          : (buttonHeightLS),
                      child: Tooltip(
                        message: "Shorten URL in input field",
                        child: Builder(
                          builder: (context) => TextButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (isURL(inputController.text)) {
                                // check if device has internet connection
                                var result =
                                    await Connectivity().checkConnectivity();
                                if (result == ConnectivityResult.none) {
                                  // Show no internet connection error dialog
                                  Dialogs.showNoInternetConnection(context);
                                } else {
                                  // device has network connectivity (android passes this even if only connected to hotel WiFi)
                                  longURL = inputController.text;
                                  shortURL =
                                      (await API.getShortenedURL(longURL))!;
                                  if (shortURL.shortenedURL.isEmpty) {
                                    Dialogs.showShorteningURLError(context);
                                    // ignore: unnecessary_null_comparison
                                  } else if (shortURL != null ||
                                      shortURL.shortenedURL.isNotEmpty) {
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
                                          AutoSizeText(
                                            'URL successfully shortened',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    outputController.text =
                                        shortURL.shortenedURL;
                                    disclaimerController.text =
                                        "Refresh the page if the shortened URL is an ad";
                                  }
                                }
                              } else {
                                Dialogs.showInvalidInput(context);
                                outputController.clear();
                                disclaimerController.clear();
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.cyan[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      AutoSizeText(
                                        "Shorten",
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      AutoSizeText(
                                        "My URL",
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : ((AutoSizeText(
                                    "ShortenMyURL",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ))),
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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Short URL",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? 8
                        : 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "The short URL will appear below ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  Tooltip(
                      message:
                          'The shortened URLs are received from the cleanuri.com API, thus rendering this app exempt from responsibility regarding the given content and accuracy of the shortened URL. By using this app, you agree to the previous statement and the policies set forth at cleanuri.com.',
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                        size: 14,
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth * 0.7,
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
                        contentPadding: EdgeInsets.only(top: 10, bottom: 10),
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                        scrollController: ScrollController(),
                        controller: disclaimerController,
                        readOnly: true,
                        decoration: new InputDecoration.collapsed(
                          hintText: null,
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 12,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? buttonWidthP
                        : (buttonWidthLS),
                    height: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? buttonHeightP
                        : (buttonHeightLS),
                    child: Tooltip(
                      message: "Copy shortened URL to clipboard",
                      child: Builder(
                        builder: (context) => TextButton(
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
                                        AutoSizeText(
                                          'Copied short URL to clipboard',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                          maxLines: 1,
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
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.cyan[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: AutoSizeText(
                            "Copy",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? buttonWidthP
                        : (buttonWidthLS),
                    height: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? buttonHeightP
                        : (buttonHeightLS),
                    child: Tooltip(
                      message: "Share the shortened URL",
                      child: TextButton(
                        onPressed: () async {
                          if (isURL(outputController.text)) {
                            Share.share(outputController.text);
                          } else {
                            Dialogs.showNothingToShare(context);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.cyan[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  AutoSizeText(
                                    "Share",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  AutoSizeText(
                                    "URL",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : ((AutoSizeText(
                                "Share URL",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))),
                      ),
                    ),
                  ),
                ],
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
