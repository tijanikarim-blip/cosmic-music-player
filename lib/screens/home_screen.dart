import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/audio/audio_provider.dart';
import '../widgets/glass_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ignore: unused_field
  static const List<Map<String, dynamic>> _playlists = [
    {'name': 'Chill Vibes', 'count': 23},
    {'name': 'Night Drive', 'count': 18},
    {'name': 'Focus Mode', 'count': 32},
    {'name': 'Cosmic Journey', 'count': 14},
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
    final themeType = themeProvider.currentTheme;
    final primaryColor = MusicTheme.getPrimaryColor(themeType);
    final textColor = MusicTheme.getTextColor(themeType);
    final secondaryColor = MusicTheme.getSecondaryColor(themeType);

    final songs = audioProvider.songs;
    final currentSong = audioProvider.currentSong;
    final isPlaying = audioProvider.isPlaying;

    return Container(
      decoration: MusicTheme.cosmicBackground(themeType),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Evening',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: textColor.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Welcome Back 👋',
                          style: GoogleFonts.orbitron(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                      ),
                      boxShadow: [MusicTheme.neonShadow(primaryColor, blurRadius: 10)],
                    ),
                    child: const Icon(Icons.person, color: Colors.black, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Stack(
                    children: [
                      Icon(Icons.notifications_outlined, color: textColor, size: 26),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search bar (decorative)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: textColor.withValues(alpha: 0.5), size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Search your music',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: textColor.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Quick Access',
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildCategory(
                    icon: Icons.music_note,
                    label: 'All Songs',
                    sublabel: '${songs.length} Songs',
                    color: primaryColor,
                    textColor: textColor,
                  ),
                  const SizedBox(width: 12),
                  _buildCategory(
                    icon: Icons.favorite,
                    label: 'Favorites',
                    sublabel: '0 Songs',
                    color: Colors.redAccent,
                    textColor: textColor,
                  ),
                  const SizedBox(width: 12),
                  _buildCategory(
                    icon: Icons.history,
                    label: 'Recent',
                    sublabel: '${songs.length} Songs',
                    color: secondaryColor,
                    textColor: textColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Playlists
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Playlist',
                    style: GoogleFonts.orbitron(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => audioProvider.pickAndAddSongs(),
                    child: Text(
                      'Add songs',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Playlist list
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
                          ElevatedButton.icon(
                            onPressed: () => audioProvider.pickAndAddSongs(),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add MP3 Files'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: songs.length > 4 ? 4 : songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return _buildSongItem(
                          title: song.title,
                          artist: song.artist,
                          duration: song.durationText,
                          isPlaying: currentSong == song && isPlaying,
                          primaryColor: primaryColor,
                          textColor: textColor,
                          themeType: themeType,
                          onTap: () => audioProvider.playSong(index),
                        );
                      },
                    ),
            ),

            // Now Playing mini bar (shown when a song is playing)
            if (currentSong != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: GlassContainer(
                  themeType: themeType,
                  borderRadius: 16,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [primaryColor.withValues(alpha: 0.7), secondaryColor.withValues(alpha: 0.5)],
                          ),
                        ),
                        child: Icon(
                          isPlaying ? Icons.volume_up : Icons.music_note,
                          color: Colors.white70,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.title,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              currentSong.artist,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textColor.withValues(alpha: 0.5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => audioProvider.skipPrevious(),
                        child: Icon(Icons.skip_previous, color: textColor.withValues(alpha: 0.7), size: 22),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => audioProvider.togglePlay(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                            boxShadow: [MusicTheme.neonShadow(primaryColor, blurRadius: 8)],
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => audioProvider.skipNext(),
                        child: Icon(Icons.skip_next, color: textColor.withValues(alpha: 0.7), size: 22),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            Text(
              sublabel,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: textColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongItem({
    required String title,
    required String artist,
    required String duration,
    required bool isPlaying,
    required Color primaryColor,
    required Color textColor,
    required MusicThemeType themeType,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPlaying ? primaryColor.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPlaying ? primaryColor.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isPlaying
                      ? [primaryColor.withValues(alpha: 0.7), primaryColor.withValues(alpha: 0.5)]
                      : [primaryColor.withValues(alpha: 0.5), MusicTheme.getSecondaryColor(themeType).withValues(alpha: 0.3)],
                ),
              ),
              child: Icon(
                isPlaying ? Icons.volume_up : Icons.music_note,
                color: Colors.white70,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? primaryColor : textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    artist,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.5),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              duration,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: textColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
