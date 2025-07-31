import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo EXO di atas
            Center(
              child: Image.asset(
                'assets/images/exo.jpg',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'EXO Lyrics',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Selamat datang di EXO Lyrics — aplikasi yang dirancang khusus untuk para EXO-L 💫',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              '✨ Fitur Unggulan ✨',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const FeatureBullet(
                text: '🎵 Dengarkan lagu EXO, sub-unit & solo favoritmu'),
            const FeatureBullet(
                text: '📝 Lirik lagu yang sinkron dan bergaya Spotify'),
            const FeatureBullet(text: '❤️ Tandai lagu favoritmu dengan mudah'),
            const FeatureBullet(
                text: '🖤 Tampilan simpel, elegan, dan responsif'),
            const SizedBox(height: 24),
            const Text(
              '📱 Tentang Pengembang',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Versi Aplikasi: 1.0.0',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Terima kasih telah menggunakan EXO Lyrics. Jangan lupa share ke sesama EXO-L ya! 💚',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureBullet extends StatelessWidget {
  final String text;
  const FeatureBullet({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.check_circle, color: Colors.greenAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
