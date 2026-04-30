import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/music_theme.dart';
import '../widgets/glass_container.dart';

class SettingsScreen extends StatelessWidget {
  final MusicThemeType themeType;

  const SettingsScreen({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getPrimaryColor(themeType);
    final textColor = _getTextColor(themeType);

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
                  color: textColor.withValues(alpha: 0.5),
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
              // Theme Setting
              Text(
                'THEME',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor.withValues(alpha: 0.5),
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
                    _buildThemeOption('Ember Odyssey', MusicTheme.emberPrimary, themeType == MusicThemeType.emberOdyssey, textColor),
                    const SizedBox(height: 12),
                    _buildThemeOption('Aurora Wave', MusicTheme.auroraPrimary, themeType == MusicThemeType.auroraWave, textColor),
                    const SizedBox(height: 12),
                    _buildThemeOption('Golden Eclipse', MusicTheme.goldenPrimary, themeType == MusicThemeType.goldenEclipse, textColor),
                    const SizedBox(height: 12),
                    _buildThemeOption('Galaxy Storm', MusicTheme.galaxyPrimary, themeType == MusicThemeType.galaxyStorm, textColor),
                    const SizedBox(height: 12),
                    _buildThemeOption('Immersive', MusicTheme.immersivePrimary, themeType == MusicThemeType.immersive, textColor),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Audio Settings
              Text(
                'AUDIO',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor.withValues(alpha: 0.5),
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

  Widget _buildThemeOption(String name, Color color, bool isSelected, Color textColor) {
    return Row(
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
        if (isSelected)
          Icon(Icons.radio_button_checked, color: color, size: 20)
        else
          Icon(Icons.radio_button_unchecked, color: textColor.withValues(alpha: 0.3), size: 20),
      ],
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

  Color _getPrimaryColor(MusicThemeType type) {
    switch (type) {
      case MusicThemeType.emberOdyssey: return MusicTheme.emberPrimary;
      case MusicThemeType.auroraWave: return MusicTheme.auroraPrimary;
      case MusicThemeType.goldenEclipse: return MusicTheme.goldenPrimary;
      case MusicThemeType.galaxyStorm: return MusicTheme.galaxyPrimary;
      case MusicThemeType.immersive: return MusicTheme.immersivePrimary;
    }
  }

  Color _getTextColor(MusicThemeType type) {
    switch (type) {
      case MusicThemeType.emberOdyssey: return MusicTheme.emberText;
      case MusicThemeType.auroraWave: return MusicTheme.auroraText;
      case MusicThemeType.goldenEclipse: return MusicTheme.goldenText;
      case MusicThemeType.galaxyStorm: return MusicTheme.galaxyText;
      case MusicThemeType.immersive: return MusicTheme.immersiveText;
    }
  }
}
