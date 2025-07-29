import 'package:flutter/material.dart';
import 'package:exo_lyrics/service/youtube_service.dart';
import 'package:exo_lyrics/widgets/song_card.dart';
import 'package:exo_lyrics/widgets/youtube_song_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Song>> exoSongs;
  late Future<List<Song>> subUnitSongs;
  late Future<List<Song>> soloSongs;

  Future<List<Song>>? searchResults;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exoSongs = YouTubeService.fetchSongs('EXO official music');
    subUnitSongs = YouTubeService.fetchSongs('EXO-CBX music OR EXO-SC music');
    soloSongs = YouTubeService.fetchSongs(
        'Baekhyun solo OR D.O. Empathy OR Chen music OR Kai solo OR Suho solo OR Lay Zhang OR Xiumin music');
  }

  void performSearch(String keyword) {
    if (keyword.trim().isEmpty) {
      setState(() {
        searchResults = null;
      });
    } else {
      setState(() {
        searchResults = YouTubeService.fetchSongs(keyword);
      });
    }
  }

  Widget buildSongSection(String title, Future<List<Song>> futureSongs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: FutureBuilder<List<Song>>(
            future: futureSongs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No songs found'));
              } else {
                final songs = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return YouTubeSongCard(song: songs[index]);
                  },
                );
              }
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search Results',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: FutureBuilder<List<Song>>(
            future: searchResults,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No results found'));
              } else {
                final songs = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return YouTubeSongCard(song: songs[index]);
                  },
                );
              }
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EXO Lyrics'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search Song',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: searchController,
                onSubmitted: performSearch,
                textInputAction: TextInputAction.search,
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
              if (searchResults != null) buildSearchResults(),
              buildSongSection('EXO Group', exoSongs),
              buildSongSection('Sub Unit', subUnitSongs),
              buildSongSection('Solo', soloSongs),
            ],
          ),
        ),
      ),
    );
  }
}
