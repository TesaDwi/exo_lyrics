import 'package:html_unescape/html_unescape.dart';

class Song {
  final String title;
  final String thumbnailUrl;
  final String videoId;

  Song({
    required this.title,
    required this.thumbnailUrl,
    required this.videoId,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final unescape = HtmlUnescape();

    return Song(
      title: unescape.convert(snippet['title']),
      thumbnailUrl: snippet['thumbnails']['medium']['url'],
      videoId: json['id']['videoId'],
    );
  }
}
