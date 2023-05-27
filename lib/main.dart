import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
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
                Text("Input URL",
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
                        message: "Clear input field",
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            HapticFeedback.mediumImpact();
                            inputController.text = '';
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.lightGreen[700],
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
                                      "Input",
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
                                  "Clear Input",
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
                              inputController.text = await _getFromClipboard();
                              if (isURL(inputController.text)) {
                                longURL = inputController.text;
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
                              } else {
                                // print below if paste button returns empty string
                                debugPrint(
                                    "Clipboard doesn't contain valid URL.");
                                // show dialog
                                Dialogs.showNothingToPaste(context);
                                outputController.text = '';
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
                                  if (shortURL.shortenedURL == '') {
                                    Dialogs.showShorteningURLError(context);
                                    // ignore: unnecessary_null_comparison
                                  } else if (shortURL != null ||
                                      shortURL.shortenedURL != '') {
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
                                  }
                                }
                              } else {
                                Dialogs.showInvalidInput(context);
                                outputController.text = '';
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue[700],
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
                                    "Shorten URL",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Output URL  ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700)),
                  Text(
                    "Using the cleanuri.com API ",
                    // style: corporate,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.inactiveGray,
                    ),
                  ),
                  Tooltip(
                      message:
                          'The shortened URLs are received from the free cleanuri.com API. This app is not responsible for the content or accuracy of the shortened URLs.',
                      child: Icon(
                        CupertinoIcons.info,
                        color: CupertinoColors.inactiveGray,
                        size: 14,
                      )),
                ],
              ),
              SizedBox(
                height:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? 8
                        : 0,
              ),
              Text(
                "Your short URL will appear below",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth * 0.7,
                child: TextField(
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
                      message: "Clear output field",
                      child: TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          HapticFeedback.mediumImpact();
                          outputController.text = '';
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.lightGreen[700],
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
                                    "Output",
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
                                "Clear Output",
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
                          backgroundColor: Colors.blue[700],
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
