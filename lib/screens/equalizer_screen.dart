import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen>
    with SingleTickerProviderStateMixin {
  bool _customEnabled = true;
  String _selectedPreset = 'Rock';
  double _bassBoost = 0.65;
  double _virtualizer = 0.45;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<String> _presets = ['Flat', 'Pop', 'Rock', 'Jazz', 'Classical'];
  final List<String> _bands = ['60', '150', '400', '1K', '2.4K', '6K', '15K'];
  final List<double> _eqValues = [0.3, 0.6, 0.75, 0.5, 0.8, 0.55, 0.4];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeType = themeProvider.currentTheme;
    final primaryColor = MusicTheme.getPrimaryColor(themeType);
    final textColor = MusicTheme.getTextColor(themeType);
    final secondaryColor = MusicTheme.getSecondaryColor(themeType);

    return Container(
      decoration: MusicTheme.cosmicBackground(themeType),
      child: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
                  const Spacer(),
                  Text(
                    'Equalizer',
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz, color: Colors.white70, size: 22),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Custom toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.tune, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Custom',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _customEnabled,
                    onChanged: (v) => setState(() => _customEnabled = v),
                     activeThumbColor: primaryColor,
                    activeTrackColor: primaryColor.withValues(alpha: 0.35),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // EQ Bands visualizer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, _) {
                  return GlassContainer(
                    themeType: themeType,
                    borderRadius: 18,
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 130,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(_bands.length, (i) {
                              return _EQBand(
                                value: _eqValues[i],
                                onChanged: (v) => setState(() => _eqValues[i] = v),
                                color: primaryColor,
                                secondaryColor: secondaryColor,
                                glowIntensity: _glowAnimation.value,
                                label: _bands[i],
                                textColor: textColor,
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // EQ curve drawn on top (decorative waveform line)
                        CustomPaint(
                          painter: _EQCurvePainter(_eqValues, primaryColor, _glowAnimation.value),
                          size: const Size(double.infinity, 40),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Presets
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _presets.map((preset) {
                    final isSelected = preset == _selectedPreset;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPreset = preset),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.3),
                          ),
                          boxShadow: isSelected
                              ? [MusicTheme.neonShadow(primaryColor, blurRadius: 12)]
                              : null,
                        ),
                        child: Text(
                          preset,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.black : textColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bass Boost & Virtualizer knobs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildKnob(
                      label: 'Bass Boost',
                      value: _bassBoost,
                      color: primaryColor,
                      secondaryColor: secondaryColor,
                      textColor: textColor,
                      themeType: themeType,
                      onChanged: (v) => setState(() => _bassBoost = v),
                      glowAnim: _glowAnimation.value,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildKnob(
                      label: 'Virtualizer',
                      value: _virtualizer,
                      color: secondaryColor,
                      secondaryColor: primaryColor,
                      textColor: textColor,
                      themeType: themeType,
                      onChanged: (v) => setState(() => _virtualizer = v),
                      glowAnim: _glowAnimation.value,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildKnob({
    required String label,
    required double value,
    required Color color,
    required Color secondaryColor,
    required Color textColor,
    required MusicThemeType themeType,
    required ValueChanged<double> onChanged,
    required double glowAnim,
  }) {
    return GlassContainer(
      themeType: themeType,
      borderRadius: 18,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              final delta = -details.delta.dy / 100;
              onChanged((value + delta).clamp(0.0, 1.0));
            },
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, _) {
                return Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                         color: color.withValues(alpha: glowAnim * 0.5),
                        blurRadius: 20 * glowAnim,
                        spreadRadius: 3 * glowAnim,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: _KnobPainter(value, color, secondaryColor),
                    size: const Size(90, 90),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EQBand extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final Color color;
  final Color secondaryColor;
  final double glowIntensity;
  final String label;
  final Color textColor;

  const _EQBand({
    required this.value,
    required this.onChanged,
    required this.color,
    required this.secondaryColor,
    required this.glowIntensity,
    required this.label,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onVerticalDragUpdate: (d) {
              onChanged((value - d.delta.dy / 120).clamp(0.0, 1.0));
            },
            child: SizedBox(
              width: 28,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: value,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [color, secondaryColor],
                        ),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                             color: color.withValues(alpha: glowIntensity * 0.8),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: value * 120 - 8,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        boxShadow: [
                          BoxShadow(
                             color: color.withValues(alpha: glowIntensity),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 9, color: textColor.withValues(alpha: 0.5)),
        ),
      ],
    );
  }
}

class _EQCurvePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final double glowIntensity;

  _EQCurvePainter(this.values, this.color, this.glowIntensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * glowIntensity);

    final path = Path();
    final step = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = i * step;
      final y = size.height - (values[i] * size.height * 0.8);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * step;
        final prevY = size.height - (values[i - 1] * size.height * 0.8);
        path.cubicTo(prevX + step * 0.5, prevY, x - step * 0.5, y, x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw glowing dots
    final dotPaint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * glowIntensity);

    for (int i = 0; i < values.length; i++) {
      canvas.drawCircle(
        Offset(i * step, size.height - (values[i] * size.height * 0.8)),
        4,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _KnobPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color secondaryColor;

  _KnobPainter(this.value, this.color, this.secondaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = Colors.black.withValues(alpha: 0.6),
    );

    // Gradient ring background
    canvas.drawCircle(
      center,
      radius - 4,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Active arc
    final sweepAngle = value * 1.5 * pi;
    const startAngle = 0.75 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 8),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Indicator line
    final angle = startAngle + sweepAngle;
    final indicatorEnd = Offset(
      center.dx + (radius - 16) * cos(angle),
      center.dy + (radius - 16) * sin(angle),
    );
    canvas.drawLine(
      center,
      indicatorEnd,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Center dot
    canvas.drawCircle(center, 6, Paint()..color = color.withValues(alpha: 0.8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
