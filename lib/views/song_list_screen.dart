import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/song.dart';
import '../utils/favorite_songs.dart';
import 'song_detail_screen.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final String response =
        await rootBundle.loadString('assets/exo_songs.json');
    final List<dynamic> data = json.decode(response);
    final loadedSongs = data.map((json) => Song.fromJson(json)).toList();

    setState(() {
      songs = loadedSongs;
    });

    await FavoriteSongs().loadFavorites(songs); // Load favorit tersimpan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EXO Song List'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: songs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      song.coverPath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    song.album,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Icon(
                    FavoriteSongs().isFavorite(song)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: FavoriteSongs().isFavorite(song)
                        ? Colors.red
                        : Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SongDetailScreen(
                          playlist: songs,
                          initialIndex: index,
                        ),
                      ),
                    ).then((_) => setState(() {})); // Refresh setelah kembali
                  },
                );
              },
            ),
    );
  }
}
