import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/music_button.dart';
import 'main_navigation.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  MusicThemeType _selectedTheme = MusicThemeType.galaxyStorm;

  final List<Map<String, dynamic>> _themes = const [
    {'type': MusicThemeType.emberOdyssey, 'name': 'Ember Odyssey', 'color': MusicTheme.emberPrimary},
    {'type': MusicThemeType.auroraWave, 'name': 'Aurora Wave', 'color': MusicTheme.auroraPrimary},
    {'type': MusicThemeType.goldenEclipse, 'name': 'Golden Eclipse', 'color': MusicTheme.goldenPrimary},
    {'type': MusicThemeType.galaxyStorm, 'name': 'Galaxy Storm', 'color': MusicTheme.galaxyPrimary},
    {'type': MusicThemeType.immersive, 'name': 'Immersive', 'color': MusicTheme.immersivePrimary},
  ];

  Color _getTextColor(MusicThemeType type) => MusicTheme.getTextColor(type);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Theme(
      data: MusicTheme.getTheme(_selectedTheme),
      child: Scaffold(
        body: Container(
          decoration: MusicTheme.cosmicBackground(_selectedTheme),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Icon(
                    Icons.graphic_eq,
                    size: 80,
                    color: _themes.firstWhere((t) => t['type'] == _selectedTheme)['color'],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'COSMIC PLAYER',
                    style: GoogleFonts.orbitron(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: _getTextColor(_selectedTheme),
                      shadows: [
                        MusicTheme.neonShadow(
                          _themes.firstWhere((t) => t['type'] == _selectedTheme)['color'],
                          blurRadius: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Experience music in deep space',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: _getTextColor(_selectedTheme).withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'SELECT THEME',
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(_selectedTheme).withOpacity(0.5),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _themes.length,
                      itemBuilder: (context, index) {
                        final theme = _themes[index];
                        final isSelected = theme['type'] == _selectedTheme;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTheme = theme['type']),
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme['color'],
                                    boxShadow: isSelected
                                        ? [MusicTheme.neonShadow(theme['color'], blurRadius: 16)]
                                        : null,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, color: Colors.black, size: 24)
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  theme['name'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    color: _getTextColor(_selectedTheme).withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  GlassContainer(
                    themeType: _selectedTheme,
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    child: MusicButton(
                      label: 'ENTER THE COSMOS',
                      onPressed: () {
                        themeProvider.setTheme(_selectedTheme);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MainNavigation(),
                          ),
                        );
                      },
                      color: _themes.firstWhere((t) => t['type'] == _selectedTheme)['color'],
                      textColor: _selectedTheme == MusicThemeType.goldenEclipse
                          ? const Color(0xFF080600)
                          : (_selectedTheme == MusicThemeType.emberOdyssey
                              ? const Color(0xFF0D0501)
                              : Colors.black),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
