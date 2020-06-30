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
      debugShowCheckedModeBanner: false, // hide debug banner from top left
      home: Scaffold(
        backgroundColor: Colors.black, // make background color black
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
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
                  hintText: "Enter the URL that you want to shorten here",
                  fillColor: Colors.white12),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        )),
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
