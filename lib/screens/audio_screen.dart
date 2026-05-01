import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with SingleTickerProviderStateMixin {
  String _selectedMode = 'Space';
  double _intensity = 0.6;
  bool _headTracking = true;

  late AnimationController _orbitController;

  final List<String> _modes = ['Concert', 'Cinema', 'Space', 'Club'];

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
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
                    '3D Audio',
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

            const SizedBox(height: 24),

            // 3D Audio visual — orbiting spheres around headphone silhouette
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: _orbitController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow ring
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                      ),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      // Center silhouette
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              primaryColor.withOpacity(0.25),
                              primaryColor.withOpacity(0.05),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.headphones,
                          size: 54,
                          color: textColor.withOpacity(0.9),
                        ),
                      ),
                      // Orbiting nodes
                      ..._buildOrbitingNodes(primaryColor, secondaryColor),
                      // Music notes floating
                      ..._buildFloatingNotes(primaryColor, textColor),
                    ],
                  );
                },
              ),
            ),

            // Mode selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _modes.map((mode) {
                    final isSelected = mode == _selectedMode;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMode = mode),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 11),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor
                              : Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? primaryColor
                                : Colors.white.withOpacity(0.15),
                          ),
                          boxShadow: isSelected
                              ? [MusicTheme.neonShadow(primaryColor, blurRadius: 14)]
                              : null,
                        ),
                        child: Text(
                          mode,
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

            // Intensity slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassContainer(
                themeType: themeType,
                borderRadius: 16,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Intensity',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.volume_down, color: textColor.withOpacity(0.5), size: 18),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: primaryColor,
                              inactiveTrackColor: primaryColor.withOpacity(0.2),
                              thumbColor: primaryColor,
                              overlayColor: primaryColor.withOpacity(0.2),
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                            ),
                            child: Slider(
                              value: _intensity,
                              onChanged: (v) => setState(() => _intensity = v),
                            ),
                          ),
                        ),
                        Icon(Icons.volume_up, color: textColor.withOpacity(0.7), size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Head Tracking toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassContainer(
                themeType: themeType,
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.sensors, color: primaryColor, size: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Head Tracking',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Text(
                            'Follow your head movement',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _headTracking,
                      onChanged: (v) => setState(() => _headTracking = v),
                      activeColor: primaryColor,
                      activeTrackColor: primaryColor.withOpacity(0.35),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOrbitingNodes(Color primary, Color secondary) {
    const count = 6;
    return List.generate(count, (i) {
      final angle = _orbitController.value * 2 * pi + (i * 2 * pi / count);
      const orbitRadius = 110.0;
      return Positioned(
        left: 120 + orbitRadius * cos(angle) - 8,
        top: 120 + orbitRadius * sin(angle) - 8,
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i.isEven ? primary : secondary,
            boxShadow: [
              BoxShadow(
                color: (i.isEven ? primary : secondary).withOpacity(0.8),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildFloatingNotes(Color primary, Color textColor) {
    const positions = [
      Offset(-80, -60),
      Offset(85, -50),
      Offset(-95, 30),
      Offset(90, 40),
    ];
    return List.generate(positions.length, (i) {
      final bounce = sin(_orbitController.value * 2 * pi + i * pi / 2) * 8;
      return Positioned(
        left: 120 + positions[i].dx,
        top: 120 + positions[i].dy + bounce,
        child: Icon(
          Icons.music_note,
          size: 18,
          color: primary.withOpacity(0.5),
        ),
      );
    });
  }
}
