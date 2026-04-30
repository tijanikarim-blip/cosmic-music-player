import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final List<Map<String, dynamic>> _themes = const [
    {'name': 'Ember Odyssey', 'type': MusicThemeType.emberOdyssey, 'color': MusicTheme.emberPrimary},
    {'name': 'Aurora Wave', 'type': MusicThemeType.auroraWave, 'color': MusicTheme.auroraPrimary},
    {'name': 'Golden Eclipse', 'type': MusicThemeType.goldenEclipse, 'color': MusicTheme.goldenPrimary},
    {'name': 'Galaxy Storm', 'type': MusicThemeType.galaxyStorm, 'color': MusicTheme.galaxyPrimary},
    {'name': 'Immersive', 'type': MusicThemeType.immersive, 'color': MusicTheme.immersivePrimary},
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeType = themeProvider.currentTheme;
    final primaryColor = MusicTheme.getPrimaryColor(themeType);
    final textColor = MusicTheme.getTextColor(themeType);

    return Container(
      decoration: MusicTheme.cosmicBackground(themeType),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SETTINGS',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.5),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preferences',
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'THEME',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.5),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              GlassContainer(
                themeType: themeType,
                borderRadius: 12,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _themes.map((theme) {
                    final isSelected = theme['type'] == themeType;
                    return Column(
                      children: [
                        if (theme != _themes.first) const SizedBox(height: 12),
                        _buildThemeOption(
                          context,
                          theme['name'],
                          theme['color'],
                          isSelected,
                          textColor,
                          () => themeProvider.setTheme(theme['type']),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'AUDIO',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.5),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              GlassContainer(
                themeType: themeType,
                borderRadius: 12,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSettingToggle('High Quality Audio', true, primaryColor, textColor),
                    const Divider(color: Colors.white12),
                    _buildSettingToggle('Equalizer', false, primaryColor, textColor),
                    const Divider(color: Colors.white12),
                    _buildSettingToggle('Crossfade', true, primaryColor, textColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String name, Color color, bool isSelected, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: isSelected ? [MusicTheme.neonShadow(color, blurRadius: 8)] : null,
            ),
            child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.black) : null,
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: textColor,
            ),
          ),
          const Spacer(),
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected ? color : textColor.withOpacity(0.3),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingToggle(String title, bool value, Color primaryColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: textColor,
          ),
        ),
        Switch(
          value: value,
          onChanged: (val) {},
          activeThumbColor: primaryColor,
        ),
      ],
    );
  }
}
