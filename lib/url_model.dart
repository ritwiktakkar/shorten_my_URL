class ShortenedURL {
  final String? shortenedURL;

  ShortenedURL({required this.shortenedURL});

  factory ShortenedURL.fromJson(Map<String, dynamic> json) {
    return ShortenedURL(
      shortenedURL: json['result_url'],
    );
  }
}
