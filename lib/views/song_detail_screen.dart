import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../utils/favorite_songs.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({super.key, required this.song});

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
  StreamSubscription<Duration>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _isFavorited = FavoriteSongs().isFavorite(widget.song);
    _initAudio();
    _loadLrc();
  }

  Future<void> _initAudio() async {
    await _player.setAsset(widget.song.audioPath);
    _player.play();
    _positionSubscription = _player.positionStream.listen((position) {
      _updateCurrentLine(position);
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_isRepeating) {
          _player.seek(Duration.zero);
          _player.play();
        } else if (_isShuffling) {
          _player.seek(Duration.zero);
          setState(() {
            _currentLine = _getRandomLineIndex();
            _scrollToLine(_currentLine);
          });
        }
      }
    });
  }

  Future<void> _loadLrc() async {
    final rawLrc = await rootBundle.loadString(widget.song.lyricsPath);
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
      if (i == _lyrics.length - 1) {
        setState(() {
          _currentLine = _lyrics.length - 1;
        });
        _scrollToLine(_currentLine);
      }
    }
  }

  void _scrollToLine(int index) {
    final position = index * 40.0;
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  int _getRandomLineIndex() {
    if (_lyrics.length <= 1) return 0;
    final random = _lyrics.toList()..shuffle();
    return _lyrics.indexOf(random.first);
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
      FavoriteSongs().toggle(widget.song);
    });
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffling = !_isShuffling;
    });
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeating = !_isRepeating;
    });
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.song.title),
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(widget.song.coverPath, height: 220),
          ),
          const SizedBox(height: 20),
          IconButton(
            iconSize: 64,
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: Colors.white,
            ),
            onPressed: _togglePlayPause,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shuffle,
                    color: _isShuffling ? Colors.green : Colors.white),
                onPressed: _toggleShuffle,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.repeat,
                    color: _isRepeating ? Colors.green : Colors.white),
                onPressed: _toggleRepeat,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _lyrics.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _lyrics.length,
                    itemBuilder: (context, index) {
                      final isActive = index == _currentLine;
                      final line = _lyrics[index];
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              fontSize: isActive ? 20 : 16,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isActive ? Colors.white : Colors.white60,
                            ),
                            child: Text(line.text, textAlign: TextAlign.center),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _LrcLine {
  final Duration timestamp;
  final String text;

  _LrcLine(this.timestamp, this.text);
}
