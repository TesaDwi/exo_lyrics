import '../models/song.dart';

class FavoriteSongs {
  static final FavoriteSongs _instance = FavoriteSongs._internal();
  factory FavoriteSongs() => _instance;

  FavoriteSongs._internal();

  final List<Song> _favorites = [];

  List<Song> get favorites => List.unmodifiable(_favorites);

  void add(Song song) {
    if (!_favorites.any((s) => s.title == song.title)) {
      _favorites.add(song);
    }
  }

  void remove(Song song) {
    _favorites.removeWhere((s) => s.title == song.title);
  }

  bool isFavorite(Song song) {
    return _favorites.any((s) => s.title == song.title);
  }

  void toggle(Song song) {
    isFavorite(song) ? remove(song) : add(song);
  }
}
