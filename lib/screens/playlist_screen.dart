import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/audio/audio_provider.dart';
import '../widgets/glass_container.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
    final themeType = themeProvider.currentTheme;
    final primaryColor = MusicTheme.getPrimaryColor(themeType);
    final textColor = MusicTheme.getTextColor(themeType);

    final songs = audioProvider.songs;

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
                      color: textColor.withValues(alpha: 0.5),
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
                    '${songs.length} tracks',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: textColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => audioProvider.pickAndAddSongs(),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add MP3 Files'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (songs.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () {
                        if (songs.isNotEmpty) {
                          audioProvider.playSong(0);
                        }
                      },
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('Play All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        foregroundColor: textColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: songs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note, size: 64, color: textColor.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Text(
                            'No songs yet',
                            style: GoogleFonts.inter(fontSize: 16, color: textColor.withValues(alpha: 0.5)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap "Add MP3 Files" to get started',
                            style: GoogleFonts.inter(fontSize: 14, color: textColor.withValues(alpha: 0.3)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        final isCurrent = audioProvider.currentIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => audioProvider.playSong(index),
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
                                        colors: isCurrent
                                            ? [primaryColor, primaryColor.withValues(alpha: 0.7)]
                                            : [primaryColor.withValues(alpha: 0.5), MusicTheme.getSecondaryColor(themeType).withValues(alpha: 0.3)],
                                      ),
                                    ),
                                    child: Icon(
                                      isCurrent && audioProvider.isPlaying ? Icons.volume_up : Icons.music_note,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          song.title,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isCurrent ? primaryColor : textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          song.artist,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: textColor.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    song.durationText,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: textColor.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 16),
                                    color: textColor.withValues(alpha: 0.4),
                                    onPressed: () => audioProvider.removeSong(index),
                                  ),
                                ],
                              ),
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
