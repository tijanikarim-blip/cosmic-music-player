import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/music_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/neon_glow.dart';
import '../widgets/waveform_visualizer.dart';

class NowPlayingScreen extends StatefulWidget {
  final MusicThemeType themeType;

  const NowPlayingScreen({super.key, required this.themeType});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getPrimaryColor(widget.themeType);
    final textColor = _getTextColor(widget.themeType);
    final secondaryColor = _getSecondaryColor(widget.themeType);

    return Container(
      decoration: MusicTheme.cosmicBackground(widget.themeType),
      child: Stack(
        children: [
          // Cosmic particles background
          CosmicParticles(particleColor: primaryColor.withValues(alpha: 0.3)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top bar
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
                          color: textColor.withValues(alpha: 0.5),
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
                  // Animated Album Art
                  Expanded(
                    child: NeonGlow(
                      glowColor: primaryColor,
                      radius: 24,
                      child: RotatingAlbumArt(
                        size: 280,
                        isPlaying: _isPlaying,
                        glowColor: primaryColor,
                        child: GlassContainer(
                          themeType: widget.themeType,
                          width: 280,
                          height: 280,
                          borderRadius: 24,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [primaryColor.withValues(alpha: 0.3), secondaryColor.withValues(alpha: 0.1)],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.album,
                                size: 80,
                                color: primaryColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Song Info
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
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Animated Waveform
                  WaveformVisualizer(
                    color: primaryColor,
                    secondaryColor: secondaryColor,
                    isPlaying: _isPlaying,
                  ),
                  const SizedBox(height: 16),
                  // Progress Slider
                  Column(
                    children: [
                      Slider(
                        value: 0.35,
                        onChanged: (value) {},
                        activeColor: primaryColor,
                        inactiveColor: primaryColor.withValues(alpha: 0.3),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('1:24', style: GoogleFonts.inter(fontSize: 12, color: textColor.withValues(alpha: 0.5))),
                          Text('3:58', style: GoogleFonts.inter(fontSize: 12, color: textColor.withValues(alpha: 0.5))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Playback Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shuffle, color: textColor.withValues(alpha: 0.7)),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: textColor, size: 36),
                        onPressed: () {},
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isPlaying = !_isPlaying),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                            boxShadow: [MusicTheme.neonShadow(primaryColor, blurRadius: 16)],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 36,
                            color: widget.themeType == MusicThemeType.goldenEclipse
                                ? const Color(0xFF080600)
                                : (widget.themeType == MusicThemeType.emberOdyssey ? const Color(0xFF0D0501) : Colors.black),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: textColor, size: 36),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.repeat, color: textColor.withValues(alpha: 0.7)),
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
      ),
    );
  }

  Color _getPrimaryColor(MusicThemeType type) {
    switch (type) {
      case MusicThemeType.emberOdyssey: return MusicTheme.emberPrimary;
      case MusicThemeType.auroraWave: return MusicTheme.auroraPrimary;
      case MusicThemeType.goldenEclipse: return MusicTheme.goldenPrimary;
      case MusicThemeType.galaxyStorm: return MusicTheme.galaxyPrimary;
      case MusicThemeType.immersive: return MusicTheme.immersivePrimary;
    }
  }

  Color _getTextColor(MusicThemeType type) {
    switch (type) {
      case MusicThemeType.emberOdyssey: return MusicTheme.emberText;
      case MusicThemeType.auroraWave: return MusicTheme.auroraText;
      case MusicThemeType.goldenEclipse: return MusicTheme.goldenText;
      case MusicThemeType.galaxyStorm: return MusicTheme.galaxyText;
      case MusicThemeType.immersive: return MusicTheme.immersiveText;
    }
  }

  Color _getSecondaryColor(MusicThemeType type) {
    switch (type) {
      case MusicThemeType.emberOdyssey: return MusicTheme.emberSecondary;
      case MusicThemeType.auroraWave: return MusicTheme.auroraSecondary;
      case MusicThemeType.goldenEclipse: return MusicTheme.goldenSecondary;
      case MusicThemeType.galaxyStorm: return MusicTheme.galaxySecondary;
      case MusicThemeType.immersive: return MusicTheme.immersiveSecondary;
    }
  }
}
