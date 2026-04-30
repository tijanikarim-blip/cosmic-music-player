import 'package:flutter/material.dart';
import 'dart:math';

class WaveformVisualizer extends StatefulWidget {
  final Color color;
  final Color secondaryColor;
  final bool isPlaying;

  const WaveformVisualizer({
    super.key,
    required this.color,
    required this.secondaryColor,
    this.isPlaying = true,
  });

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<double> _bars;

  @override
  void initState() {
    super.initState();
    _bars = List.generate(40, (i) => 0.3 + _random.nextDouble() * 0.7);
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(_bars.length, (i) {
              final animValue = widget.isPlaying ? (sin(_controller.value * 2 * pi + i * 0.5).abs()) : 0.1;
              final height = 8 + animValue * 50 * _bars[i];
              return Container(
                width: 3,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [widget.color, widget.secondaryColor.withValues(alpha: 0.5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class RotatingAlbumArt extends StatefulWidget {
  final Widget child;
  final double size;
  final bool isPlaying;
  final Color glowColor;

  const RotatingAlbumArt({
    super.key,
    required this.child,
    this.size = 280,
    this.isPlaying = false,
    required this.glowColor,
  });

  @override
  State<RotatingAlbumArt> createState() => _RotatingAlbumArtState();
}

class _RotatingAlbumArtState extends State<RotatingAlbumArt> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
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
        return Transform.rotate(
          angle: widget.isPlaying ? _controller.value * 2 * pi : 0,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
