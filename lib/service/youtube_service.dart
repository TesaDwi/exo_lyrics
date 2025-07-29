import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exo_lyrics/widgets/song_card.dart';

class YouTubeService {
  static const String apiKey = 'AIzaSyBDwcfXjGHRkQhcYi_4u2jcHpNSjd7NTeg';
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3/search';

  static Future<List<Song>> fetchSongs(String query) async {
    final url = Uri.parse(
        '$baseUrl?part=snippet&q=$query&type=video&maxResults=10&key=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['items'] as List)
          .map((item) => Song.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }
}
