import 'package:flutter/material.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Songs')),
      body: const Center(child: Text('Daftar semua lagu EXO')),
    );
  }
}
