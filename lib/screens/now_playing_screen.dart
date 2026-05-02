import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/audio/audio_provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/neon_glow.dart';
import '../widgets/waveform_visualizer.dart';
import '../widgets/elastic_slider.dart';
import '../widgets/album_art_widget.dart';
import '../widgets/animated_background.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
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

  String _formatDuration(Duration d) {
    final mins = d.inMinutes;
    final secs = d.inSeconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
    final themeType = themeProvider.currentTheme;
    final primaryColor = MusicTheme.getPrimaryColor(themeType);
    final textColor = MusicTheme.getTextColor(themeType);
    final secondaryColor = MusicTheme.getSecondaryColor(themeType);
    final song = audioProvider.currentSong;

    final isPlaying = audioProvider.isPlaying;
    final position = audioProvider.position;
    final duration = audioProvider.duration;
    final progress = duration.inSeconds > 0 ? position.inSeconds / duration.inSeconds : 0.0;

    final buttonColor = themeType == MusicThemeType.goldenEclipse
        ? const Color(0xFF080600)
        : (themeType == MusicThemeType.emberOdyssey ? const Color(0xFF0D0501) : Colors.black);

    return AnimatedCosmicBackground(
      themeType: themeType,
      child: SafeArea(
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
              Expanded(
                child: NeonGlow(
                  glowColor: primaryColor,
                  radius: 24,
                  isPlaying: isPlaying,
                  child: RotatingAlbumArt(
                    size: 280,
                    isPlaying: isPlaying,
                    glowColor: primaryColor,
                    child: GlassContainer(
                      themeType: themeType,
                      width: 280,
                      height: 280,
                      borderRadius: 24,
                            child: song?.albumArtBytes != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.memory(
                                      song!.albumArtBytes!,
                                      width: 280,
                                      height: 280,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => AlbumArtWidget(
                                        size: 280,
                                        primaryColor: primaryColor,
                                        secondaryColor: secondaryColor,
                                      ),
                                    ),
                                )
                              : AlbumArtWidget(
                              size: 280,
                              primaryColor: primaryColor,
                              secondaryColor: secondaryColor,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                song?.title ?? 'No Track Selected',
                style: GoogleFonts.orbitron(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                song?.artist ?? 'Select a song to play',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              WaveformVisualizer(
                color: primaryColor,
                secondaryColor: secondaryColor,
                isPlaying: isPlaying,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(position), style: GoogleFonts.inter(fontSize: 12, color: textColor.withValues(alpha: 0.5))),
                  Text(_formatDuration(duration), style: GoogleFonts.inter(fontSize: 12, color: textColor.withValues(alpha: 0.5))),
                ],
              ),
              ElasticSlider(
                value: progress.clamp(0.0, 1.0),
                onChanged: (value) {
                  final dur = audioProvider.duration;
                  audioProvider.seek(Duration(milliseconds: (value * dur.inMilliseconds).round()));
                },
                activeColor: primaryColor,
                inactiveColor: primaryColor.withValues(alpha: 0.3),
                textColor: textColor,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shuffle,
                      color: audioProvider.isShuffle ? primaryColor : textColor.withValues(alpha: 0.7),
                    ),
                    onPressed: audioProvider.toggleShuffle,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_previous, color: textColor, size: 36),
                    onPressed: audioProvider.skipPrevious,
                  ),
                  GestureDetector(
                    onTap: () {
                      audioProvider.togglePlay();
                      if (audioProvider.isPlaying) {
                        _playButtonController.forward().then((_) => _playButtonController.reverse());
                      }
                    },
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
                                if (isPlaying)
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.4),
                                    blurRadius: 30 + 20 * _playButtonController.value,
                                    spreadRadius: 10 + 10 * _playButtonController.value,
                                  ),
                              ],
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
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
                    onPressed: audioProvider.skipNext,
                  ),
                  IconButton(
                    icon: Icon(
                      audioProvider.repeatMode == LoopMode.one
                          ? Icons.repeat_one
                          : Icons.repeat,
                      color: audioProvider.repeatMode != LoopMode.off ? primaryColor : textColor.withValues(alpha: 0.7),
                    ),
                    onPressed: audioProvider.toggleRepeat,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
