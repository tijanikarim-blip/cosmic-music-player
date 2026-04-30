import 'package:flutter/material.dart';
import 'dart:math';

class NeonGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double radius;
  final Duration duration;

  const NeonGlow({
    super.key,
    required this.child,
    required this.glowColor,
    this.radius = 12,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<NeonGlow> createState() => _NeonGlowState();
}

class _NeonGlowState extends State<NeonGlow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)..repeat(reverse: true);
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
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: _animation.value * 0.8),
                blurRadius: 20 * _animation.value,
                spreadRadius: 4 * _animation.value,
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

  const CosmicParticles({
    super.key,
    required this.particleColor,
    this.particleCount = 30,
  });

  @override
  State<CosmicParticles> createState() => _CosmicParticlesState();
}

class _CosmicParticlesState extends State<CosmicParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(widget.particleCount, (i) => Particle());
    _controller = AnimationController(duration: const Duration(seconds: 10), vsync: this)..repeat();
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
          painter: ParticlePainter(_particles, widget.particleColor, _controller.value),
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
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double progress;

  ParticlePainter(this.particles, this.color, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.6);
    for (final p in particles) {
      p.y -= p.speed;
      if (p.y < 0) p.y = 1.0;
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
