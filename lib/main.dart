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
  final myController = TextEditingController();

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
    myController.dispose();
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 75,
                      width: 150,
                      child: FlatButton(
                        onPressed: () async {
                          myController.text = await _getFromClipboard();
                        },
                        color: Colors.lightBlue[300],
                        child: Text(
                          "Paste from clipboard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          //side: BorderSide(color: Colors.red),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                TextField(
                  autocorrect: false, // URL so no need
                  controller: myController,
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
                SizedBox(height: 30),
              ],
            ),
          )

          //body:
          // body: Padding(
          //     padding: EdgeInsets.fromLTRB(25, 300, 25, 300),
          //     child: RaisedButton(
          //         onPressed: () async {
          //           var result = await API.getShortenedURL(
          //               "https://stackoverflow.com/questions/53542904/flutter-calling-futurebuilder-from-a-raised-buttons-onpressed-doesnt-call-the");
          //         },
          //         child: Text(
          //             "press here to shorten url and see in debug console")))
          ),
    );
  }
}
