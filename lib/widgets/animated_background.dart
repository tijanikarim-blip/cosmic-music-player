import 'package:flutter/material.dart';
import 'dart:math';
import '../core/theme/music_theme.dart';

class AnimatedCosmicBackground extends StatelessWidget {
  final MusicThemeType themeType;
  final Widget child;

  const AnimatedCosmicBackground({
    super.key,
    required this.themeType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getThemeColors();
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: colors,
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Large glowing orbs
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors[0].withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors[1].withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Floating particles
          CustomPaint(
            painter: RichParticlesPainter(colors),
            size: Size.infinite,
          ),
          child,
        ],
      ),
    );
  }

  List<Color> _getThemeColors() {
    switch (themeType) {
      case MusicThemeType.emberOdyssey:
        return [const Color(0xFF0D0501), const Color(0xFF1A0A02), const Color(0xFF2D0900), const Color(0xFF0D0501)];
      case MusicThemeType.auroraWave:
        return [const Color(0xFF050A14), const Color(0xFF0A1428), const Color(0xFF0F2040), const Color(0xFF050A14)];
      case MusicThemeType.goldenEclipse:
        return [const Color(0xFF080600), const Color(0xFF1A1400), const Color(0xFF2D2000), const Color(0xFF080600)];
      case MusicThemeType.galaxyStorm:
        return [const Color(0xFF06030F), const Color(0xFF0C06A3), const Color(0xFF1808B0), const Color(0xFF06030F)];
      case MusicThemeType.immersive:
        return [const Color(0xFF04020E), const Color(0xFF080428), const Color(0xFF120440), const Color(0xFF04020E)];
    }
  }
}

class RichParticlesPainter extends CustomPainter {
  final List<Color> colors;
  final Random _random = Random(42);

  RichParticlesPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 100; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final radius = 0.5 + _random.nextDouble() * 2.5;
      final paint = Paint()
         ..color = colors[i % colors.length].withValues(
             alpha: 0.3 + _random.nextDouble() * 0.5,
           );
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
