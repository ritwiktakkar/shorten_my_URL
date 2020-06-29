import 'package:flutter/material.dart';
import 'package:shorten_my_URL/url_model.dart' as url_model;
import 'package:shorten_my_URL/api_requests.dart' as API;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          body: Padding(
              padding: EdgeInsets.fromLTRB(25, 300, 25, 300),
              child: RaisedButton(
                  onPressed: () async {
                    var result = await API.getShortenedURL(
                        "https://stackoverflow.com/questions/53542904/flutter-calling-futurebuilder-from-a-raised-buttons-onpressed-doesnt-call-the");
                  },
                  child: Text(
                      "press here to shorten url and see in debug console")))),
    );
  }
}
