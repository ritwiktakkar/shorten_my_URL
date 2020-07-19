import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shorten_my_URL/url_model.dart' as url_model;
import 'package:shorten_my_URL/api_requests.dart' as API;
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';
import 'package:shorten_my_URL/dialogs.dart';
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
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug banner from top left
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<url_model.ShortenedURL> shortenedURL;

  // Create a text controller and use it to retrieve the current value of the TextField.
  final inputController = TextEditingController();
  final outputController = TextEditingController();

  String longURL;
  url_model.ShortenedURL shortURL;

  Future<String> _getFromClipboard() async {
    Map<String, dynamic> result =
        await SystemChannels.platform.invokeMethod('Clipboard.getData');
    if (result != null) {
      debugPrint('Clipboard content: \'${result['text'].toString()}\'');
      if (isURL(result['text'].toString())) {
        return result['text'].toString();
      }
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black, // make background color black
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 1),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Input URL",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700)),
                      Tooltip(
                        message:
                            'Type or paste a link from your clipboard in the input URL field below. Hold any of the buttons to see instructions.',
                        showDuration: Duration(seconds: 10),
                        textStyle: TextStyle(color: Colors.white),
                        child: Icon(
                          Icons.help,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
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
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      hintText: "Enter the URL to shorten here",
                      fillColor: Colors.white12),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              //SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 80,
                    child: Tooltip(
                      message: "Clear input field",
                      child: FlatButton(
                        onPressed: () {
                          inputController.text = '';
                        },
                        color: Colors.lightGreen[700],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AutoSizeText(
                              "Clear",
                              textAlign: TextAlign.center,
                              // minFontSize: 10,
                              // maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AutoSizeText(
                              "Input",
                              textAlign: TextAlign.center,
                              // minFontSize: 10,
                              // maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          //side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 80,
                    child: Tooltip(
                      message: "Paste clipboard content to input field",
                      child: FlatButton(
                        onPressed: () async {
                          inputController.text = await _getFromClipboard();
                          if (isURL(inputController.text)) {
                            longURL = inputController.text;
                          } else {
                            // print below if paste button returns empty string
                            debugPrint("Clipboard doesn't contain valid URL.");
                            // show dialog
                            Dialogs.showNothingToPaste(context);
                          }
                        },
                        color: Colors.cyan[700],
                        child: AutoSizeText(
                          "Paste",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          // minFontSize: 10,
                          // maxFontSize: 20,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          //side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 80,
                    child: Tooltip(
                      message: "Shorten URL in input field",
                      child: FlatButton(
                        onPressed: () async {
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
                              shortURL = await API.getShortenedURL(longURL);
                              if (shortURL == null) {
                                Dialogs.showShorteningURLError(context);
                              }
                              outputController.text = shortURL.shortenedURL;
                            }
                          } else {
                            Dialogs.showInvalidInput(context);
                          }
                        },
                        color: Colors.blue[700],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AutoSizeText(
                              "Shorten",
                              textAlign: TextAlign.center,
                              // minFontSize: 10,
                              // maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AutoSizeText(
                              "URL",
                              textAlign: TextAlign.center,
                              // minFontSize: 10,
                              // maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                //height: 10,
                color: Colors.grey[800],
                thickness: 2,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Output URL",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700)),
                      Tooltip(
                        message:
                            'If your input URL is successfully shortened, your short URL will appear in the output URL field below. Hold any of the buttons to see instructions.',
                        showDuration: Duration(seconds: 10),
                        textStyle: TextStyle(color: Colors.white),
                        child: Icon(
                          Icons.help,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5,
                ),
                child: TextField(
                  readOnly: true,
                  controller: outputController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(40.0),
                        ),
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      hintText: "The shortened URL will appear here",
                      fillColor: Colors.white12),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 80,
                    child: Tooltip(
                      message: "Clear output field",
                      child: FlatButton(
                        onPressed: () {
                          outputController.text = '';
                        },
                        color: Colors.lightGreen[700],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AutoSizeText(
                              "Clear",
                              textAlign: TextAlign.center,
                              // minFontSize: 10,
                              // maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AutoSizeText(
                              "Output",
                              textAlign: TextAlign.center,
                              // minFontSize: 10,
                              // maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 80,
                    child: Tooltip(
                      message: "Copy shortened URL to clipboard",
                      child: FlatButton(
                        onPressed: () async {
                          if (isURL(outputController.text)) {
                            Clipboard.setData(
                                new ClipboardData(text: outputController.text));
                            // TODO: add message for user to see that content has been copied successfully
                          } else {
                            // show dialog
                            Dialogs.showNothingToCopy(context);
                          }
                        },
                        color: Colors.cyan[700],
                        child: AutoSizeText(
                          "Copy",
                          // minFontSize: 10,
                          // maxFontSize: 20,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          //side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 80,
                    child: Tooltip(
                      message: "Share the shortened URL",
                      child: FlatButton(
                        onPressed: () async {
                          if (isURL(outputController.text)) {
                            Share.share(outputController.text);
                          } else {
                            Dialogs.showNothingToShare(context);
                          }
                        },
                        color: Colors.blue[700],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AutoSizeText(
                              "Share",
                              textAlign: TextAlign.center,
                              // minFontSize: 10,
                              // maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AutoSizeText(
                              "URL",
                              textAlign: TextAlign.center,
                              // minFontSize: 10,
                              // maxFontSize: 20,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
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
    );
  }
}
