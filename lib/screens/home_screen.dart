import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onSongTap;
  const HomeScreen({super.key, this.onSongTap});

  static const List<Map<String, dynamic>> _playlists = [
    {'name': 'Chill Vibes', 'count': 23},
    {'name': 'Night Drive', 'count': 18},
    {'name': 'Focus Mode', 'count': 32},
    {'name': 'Cosmic Journey', 'count': 14},
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
                            color: textColor.withOpacity(0.6),
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

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: textColor.withOpacity(0.5), size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Search your music',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: textColor.withOpacity(0.4),
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
                'Categories',
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
                    sublabel: '128 Songs',
                    color: primaryColor,
                    textColor: textColor,
                  ),
                  const SizedBox(width: 12),
                  _buildCategory(
                    icon: Icons.favorite,
                    label: 'Favorites',
                    sublabel: '34 Songs',
                    color: Colors.redAccent,
                    textColor: textColor,
                  ),
                  const SizedBox(width: 12),
                  _buildCategory(
                    icon: Icons.history,
                    label: 'Recent',
                    sublabel: '24 Songs',
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
                    'Playlists',
                    style: GoogleFonts.orbitron(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'See all',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Playlist list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  ..._playlists.map((pl) => _buildPlaylistItem(
                    name: pl['name'],
                    count: pl['count'],
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    textColor: textColor,
                    themeType: themeType,
                    onTap: onSongTap,
                  )),
                  const SizedBox(height: 12),
                  // Now Playing mini bar
                  GlassContainer(
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
                              colors: [primaryColor.withOpacity(0.7), secondaryColor.withOpacity(0.5)],
                            ),
                          ),
                          child: Icon(Icons.music_note, color: Colors.white70, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Beyond the Horizon',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'Luna Orbit',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.skip_previous, color: textColor.withOpacity(0.7), size: 22),
                        const SizedBox(width: 4),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                            boxShadow: [MusicTheme.neonShadow(primaryColor, blurRadius: 8)],
                          ),
                          child: const Icon(Icons.pause, color: Colors.black, size: 18),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.skip_next, color: textColor.withOpacity(0.7), size: 22),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
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
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
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
                color: textColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistItem({
    required String name,
    required int count,
    required Color primaryColor,
    required Color secondaryColor,
    required Color textColor,
    required MusicThemeType themeType,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
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
                  colors: [primaryColor.withOpacity(0.5), secondaryColor.withOpacity(0.3)],
                ),
              ),
              child: Icon(Icons.queue_music, color: Colors.white70, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '$count Songs',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.15),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Icon(Icons.play_arrow, color: primaryColor, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
