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

class _WaveformVisualizerState extends State<WaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<double> _bassBars;
  late List<double> _midBars;
  late List<double> _trebleBars;

  @override
  void initState() {
    super.initState();
    _bassBars = List.generate(20, (i) => 0.3 + _random.nextDouble() * 0.7);
    _midBars = List.generate(30, (i) => 0.2 + _random.nextDouble() * 0.8);
    _trebleBars = List.generate(40, (i) => 0.1 + _random.nextDouble() * 0.9);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    return SizedBox(
      height: 80,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Bass layer - large smooth waves
              ...List.generate(_bassBars.length, (i) {
                final animValue = widget.isPlaying
                    ? (sin(_controller.value * 2 * pi + i * 0.8).abs() * 0.6 +
                        sin(_controller.value * 4 * pi + i * 0.3).abs() * 0.4)
                    : 0.05;
                final height = 12 + animValue * 50 * _bassBars[i];
                return Container(
                  width: 4,
                  height: height,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        widget.color,
                        widget.secondaryColor.withOpacity(0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
              }),
              // Mid layer - balanced motion
              ...List.generate(_midBars.length, (i) {
                final animValue = widget.isPlaying
                    ? (sin(_controller.value * 3 * pi + i * 0.5).abs() * 0.5 +
                        cos(_controller.value * 5 * pi + i * 0.7).abs() * 0.5)
                    : 0.05;
                final height = 8 + animValue * 35 * _midBars[i];
                return Container(
                  width: 3,
                  height: height,
                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.5),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        widget.secondaryColor,
                        widget.color.withOpacity(0.4),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.secondaryColor.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                );
              }),
              // Treble layer - fast micro vibrations
              ...List.generate(_trebleBars.length, (i) {
                final animValue = widget.isPlaying
                    ? (sin(_controller.value * 8 * pi + i * 0.3).abs() * 0.4 +
                        cos(_controller.value * 12 * pi + i * 0.5).abs() * 0.6)
                    : 0.02;
                final height = 4 + animValue * 20 * _trebleBars[i];
                return Container(
                  width: 2,
                  height: height,
                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: widget.color.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.5),
                        blurRadius: 3,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                );
              }),
            ],
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

class _RotatingAlbumArtState extends State<RotatingAlbumArt>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _breathingController]),
      builder: (context, child) {
        final breathingScale = widget.isPlaying
            ? 1.0 + 0.03 * sin(_breathingController.value * pi)
            : 1.0;
        return Transform.rotate(
          angle: widget.isPlaying ? _rotationController.value * 2 * pi : 0,
          child: Transform.scale(
            scale: breathingScale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.glowColor.withOpacity(
                      widget.isPlaying
                          ? 0.3 + 0.2 * sin(_breathingController.value * pi)
                          : 0.2,
                    ),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
