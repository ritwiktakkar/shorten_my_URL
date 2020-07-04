import 'package:flutter/material.dart';
import 'package:shorten_my_URL/url_model.dart' as url_model;
import 'package:shorten_my_URL/api_requests.dart' as API;
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';
import 'package:shorten_my_URL/dialogs.dart';
import 'package:share/share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      print('Clipboard content: \'${result['text'].toString()}\'');
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
      backgroundColor: Colors.black, // make background color black
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 1),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Input",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            //SizedBox(height: 30),
            TextField(
              autocorrect: false, // URL so no need
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
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                  hintText: "Enter the URL that you want to shorten here",
                  fillColor: Colors.white12),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            //SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: 80,
                  width: 120,
                  child: Tooltip(
                    message: "Clear input field",
                    child: FlatButton(
                      onPressed: () {
                        inputController.text = '';
                      },
                      color: Colors.lightGreen[700],
                      child: Text(
                        "Clear Input",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
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
                  height: 80,
                  width: 120,
                  child: Tooltip(
                    message: "Paste clipboard content to input field",
                    child: FlatButton(
                      onPressed: () async {
                        inputController.text = await _getFromClipboard();
                        if (isURL(inputController.text)) {
                          longURL = inputController.text;
                        } else {
                          // print below if paste button returns empty string
                          print("Clipboard doesn't contain valid URL.");
                          // show dialog
                          Dialogs.showNothingToPaste(context);
                        }
                      },
                      color: Colors.cyan[700],
                      child: Text(
                        "Paste",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
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
                  height: 80,
                  width: 120,
                  child: Tooltip(
                    message: "Shorten URL in input field",
                    child: FlatButton(
                      onPressed: () async {
                        if (isURL(inputController.text)) {
                          longURL = inputController.text;
                          shortURL = await API.getShortenedURL(longURL);
                          outputController.text = shortURL.shortenedURL;
                        } else {
                          Dialogs.showInvalidInput(context);
                        }
                      },
                      color: Colors.blue[700],
                      child: Text(
                        "Shorten URL",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
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
              thickness: 5,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Output",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            TextField(
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
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                  hintText: "Your shortened URL will appear here",
                  fillColor: Colors.white12),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: 80,
                  width: 120,
                  child: Tooltip(
                    message: "Clear output field",
                    child: FlatButton(
                      onPressed: () {
                        outputController.text = '';
                      },
                      color: Colors.lightGreen[700],
                      child: Text(
                        "Clear Output",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: 120,
                  child: Tooltip(
                    message: "Copy shortened URL to clipboard",
                    child: FlatButton(
                      onPressed: () async {
                        if (isURL(outputController.text)) {
                          Clipboard.setData(
                              new ClipboardData(text: outputController.text));
                        } else {
                          // show dialog
                          Dialogs.showNothingToCopy(context);
                        }
                      },
                      color: Colors.cyan[700],
                      child: Text(
                        "Copy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
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
                  height: 80,
                  width: 120,
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
                      child: Text(
                        "Share URL",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
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
    );
  }
}
