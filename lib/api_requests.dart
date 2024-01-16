import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorten_my_url/Analytics/analytics_form.dart';
import 'package:shorten_my_url/Analytics/device_form.dart';
import 'package:shorten_my_url/Analytics/url_form.dart';
// import 'package:shorten_my_url/url_model.dart';
import 'package:shorten_my_url/Analytics/constants.dart';
import 'dart:convert' as convert;

final isgdAPI = 'https://is.gd/create.php?format=simple&url='; // option 1
final cleanuriURL = 'https://cleanuri.com/api/v1/shorten'; // option 2
String gsURL = Constants.gs_url;

// Async funtion which gets shortened URL
Future<String?> getShortenedURL(String longURL) async {
  var response = await http.post(Uri.parse("$isgdAPI$longURL"));

  // set initial values for analytics
  DeviceForm deviceForm = await deviceDetails();

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    debugPrint('200 response.body.toString(): ${response.body.toString()}');
    if (response.body.toString().contains('Error')) {
      response = await http.post(Uri.parse(cleanuriURL), body: {
        'url': longURL,
      });
    }
    try {
      String shortURL = '';
      if (response.body.toString().contains('cleanuri.com')) {
        shortURL = convert.jsonDecode(response.body)['result_url'];
      } else {
        shortURL = response.body.toString();
      }
      debugPrint('shortenedURL: $shortURL');

      UrlForm urlForm = UrlForm(longURL, shortURL);
      AnalyticsForm analyticsForm = AnalyticsForm(urlForm, deviceForm);
      submitAnalytics(analyticsForm, (String response) {});
      return shortURL;
    } on Exception {
      debugPrint('Exception');
      return null;
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    debugPrint('not 200 response.body.toString(): ${response.body.toString()}');
    submitAnalytics(
        AnalyticsForm(UrlForm(longURL, ""), deviceForm), (String response) {});
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
    // debugPrint(e as String?);
  }
}

// Async function which gets device details for analytics
Future<DeviceForm> deviceDetails() async {
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String appVersion = '';

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  try {
    appVersion = packageInfo.version;
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
    // debugPrint('Failed to get platform version');
  }
  // debugPrint('Device Name: $deviceName\n'
  //     'Device Version: $deviceVersion\n'
  //     'Device Identifier: $identifier\n'
  //     'App Version: $appVersion');
  return DeviceForm(deviceName, deviceVersion, identifier, appVersion);
}
