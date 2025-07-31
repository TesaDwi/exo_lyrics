class Song {
  final String title;
  final String album;
  final String audioPath;
  final String coverPath;
  final String lyricsPath;
  final String channelTitle;

  Song({
    required this.title,
    required this.album,
    required this.audioPath,
    required this.coverPath,
    required this.lyricsPath,
    required this.channelTitle,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      album: json['album'],
      audioPath: json['audioPath'],
      coverPath: json['coverPath'],
      lyricsPath: json['lyricsPath'],
      channelTitle: json['channelTitle'],
    );
  }
}
