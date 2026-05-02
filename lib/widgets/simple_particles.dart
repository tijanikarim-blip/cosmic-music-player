import 'package:flutter/material.dart';
import 'dart:math';


class SimpleParticlesPainter extends CustomPainter {
  final Color color;

  SimpleParticlesPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistency
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 0.5 + random.nextDouble() * 2.0;
      final paint = Paint()
         ..color = color.withValues(alpha: 0.3 + random.nextDouble() * 0.4);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
