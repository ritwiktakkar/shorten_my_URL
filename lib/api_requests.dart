import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shorten_my_URL/url_model.dart';
import 'package:shorten_my_URL/dialogs.dart';
import 'dart:convert';

var postURL = 'https://cleanuri.com/api/v1/shorten';

Future<ShortenedURL> getShortenedURL(String longURL) async {
  final response = await http.post(postURL, body: {'url': longURL});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    debugPrint(response.body.toString());
    //debugPrint(response.body.toString());
    return ShortenedURL.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    debugPrint('Failed to shorten URL');
    return null;
  }
}
