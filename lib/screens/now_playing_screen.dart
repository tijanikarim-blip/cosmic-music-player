import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/neon_glow.dart';
import '../widgets/waveform_visualizer.dart';
import '../widgets/elastic_slider.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  double _progress = 0.35;
  late AnimationController _playButtonController;

  @override
  void initState() {
    super.initState();
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.2,
    );
  }

  @override
  void dispose() {
    _playButtonController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _playButtonController.forward().then((_) => _playButtonController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeType = themeProvider.currentTheme;
    final primaryColor = MusicTheme.getPrimaryColor(themeType);
    final textColor = MusicTheme.getTextColor(themeType);
    final secondaryColor = MusicTheme.getSecondaryColor(themeType);

    final buttonColor = themeType == MusicThemeType.goldenEclipse
        ? const Color(0xFF080600)
        : (themeType == MusicThemeType.emberOdyssey ? const Color(0xFF0D0501) : Colors.black);

    return Stack(
      children: [
        MovingGradientBackground(
          themeType: themeType,
          isPlaying: _isPlaying,
          child: const SizedBox.expand(),
        ),
        CosmicParticles(
          particleColor: primaryColor.withOpacity(0.3),
          isPlaying: _isPlaying,
        ),
        FloatingMusicNotes(
          color: primaryColor,
          isPlaying: _isPlaying,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      color: textColor,
                      onPressed: () {},
                    ),
                    Text(
                      'NOW PLAYING',
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor.withOpacity(0.5),
                        letterSpacing: 2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      color: textColor,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: NeonGlow(
                    glowColor: primaryColor,
                    radius: 24,
                    isPlaying: _isPlaying,
                    child: RotatingAlbumArt(
                      size: 280,
                      isPlaying: _isPlaying,
                      glowColor: primaryColor,
                      child: GlassContainer(
                        themeType: themeType,
                        width: 280,
                        height: 280,
                        borderRadius: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primaryColor.withOpacity(0.3),
                                secondaryColor.withOpacity(0.1)
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.album,
                              size: 80,
                              color: primaryColor.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Cosmic Waves',
                  style: GoogleFonts.orbitron(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nebula Artist',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                WaveformVisualizer(
                  color: primaryColor,
                  secondaryColor: secondaryColor,
                  isPlaying: _isPlaying,
                ),
                const SizedBox(height: 16),
                ElasticSlider(
                  value: _progress,
                  onChanged: (value) => setState(() => _progress = value),
                  activeColor: primaryColor,
                  inactiveColor: primaryColor.withOpacity(0.3),
                  textColor: textColor,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shuffle, color: textColor.withOpacity(0.7)),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_previous, color: textColor, size: 36),
                      onPressed: () {},
                    ),
                    GestureDetector(
                      onTap: _togglePlay,
                      child: AnimatedBuilder(
                        animation: _playButtonController,
                        builder: (context, child) {
                          final scale = 1.0 + _playButtonController.value;
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                                boxShadow: [
                                  MusicTheme.neonShadow(primaryColor, blurRadius: 16),
                                  if (_isPlaying)
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.4),
                                      blurRadius: 30 + 20 * _playButtonController.value,
                                      spreadRadius:
                                          10 + 10 * _playButtonController.value,
                                    ),
                                ],
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 36,
                                color: buttonColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next, color: textColor, size: 36),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.repeat, color: textColor.withOpacity(0.7)),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
