import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class SleepTimerScreen extends StatefulWidget {
  const SleepTimerScreen({super.key});

  @override
  State<SleepTimerScreen> createState() => _SleepTimerScreenState();
}

class _SleepTimerScreenState extends State<SleepTimerScreen>
    with SingleTickerProviderStateMixin {
  int _selectedMinutes = 45;
  bool _isRunning = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<int> _presets = [15, 30, 45, 60, 90];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
                    'Sleep Timer',
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

            // Floating music note (decorative)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 40),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, _) => Opacity(
                    opacity: _pulseAnimation.value * 0.6,
                    child: Icon(Icons.music_note,
                        size: 22, color: primaryColor),
                  ),
                ),
              ),
            ),

            // Main timer visual
            Expanded(
              flex: 3,
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow ring
                        Container(
                          width: 230 * _pulseAnimation.value,
                          height: 230 * _pulseAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.1 * _pulseAnimation.value),
                              width: 1,
                            ),
                          ),
                        ),
                        // Middle ring
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                primaryColor.withOpacity(0.8),
                                secondaryColor.withOpacity(0.4),
                                primaryColor.withOpacity(0.1),
                                primaryColor.withOpacity(0.8),
                              ],
                              stops: const [0.0, 0.4, 0.7, 1.0],
                              transform: GradientRotation(
                                _pulseController.value * 2 * pi,
                              ),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF06030F),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Moon icon
                                  Icon(
                                    Icons.nightlight_round,
                                    size: 30,
                                    color: primaryColor.withOpacity(0.7),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$_selectedMinutes:00',
                                    style: GoogleFonts.orbitron(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                      shadows: [
                                        Shadow(
                                          color: primaryColor.withOpacity(0.5),
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'min',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Orbiting dot
                        _buildOrbitingDot(primaryColor),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Recommended label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recommended',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Preset buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _presets.map((min) {
                  final isSelected = min == _selectedMinutes;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMinutes = min),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor.withOpacity(0.2)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : Colors.white.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [MusicTheme.neonShadow(primaryColor, blurRadius: 12)]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$min',
                            style: GoogleFonts.orbitron(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? primaryColor : Colors.white,
                            ),
                          ),
                          Text(
                            'min',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: isSelected
                                  ? primaryColor.withOpacity(0.8)
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 28),

            // Start / Stop button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () => setState(() => _isRunning = !_isRunning),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [MusicTheme.neonShadow(primaryColor, blurRadius: 16)],
                  ),
                  child: Text(
                    _isRunning ? 'Stop Timer' : 'Start Timer',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildOrbitingDot(Color color) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final angle = _pulseController.value * 2 * pi;
        const r = 100.0;
        return Transform.translate(
          offset: Offset(r * cos(angle), r * sin(angle)),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
