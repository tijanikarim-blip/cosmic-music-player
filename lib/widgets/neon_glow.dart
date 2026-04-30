import 'package:flutter/material.dart';
import 'dart:math';
import '../core/theme/music_theme.dart';

class NeonGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double radius;
  final Duration duration;
  final bool isPlaying;

  const NeonGlow({
    super.key,
    required this.child,
    required this.glowColor,
    this.radius = 12,
    this.duration = const Duration(seconds: 2),
    this.isPlaying = true,
  });

  @override
  State<NeonGlow> createState() => _NeonGlowState();
}

class _NeonGlowState extends State<NeonGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final intensity = widget.isPlaying ? _animation.value : 0.4;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(intensity * 0.8),
                blurRadius: 20 * intensity,
                spreadRadius: 4 * intensity,
              ),
              BoxShadow(
                color: widget.glowColor.withOpacity(intensity * 0.4),
                blurRadius: 40 * intensity,
                spreadRadius: 10 * intensity,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

class CosmicParticles extends StatefulWidget {
  final Color particleColor;
  final int particleCount;
  final bool isPlaying;

  const CosmicParticles({
    super.key,
    required this.particleColor,
    this.particleCount = 30,
    this.isPlaying = true,
  });

  @override
  State<CosmicParticles> createState() => _CosmicParticlesState();
}

class _CosmicParticlesState extends State<CosmicParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(widget.particleCount, (i) => Particle());
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            _particles,
            widget.particleColor,
            _controller.value,
            widget.isPlaying,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double speed = 0.0005 + Random().nextDouble() * 0.001;
  double size = 1.0 + Random().nextDouble() * 2.0;
  double drift = (Random().nextDouble() - 0.5) * 0.001;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double progress;
  final bool isPlaying;

  ParticlePainter(this.particles, this.color, this.progress, this.isPlaying);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      if (isPlaying) {
        p.y -= p.speed;
        p.x += p.drift;
        if (p.y < 0) p.y = 1.0;
        if (p.x < 0) p.x = 1.0;
        if (p.x > 1) p.x = 0.0;
      }
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        Paint()..color = color.withOpacity(0.6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MovingGradientBackground extends StatefulWidget {
  final MusicThemeType themeType;
  final Widget child;
  final bool isPlaying;

  const MovingGradientBackground({
    super.key,
    required this.themeType,
    required this.child,
    this.isPlaying = true,
  });

  @override
  State<MovingGradientBackground> createState() => _MovingGradientBackgroundState();
}

class _MovingGradientBackgroundState extends State<MovingGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final intensity = widget.isPlaying ? 1.0 : 0.3;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -1 + 2 * _controller.value,
                -1 + _controller.value,
              ),
              end: Alignment(
                1 - _controller.value,
                1 - 0.5 * _controller.value,
              ),
              colors: widget.themeType == MusicThemeType.emberOdyssey
                  ? [
                      const Color(0xFF0D0501),
                      const Color(0xFF1A0A02).withOpacity(intensity),
                      const Color(0xFF0F0500),
                    ]
                  : widget.themeType == MusicThemeType.auroraWave
                      ? [
                          const Color(0xFF050A14),
                          const Color(0xFF0A1428).withOpacity(intensity),
                          const Color(0xFF050A14),
                        ]
                      : widget.themeType == MusicThemeType.goldenEclipse
                          ? [
                              const Color(0xFF080600),
                              const Color(0xFF1A1400).withOpacity(intensity),
                              const Color(0xFF0D0900),
                            ]
                          : widget.themeType == MusicThemeType.galaxyStorm
                              ? [
                                  const Color(0xFF06030F),
                                  const Color(0xFF0C06A3).withOpacity(intensity),
                                  const Color(0xFF06030F),
                                ]
                              : [
                                  const Color(0xFF04020E),
                                  const Color(0xFF080428).withOpacity(intensity),
                                  const Color(0xFF04020E),
                                ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class FloatingMusicNotes extends StatefulWidget {
  final Color color;
  final bool isPlaying;

  const FloatingMusicNotes({
    super.key,
    required this.color,
    this.isPlaying = true,
  });

  @override
  State<FloatingMusicNotes> createState() => _FloatingMusicNotesState();
}

class _FloatingMusicNotesState extends State<FloatingMusicNotes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<MusicNote> _notes;

  @override
  void initState() {
    super.initState();
    _notes = List.generate(5, (i) => MusicNote(i));
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MusicNotePainter(
            _notes,
            widget.color,
            _controller.value,
            widget.isPlaying,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class MusicNote {
  double x = Random().nextDouble();
  double y = 0.5 + Random().nextDouble() * 0.5;
  double speed = 0.001 + Random().nextDouble() * 0.002;
  double size = 12 + Random().nextDouble() * 18;
  final List<IconData> noteIcons = [
    Icons.music_note,
    Icons.music_off,
    Icons.queue_music,
  ];
  late IconData icon;

  MusicNote(int index) {
    icon = noteIcons[index % noteIcons.length];
  }
}

class MusicNotePainter extends CustomPainter {
  final List<MusicNote> notes;
  final Color color;
  final double progress;
  final bool isPlaying;

  MusicNotePainter(this.notes, this.color, this.progress, this.isPlaying);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (final n in notes) {
      if (isPlaying) {
        n.y -= n.speed;
        n.x += (sin(progress * 4 * pi + n.y * 3) * 0.003);
        if (n.y < -0.1) {
          n.y = 1.1;
          n.x = Random().nextDouble();
        }
      }
      textPainter.text = TextSpan(
        text: String.fromCharCode(Icons.music_note.codePoint),
        style: TextStyle(
          fontSize: n.size,
          fontFamily: Icons.music_note.fontFamily,
          color: color.withOpacity(0.15 + 0.1 * sin(progress * 2 * pi + n.y * 4)),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(n.x * size.width, n.y * size.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
