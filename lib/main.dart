import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const CosmicMusicPlayer());
}

class CosmicMusicPlayer extends StatelessWidget {
  const CosmicMusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Music Player',
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
