import 'package:flutter/material.dart';
import 'package:shorten_my_URL/url_model.dart' as url_model;
import 'package:shorten_my_URL/api_requests.dart' as API;
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug banner from top left
      home: Scaffold(
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
                  child: Text("Input",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700)),
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
                    Container(
                      height: 80,
                      width: 120,
                      child: FlatButton(
                        onPressed: () async {
                          inputController.text = await _getFromClipboard();
                          if (await _getFromClipboard() == '') {
                            // print below if paste button returns empty string
                            print("Clipboard doesn't contain valid URL.");
                          } else {
                            longURL = inputController.text;
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
                    Container(
                      height: 80,
                      width: 120,
                      child: FlatButton(
                        onPressed: () async {
                          shortURL = await API.getShortenedURL(longURL);
                          outputController.text = shortURL.shortenedURL;
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
                  ],
                ),
                Divider(
                  //height: 10,
                  color: Colors.grey[800],
                  thickness: 5,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Output",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700)),
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
                          //side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 120,
                      child: FlatButton(
                        onPressed: () async {
                          inputController.text = await _getFromClipboard();
                          if (await _getFromClipboard() == '') {
                            // print below if paste button returns empty string
                            print("Clipboard doesn't contain valid URL.");
                          } else {
                            longURL = inputController.text;
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
                    Container(
                      height: 80,
                      width: 120,
                      child: FlatButton(
                        onPressed: () {},
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
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
