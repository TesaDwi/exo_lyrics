import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../utils/favorite_songs.dart';

class SongDetailScreen extends StatefulWidget {
  final List<Song> playlist;
  final int initialIndex;

  const SongDetailScreen({
    super.key,
    required this.playlist,
    required this.initialIndex,
  });

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  final ScrollController _scrollController = ScrollController();
  List<_LrcLine> _lyrics = [];
  int _currentLine = 0;
  bool _isPlaying = true;
  bool _isFavorited = false;
  bool _isShuffling = false;
  bool _isRepeating = false;
  late int _currentIndex;
  late Song _currentSong;
  StreamSubscription<Duration>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _currentSong = widget.playlist[_currentIndex];
    _isFavorited = FavoriteSongs().isFavorite(_currentSong);
    _playCurrentSong();
  }

  Future<void> _playCurrentSong() async {
    await _player.setAsset(_currentSong.audioPath);
    _player.play();
    _positionSubscription?.cancel();
    _positionSubscription = _player.positionStream.listen((position) {
      _updateCurrentLine(position);
    });
    _loadLrc();
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _loadLrc() async {
    final rawLrc = await rootBundle.loadString(_currentSong.lyricsPath);
    final parsed = _parseLrc(rawLrc);
    setState(() {
      _lyrics = parsed;
    });
  }

  List<_LrcLine> _parseLrc(String raw) {
    final regex = RegExp(r'\[(\d+):(\d+\.\d+)\](.*)');
    final lines = raw.split('\n');
    return lines
        .map((line) {
          final match = regex.firstMatch(line);
          if (match != null) {
            final minutes = int.parse(match.group(1)!);
            final seconds = double.parse(match.group(2)!);
            final time = Duration(
                minutes: minutes, milliseconds: (seconds * 1000).toInt());
            final text = match.group(3)!.trim();
            return _LrcLine(time, text);
          }
          return null;
        })
        .whereType<_LrcLine>()
        .toList();
  }

  void _scrollToLine(int index) {
    final lineHeight = 36.0;
    final offset = (index * lineHeight) - 200;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateCurrentLine(Duration position) {
    for (int i = 0; i < _lyrics.length; i++) {
      if (position < _lyrics[i].timestamp) {
        final newIndex = i - 1 < 0 ? 0 : i - 1;
        if (newIndex != _currentLine) {
          setState(() {
            _currentLine = newIndex;
          });
          _scrollToLine(_currentLine);
        }
        break;
      }
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
      FavoriteSongs().toggle(_currentSong);
    });
  }

  void _nextSong() {
    setState(() {
      if (_isShuffling) {
        final otherIndexes = List.generate(widget.playlist.length, (i) => i)
          ..remove(_currentIndex);
        otherIndexes.shuffle();
        _currentIndex = otherIndexes.first;
      } else {
        _currentIndex = (_currentIndex + 1) % widget.playlist.length;
      }
      _currentSong = widget.playlist[_currentIndex];
      _isFavorited = FavoriteSongs().isFavorite(_currentSong);
    });
    _playCurrentSong();
  }

  void _previousSong() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.playlist.length) % widget.playlist.length;
      _currentSong = widget.playlist[_currentIndex];
      _isFavorited = FavoriteSongs().isFavorite(_currentSong);
    });
    _playCurrentSong();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _player.dispose();
    _positionSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Tombol kembali
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // Gambar kecil + Info lagu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(_currentSong.coverPath,
                        width: 48, height: 48, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_currentSong.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        Text(_currentSong.channelTitle,
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 14)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorited ? Colors.red : Colors.white,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
            ),

            // Lirik
            Expanded(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.4, 0.6, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _lyrics.length,
                  itemBuilder: (context, index) {
                    final isActive = index == _currentLine;
                    final line = _lyrics[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: isActive ? 20 : 16,
                            color: isActive ? Colors.white : Colors.white54,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                          child: Text(line.text),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Progress
            StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _player.duration ?? Duration.zero;
                return Column(
                  children: [
                    Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.white24,
                      value: position.inMilliseconds
                          .toDouble()
                          .clamp(0.0, duration.inMilliseconds.toDouble()),
                      max: duration.inMilliseconds.toDouble() > 0
                          ? duration.inMilliseconds.toDouble()
                          : 1,
                      onChanged: (value) {
                        _player.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(position),
                              style: const TextStyle(color: Colors.white70)),
                          Text(_formatDuration(duration),
                              style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // Kontrol Musik
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.shuffle,
                        color: _isShuffling ? Colors.blue : Colors.white),
                    onPressed: () {
                      setState(() {
                        _isShuffling = !_isShuffling;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    iconSize: 32,
                    onPressed: _previousSong,
                  ),
                  IconButton(
                    icon: Icon(
                        _isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: Colors.white),
                    iconSize: 48,
                    onPressed: _togglePlayPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    iconSize: 32,
                    onPressed: _nextSong,
                  ),
                  IconButton(
                    icon: Icon(Icons.repeat,
                        color: _isRepeating ? Colors.blue : Colors.white),
                    onPressed: () {
                      setState(() {
                        _isRepeating = !_isRepeating;
                        _player.setLoopMode(
                          _isRepeating ? LoopMode.one : LoopMode.off,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LrcLine {
  final Duration timestamp;
  final String text;

  _LrcLine(this.timestamp, this.text);
}
