import 'package:html_unescape/html_unescape.dart';
import 'package:flutter/material.dart';

class Song {
  final String title;
  final String thumbnailUrl;
  final String videoId;
  final String channelTitle;

  Song({
    required this.title,
    required this.thumbnailUrl,
    required this.videoId,
    required this.channelTitle,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final unescape = HtmlUnescape();

    return Song(
      title: unescape.convert(snippet['title']),
      thumbnailUrl: snippet['thumbnails']['medium']['url'],
      videoId: json['id']['videoId'],
      channelTitle: snippet['channelTitle'] ?? 'Unknown',
    );
  }
}

class SongCard extends StatelessWidget {
  final String title;
  final String album;
  final VoidCallback onTap;

  const SongCard({
    super.key,
    required this.title,
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(album),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
