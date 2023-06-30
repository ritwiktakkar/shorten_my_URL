import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shorten_my_url/Analytics/analytics_form.dart';
import 'package:shorten_my_url/Analytics/device_form.dart';
import 'package:shorten_my_url/Analytics/url_form.dart';
import 'package:shorten_my_url/url_model.dart';
import 'package:shorten_my_url/Analytics/constants.dart';
import 'dart:convert' as convert;

var postURL = 'https://cleanuri.com/api/v1/shorten';
String gsURL = Constants.gs_url;

// Async funtion which gets shortened URL
Future<ShortenedURL?> getShortenedURL(String longURL) async {
  final response = await http.post(Uri.parse(postURL), body: {
    'url': longURL,
  });

  // set initial values for analytics
  String longURLAnalytics = longURL;
  String shortURLAnalytics = '';
  UrlForm urlForm = UrlForm(longURLAnalytics, shortURLAnalytics);
  DeviceForm deviceForm = await deviceDetails();
  AnalyticsForm analyticsForm = AnalyticsForm(urlForm, deviceForm);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    debugPrint(response.body.toString());
    // update shortURL for analytics
    ShortenedURL shortenedURL =
        ShortenedURL.fromJson(convert.json.decode(response.body));
    // update urlForm and analyticsForm with successful shortURL
    urlForm = UrlForm(longURLAnalytics, shortenedURL.shortenedURL);
    analyticsForm = AnalyticsForm(urlForm, deviceForm);
    debugPrint(
        "analyticsForm (got shortURL): ${analyticsForm.toJson().toString()}");
    submitAnalytics(analyticsForm, (String response) {
      debugPrint(response);
    });
    return shortenedURL;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    debugPrint(
        "analyticsForm (failed shortURL): ${analyticsForm.toJson().toString()}");
    submitAnalytics(analyticsForm, (String response) {
      debugPrint(response);
    });
    return null;
  }
}

/// Async function which submits analytics
void submitAnalytics(
    AnalyticsForm analyticsForm, void Function(String) callback) async {
  try {
    await http
        .post(Uri.parse(gsURL), body: analyticsForm.toJson())
        .then((response) async {
      if (response.statusCode == 302) {
        var url = response.headers['location'];
        await http.get(Uri.parse(url!)).then((response) {
          callback(convert.jsonDecode(response.body)['status']);
        });
      } else {
        callback(convert.jsonDecode(response.body)['status']);
      }
    });
  } catch (e) {
    debugPrint(e as String?);
  }
}

// Async function which gets device details for analytics
Future<DeviceForm> deviceDetails() async {
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;

      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.androidId;

      //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;

      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor;
    }
  } on PlatformException {
    debugPrint('Failed to get platform version');
  }
  debugPrint('Device Name: $deviceName\n'
      'Device Version: $deviceVersion\n'
      'Device Identifier: $identifier');
  return DeviceForm(deviceName, deviceVersion, identifier);
}
