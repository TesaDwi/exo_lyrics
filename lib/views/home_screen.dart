import 'package:flutter/material.dart';
import '../widgets/song_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> exoSongs = const [
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

  final List<Map<String, String>> subUnitSongs = const [
    {
      'title': 'What U do?',
      'album': 'EXO-CBX - Blooming Days',
      'image': 'assets/cbx.jpg',
    },
    {
      'title': 'The One',
      'album': 'EXO-SC - 1 Billion Views',
      'image': 'assets/sc.jpg',
    },
  ];

  final List<Map<String, String>> soloSongs = const [
    {
      'title': 'Candy',
      'album': 'Baekhyun - Delight',
      'image': 'assets/baekhyun_candy.jpg',
    },
    {
      'title': 'Rose',
      'album': 'D.O. - Empathy',
      'image': 'assets/do_rose.jpg',
    },
    {
      'title': 'On the Snow',
      'album': 'Chen - Dear My Dear',
      'image': 'assets/chen_snow.jpg',
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
                  itemCount: exoSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final song = exoSongs[index];
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
                  itemCount: exoSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final song = exoSongs[index];
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
                  itemCount: subUnitSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final song = subUnitSongs[index];
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
                  itemCount: soloSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final song = soloSongs[index];
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
