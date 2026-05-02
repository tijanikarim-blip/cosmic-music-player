import 'package:flutter/material.dart';
import 'dart:math';


class AlbumArtWidget extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isPlaying;

  const AlbumArtWidget({
    super.key,
    required this.size,
    required this.primaryColor,
    required this.secondaryColor,
    this.isPlaying = false,
  });

  @override
  State<AlbumArtWidget> createState() => _AlbumArtWidgetState();
}

class _AlbumArtWidgetState extends State<AlbumArtWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
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
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: SweepGradient(
          center: Alignment.center,
          colors: [
            widget.primaryColor.withValues(alpha: 0.7),
            widget.secondaryColor.withValues(alpha: 0.5),
            widget.primaryColor.withValues(alpha: 0.7),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(
          color: widget.primaryColor.withValues(alpha: 0.8),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withValues(alpha: 0.6),
            blurRadius: 40,
            spreadRadius: 15,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating geometric pattern
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Transform.rotate(
                angle: widget.isPlaying ? _controller.value * 2 * pi : 0,
                child: CustomPaint(
                  size: Size(widget.size * 0.8, widget.size * 0.8),
                  painter: GeometricPainter(
                    widget.primaryColor,
                    widget.secondaryColor,
                    _controller.value,
                  ),
                ),
              );
            },
          ),
          // Center icon
          Icon(
            Icons.album,
            size: widget.size * 0.2,
            color: widget.primaryColor.withValues(alpha: 0.9),
          ),
          // Glowing edge
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.primaryColor.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GeometricPainter extends CustomPainter {
  final Color primary;
  final Color secondary;
  final double progress;

  GeometricPainter(this.primary, this.secondary, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * 2 * pi + progress * 2 * pi;
      final radius = size.width * 0.35;
      final dx = center.dx + cos(angle) * radius * 0.3;
      final dy = center.dy + sin(angle) * radius * 0.3;
      paint.color = (i.isEven ? primary : secondary).withValues(alpha: 0.5);
      canvas.drawCircle(Offset(dx, dy), radius * 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
