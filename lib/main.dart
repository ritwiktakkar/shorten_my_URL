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
        // statusBarBrightness: Brightness.dark,
        statusBarColor: Color.fromARGB(255, 27, 27, 29),
        systemNavigationBarColor: Color.fromARGB(255, 27, 27, 29),
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

  final inputController = TextEditingController();
  final currentLongURLController = TextEditingController();
  final outputController = TextEditingController();
  final disclaimerController = TextEditingController();

  String currentShortURL = "";

  int urlPairsCapacity = 20;

  final List<String> longURLs = [];
  final List<String> shortURLs = [];

  bool finding = false;

  late String longURL = "";
  // late url_model.ShortenedURL shortURL;
  late String shortURL;

  static const String appVersion = "4.0.1";

  static const String appInfo = "Results powered by is.gd";

  static const String copyRight =
      "ShortenMyURL (Version $appVersion) by Nocturnal Dev Lab (RT).";

  static const String appDisclaimer =
      "By using this application, you accept the privacy policies of ShortenMyURL linked on the App/Play Store and hereby waive all claims against ShortenMyURL, including those related to the content(s) displayed, and the functionality provided herein.\n$copyRight";

  Future<String> _getFromClipboard() async {
    Map<String, dynamic> result =
        await SystemChannels.platform.invokeMethod('Clipboard.getData');
    if (result['text'].toString().characters.length < 0) {
      return "";
    }
    return result['text'].toString();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputController.dispose();
    outputController.dispose();

    longURLs.clear();
    shortURLs.clear();

    super.dispose();
  }

  void addURLPair(longURL, shortURL) {
    setState(() {
      longURLs.insert(0, longURL);
      shortURLs.insert(0, shortURL);
    });
  }

  void removeFirstURLPair() {
    setState(() {
      longURLs.removeAt(longURLs.length - 1);
      shortURLs.removeAt(shortURLs.length - 1);
    });
  }

  void clearURLPairs() {
    setState(() {
      longURLs.clear();
      shortURLs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromARGB(255, 27, 27, 29),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 15),
            child: Container(
              // color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Long URL container
                  Container(
                    // height: screenHeight * 0.26,
                    // color: Colors.yellow[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        // first half widgets columns
                        children: <Widget>[
                          Text("Long 🔗 ",
                              style: TextStyle(
                                  color: Colors.lightGreen[200],
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              // color: Color.fromARGB(193, 59, 59, 66),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextField(
                              autocorrect: false, // URL so no need
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              controller: inputController,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                                hintText: "Enter a long URL here",
                                // fillColor: Colors.white12,
                              ),
                              style: TextStyle(
                                color: Colors.lightGreen[200],
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: TextField(
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
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Visibility(
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: (inputController.text.isNotEmpty ||
                                    outputController.text.isNotEmpty),
                                child: Tooltip(
                                  message: "Clear all fields",
                                  child: InkWell(
                                    child: Icon(
                                      Icons.delete,
                                      size: 35,
                                      color: Colors.grey[100],
                                    ),
                                    onTap: () {
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
                                message:
                                    "Paste clipboard content to input field",
                                child: Builder(
                                  builder: (context) => InkWell(
                                    child: Icon(
                                      Icons.paste_outlined,
                                      size: 35,
                                      color: Colors.grey[200],
                                    ),
                                    onTap: () async {
                                      debugPrint('Pressed Paste');
                                      FocusScope.of(context).unfocus();
                                      try {
                                        String _ = await _getFromClipboard();
                                        String clipboardData = _;
                                        if (clipboardData.isEmpty) {
                                          debugPrint(
                                              "Clipboard is empty: $clipboardData.");
                                          Dialogs.showEmptyClipboard(context);
                                        } else if (isURL(clipboardData)) {
                                          debugPrint(
                                              "Clipboard contains valid URL: $clipboardData");
                                          if (inputController.text.isNotEmpty) {
                                            if (clipboardData ==
                                                inputController.text) {
                                              Dialogs.showDuplicateClipboard(
                                                  context,
                                                  inputController,
                                                  clipboardData);
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
                                              inputController.text =
                                                  clipboardData;
                                            });
                                            HapticFeedback.mediumImpact();
                                            final snackBar = SnackBar(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25), // <-- Radius
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.orange[300],
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
                                              "Clipboard doesn't contain valid URL: $clipboardData");
                                          // show dialog
                                          Dialogs.showNothingToPaste(context);
                                          setState(() {
                                            currentLongURLController.clear();
                                            outputController.clear();
                                            disclaimerController.clear();
                                          });
                                        }
                                      } on Exception catch (_) {
                                        debugPrint(
                                            "Clipboard is empty: $_. Nothing to paste.");
                                        Dialogs.showEmptyClipboard(context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: "Shorten URL in input field",
                                child: Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: (isURL(inputController.text)),
                                  child: Builder(
                                    builder: (context) => Container(
                                      // width: 90,
                                      child: GestureDetector(
                                        onTap: () async {
                                          debugPrint("Pressed ShortenMyURL");
                                          setState(() {
                                            finding = false;
                                          });
                                          FocusScope.of(context).unfocus();
                                          var result = await Connectivity()
                                              .checkConnectivity();
                                          if (isURL(inputController.text)) {
                                            if (longURLs.contains(
                                                inputController.text)) {
                                              outputController.text = shortURLs[
                                                  longURLs.indexOf(
                                                      inputController.text)];
                                              setState(() {
                                                currentLongURLController.text =
                                                    "This URL was previously shortened during your current session";
                                                // disclaimerController.text =
                                                //     "A preview of the long URL will be shown to the user before redirecting to the short URL";
                                              });
                                            }
                                            // CHECK 1: check if device has internet connection
                                            else if (result ==
                                                ConnectivityResult.none) {
                                              setState(() {
                                                finding = false;
                                              });
                                              // Show no internet connection error dialog
                                              Dialogs.showNetworkError(context);
                                            } else {
                                              // device has network connectivity (android passes this even if only connected to hotel WiFi)
                                              if (inputController.text.contains(
                                                      "cleanuri.com/") ||
                                                  inputController.text.contains(
                                                      "shorturl.at/") ||
                                                  inputController.text
                                                      .contains("bit.ly/")) {
                                                setState(() {
                                                  finding = false;
                                                });
                                                // CHECK 2: check if longURL is already a shortened URL
                                                Dialogs.showInvalidInput(
                                                    context);
                                              } else if (longURL ==
                                                  inputController.text) {
                                                // CHECK 3: check if longURL is the same as the previous longURL
                                                Dialogs.showRepeatLongURL(
                                                    context,
                                                    inputController,
                                                    currentLongURLController);
                                              } else {
                                                longURL = inputController.text;
                                                try {
                                                  var _ = await API
                                                      .getShortenedURL(longURL);
                                                  if (_ != null) {
                                                    shortURL = _;
                                                    setState(() {
                                                      finding = false;
                                                    });

                                                    HapticFeedback
                                                        .lightImpact();
                                                    final snackBar = SnackBar(
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                25), // <-- Radius
                                                      ),
                                                      backgroundColor:
                                                          Colors.orange[300],
                                                      content: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.check,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'URL successfully shortened',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                    setState(() {
                                                      if (longURLs.length ==
                                                          urlPairsCapacity) {
                                                        removeFirstURLPair();
                                                      }
                                                      currentShortURL =
                                                          shortURL;
                                                      addURLPair(
                                                          longURL, shortURL);

                                                      debugPrint(
                                                          "longURLs: $longURLs\nshortURLs: $shortURLs");
                                                      currentLongURLController
                                                              .text =
                                                          "Submitted: $longURL";
                                                      outputController.text =
                                                          shortURL;
                                                      // disclaimerController.text =
                                                      //     "A preview of the long URL will be shown to the user before redirecting to the short URL";
                                                    });
                                                  }
                                                  // CHECK 4: check if API returned null
                                                  else {
                                                    setState(() {
                                                      finding = false;
                                                    });
                                                    Dialogs
                                                        .showShorteningURLError(
                                                            context);
                                                  }
                                                } on Exception catch (_) {
                                                  setState(() {
                                                    finding = false;
                                                  });
                                                  Dialogs
                                                      .showShorteningURLError(
                                                          context);
                                                }
                                              }
                                            }
                                          } else {
                                            Dialogs.showShorteningURLError(
                                                context);
                                            setState(() {
                                              finding = false;
                                              currentLongURLController.clear();
                                              outputController.clear();
                                              disclaimerController.clear();
                                            });
                                          }
                                        },
                                        child: Image.asset(
                                          "assets/shorten.png",
                                          width: 60,
                                          height: 60,
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
                  ),
                  SizedBox(
                    height: screenHeight * 0.005,
                  ),
                  // Short URL container
                  Container(
                    // height: screenHeight * 0.25,
                    // color: Colors.green[100],
                    child: Column(
                      // column for second half of widgets
                      children: <Widget>[
                        Text("Short 🔗",
                            style: TextStyle(
                                color: Colors.lightBlue[200],
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 6),
                        Container(
                          width: (screenWidth < 1000)
                              ? screenWidth * 0.7
                              : screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(193, 59, 59, 66),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            readOnly: true,
                            controller: outputController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(5),
                              filled: true,
                              hintStyle: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              hintText: (isURL(inputController.text))
                                  ? "Press the ShortenMyURL button"
                                  : "A short URL will appear here",
                              // fillColor: Colors.white12,
                            ),
                            style: TextStyle(
                              color: (outputController.text.contains("is.gd"))
                                  ? Colors.lightBlue[200]
                                  : Colors.red[200],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 3,
                        // ),
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
                          ),
                        ),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: outputController.text.isNotEmpty,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Tooltip(
                                message: "Open the shortened URL in a browser",
                                child: InkWell(
                                  child: Icon(
                                    Icons.open_in_browser_outlined,
                                    size: 35,
                                    color: Colors.grey[200],
                                  ),
                                  onTap: () {
                                    // open shortened URL in browser
                                    // API.openURL(outputController.text);
                                    debugPrint(
                                        "Opening URL in browser: $shortURL");
                                    debugPrint(
                                        "screenWidth: $screenWidth , screenHeight: $screenHeight");
                                    launchUrl(
                                      Uri.parse(currentShortURL),
                                    );
                                  },
                                ),
                              ),
                              Tooltip(
                                message: "Copy the shortened URL to clipboard",
                                child: Builder(
                                  builder: (context) => InkWell(
                                    child: Icon(
                                      Icons.copy_outlined,
                                      size: 35,
                                      color: Colors.grey[200],
                                    ),
                                    onTap: () async {
                                      Clipboard.setData(new ClipboardData(
                                              text: outputController.text))
                                          .then(
                                        (result) {
                                          HapticFeedback.mediumImpact();
                                          final snackBar = SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                    },
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: "Share the shortened URL",
                                child: Container(
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.006,
                  ),
                  // Session history container
                  Expanded(
                    // padding: (screenHeight < 750)
                    //     ? EdgeInsets.only(top: 35, left: 10, right: 10)
                    //     : EdgeInsets.only(top: 55, left: 10, right: 10),
                    // color: Colors.pink[100],

                    // height: screenHeight * 0.5,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Session History ",
                              style: TextStyle(
                                  color: Colors.teal[100],
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                            Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: longURLs.isNotEmpty,
                              child: InkWell(
                                child: Tooltip(
                                  message: "Clear session history",
                                  child: Icon(
                                    Icons.delete_sweep,
                                    size: 30,
                                    color: Colors.teal[100],
                                  ),
                                ),
                                onTap: () => clearURLPairs(),
                              ),
                            )
                          ],
                        ),
                        Text(
                          "$urlPairsCapacity recent URL pairs are shown below. These will be cleared automatically by your device unless deleted manually.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // SizedBox(
                        //   height: 6,
                        // ),
                        Flexible(
                          child: Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible:
                                (longURLs.isNotEmpty && shortURLs.isNotEmpty),
                            child: Scrollbar(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(0),
                                  itemCount: longURLs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${(index - longURLs.length).abs()}.    ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal[100]),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SelectableText(
                                                  '${longURLs[index]}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors
                                                          .lightGreen[200]),
                                                ),
                                                SelectableText(
                                                  '${shortURLs[index]}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: (shortURLs[index]
                                                              .contains(
                                                                  "is.gd"))
                                                          ? Colors
                                                              .lightBlue[200]
                                                          : Colors.red[200]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.006,
                  ),
                  // App info row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nocturnal Dev Lab (RT) © 2020-${DateTime.now().year}",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 10,
                            fontWeight: FontWeight.w300),
                      ),
                      Tooltip(
                        message: '$appDisclaimer',
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: Colors.grey[800],
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
