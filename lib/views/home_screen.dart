import 'package:flutter/material.dart';
import '../widgets/song_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> popularSongs = const [
    {
      'title': 'Love Shot',
      'album': 'Love Shot',
      'image': 'assets/love_shot.jpg',
    },
    {
      'title': 'Growl',
      'album': 'XOXO',
      'image': 'assets/growl.jpg',
    },
    {
      'title': 'Call Me Baby',
      'album': 'EXODUS',
      'image': 'assets/call_me_baby.jpg',
    },
    {
      'title': 'Tempo',
      'album': 'Don’t Mess Up My Tempo',
      'image': 'assets/tempo.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EXO Lyrics'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Popular Songs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final song = popularSongs[index];
                    return SongCard(
                      title: song['title']!,
                      album: song['album']!,
                      image: song['image']!,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Search Song',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter song title...',
                  filled: true,
                  fillColor: Colors.grey[900],
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'EXO',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final song = popularSongs[index];
                    return SongCard(
                      title: song['title']!,
                      album: song['album']!,
                      image: song['image']!,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sub Unit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final song = popularSongs[index];
                    return SongCard(
                      title: song['title']!,
                      album: song['album']!,
                      image: song['image']!,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Solo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final song = popularSongs[index];
                    return SongCard(
                      title: song['title']!,
                      album: song['album']!,
                      image: song['image']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
