import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  final List<Map<String, String>> _songs = const [
    {'title': 'Cosmic Waves', 'artist': 'Nebula Artist', 'duration': '3:58'},
    {'title': 'Starlight Echo', 'artist': 'Galaxy Band', 'duration': '4:12'},
    {'title': 'Neon Dreams', 'artist': 'Aurora Synth', 'duration': '3:45'},
    {'title': 'Ember Glow', 'artist': 'Fire Wave', 'duration': '5:01'},
    {'title': 'Purple Haze', 'artist': 'Violet Storm', 'duration': '3:30'},
    {'title': 'Solar Flare', 'artist': 'Sun King', 'duration': '4:22'},
    {'title': 'Deep Space', 'artist': 'Void Walker', 'duration': '6:15'},
    {'title': 'Golden Hour', 'artist': 'Eclipse Sound', 'duration': '3:58'},
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeType = themeProvider.currentTheme;
    final primaryColor = MusicTheme.getPrimaryColor(themeType);
    final textColor = MusicTheme.getTextColor(themeType);
    final secondaryColor = MusicTheme.getSecondaryColor(themeType);

    return Container(
      decoration: MusicTheme.cosmicBackground(themeType),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PLAYLIST',
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor.withOpacity(0.5),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cosmic Collection',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_songs.length} tracks',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassContainer(
                      themeType: themeType,
                      borderRadius: 12,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                colors: [primaryColor.withOpacity(0.5), secondaryColor.withOpacity(0.3)],
                              ),
                            ),
                            child: Icon(Icons.music_note, color: textColor.withOpacity(0.7)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song['title']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  song['artist']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: textColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            song['duration']!,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.more_vert, color: textColor.withOpacity(0.5)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
