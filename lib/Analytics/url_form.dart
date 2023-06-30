class UrlForm {
  String longURL;
  String shortURL;

  UrlForm(this.longURL, this.shortURL);

  Map toJson() => {'longURL': longURL, 'shortURL': shortURL};
}
