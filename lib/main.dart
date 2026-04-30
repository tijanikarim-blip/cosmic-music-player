import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/music_theme.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const CosmicMusicPlayer(),
    ),
  );
}

class CosmicMusicPlayer extends StatelessWidget {
  const CosmicMusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Cosmic Music Player',
          debugShowCheckedModeBanner: false,
          theme: MusicTheme.getTheme(themeProvider.currentTheme),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
