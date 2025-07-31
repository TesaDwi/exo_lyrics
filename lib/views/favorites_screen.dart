import 'package:flutter/material.dart';
import '../utils/favorite_songs.dart';
import '../models/song.dart';
import 'song_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Song> favorites = FavoriteSongs().favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      backgroundColor: Colors.black,
      body: favorites.isEmpty
          ? const Center(
              child: Text('Belum ada lagu favorit',
                  style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final song = favorites[index];
                return ListTile(
                  leading: Image.asset(song.coverPath,
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(song.title,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song.album,
                      style: const TextStyle(color: Colors.white60)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SongDetailScreen(
                          playlist: favorites,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
