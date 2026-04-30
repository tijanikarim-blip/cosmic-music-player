import 'package:flutter/material.dart';
import '../core/theme/music_theme.dart';
import 'now_playing_screen.dart';
import 'playlist_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  final MusicThemeType themeType;

  const MainNavigation({super.key, required this.themeType});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      NowPlayingScreen(themeType: widget.themeType),
      PlaylistScreen(themeType: widget.themeType),
      SettingsScreen(themeType: widget.themeType),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MusicTheme.getTheme(widget.themeType),
      child: Scaffold(
        body: PageView(
          controller: PageController(initialPage: _currentIndex),
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Now Playing',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.queue_music),
              label: 'Playlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
