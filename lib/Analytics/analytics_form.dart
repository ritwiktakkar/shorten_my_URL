import 'package:shorten_my_url/Analytics/device_form.dart';
import 'package:shorten_my_url/Analytics/url_form.dart';

class AnalyticsForm {
  UrlForm urlForm;
  DeviceForm deviceForm;

  AnalyticsForm(this.urlForm, this.deviceForm);

  Map toJson() => {
        'longURL': urlForm.longURL,
        'shortURL': urlForm.shortURL,
        'deviceName': deviceForm.deviceName,
        'deviceVersion': deviceForm.deviceVersion,
        'appVersion': deviceForm.appVersion,
        'identifier': deviceForm.identifier
      };
}
