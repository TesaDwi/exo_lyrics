import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

class FavoriteSongs {
  static final FavoriteSongs _instance = FavoriteSongs._internal();
  factory FavoriteSongs() => _instance;
  FavoriteSongs._internal();

  final List<Song> _favorites = [];
  List<Song> get favorites => List.unmodifiable(_favorites);

  Future<void> loadFavorites(List<Song> allSongs) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteTitles = prefs.getStringList('favorite_titles');

    if (favoriteTitles != null) {
      _favorites.clear();
      _favorites.addAll(
          allSongs.where((song) => favoriteTitles.contains(song.title)));
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final titles = _favorites.map((s) => s.title).toList();
    await prefs.setStringList('favorite_titles', titles);
  }

  void toggle(Song song) {
    if (isFavorite(song)) {
      _favorites.removeWhere((s) => s.title == song.title);
    } else {
      _favorites.add(song);
    }
    _saveFavorites();
  }

  bool isFavorite(Song song) {
    return _favorites.any((s) => s.title == song.title);
  }
}
