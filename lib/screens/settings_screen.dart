import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/music_theme.dart';
import '../core/theme/theme_provider.dart';
import '../widgets/glass_container.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _audio3D = true;
  bool _headTracking = true;


  static const List<Map<String, dynamic>> _themes = [
    {
      'name': 'Ember Odyssey',
      'type': MusicThemeType.emberOdyssey,
      'color': MusicTheme.emberPrimary,
      'secondary': MusicTheme.emberSecondary,
      'subtitle': 'Fire & Lava',
    },
    {
      'name': 'Aurora Wave',
      'type': MusicThemeType.auroraWave,
      'color': MusicTheme.auroraPrimary,
      'secondary': MusicTheme.auroraSecondary,
      'subtitle': 'Northern Lights',
    },
    {
      'name': 'Golden Eclipse',
      'type': MusicThemeType.goldenEclipse,
      'color': MusicTheme.goldenPrimary,
      'secondary': MusicTheme.goldenSecondary,
      'subtitle': 'Solar Gold',
    },
    {
      'name': 'Galaxy Storm',
      'type': MusicThemeType.galaxyStorm,
      'color': MusicTheme.galaxyPrimary,
      'secondary': MusicTheme.galaxySecondary,
      'subtitle': 'Deep Space',
    },
    {
      'name': 'Immersive',
      'type': MusicThemeType.immersive,
      'color': MusicTheme.immersivePrimary,
      'secondary': MusicTheme.immersiveSecondary,
      'subtitle': 'Cosmic Deep',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeType = themeProvider.currentTheme;
    final primaryColor = MusicTheme.getPrimaryColor(themeType);
    final textColor = MusicTheme.getTextColor(themeType);

    final currentThemeData = _themes.firstWhere((t) => t['type'] == themeType);

    return Container(
      decoration: MusicTheme.cosmicBackground(themeType),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
                  const Spacer(),
                  Text(
                    'Settings',
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

              const SizedBox(height: 24),

              // Active Theme Card
              GlassContainer(
                themeType: themeType,
                borderRadius: 18,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            currentThemeData['color'] as Color,
                            currentThemeData['secondary'] as Color,
                          ],
                        ),
                        boxShadow: [
                          MusicTheme.neonShadow(
                            currentThemeData['color'] as Color,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.black, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentThemeData['name'] as String,
                            style: GoogleFonts.orbitron(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: currentThemeData['color'] as Color,
                            ),
                          ),
                          Text(
                            'Theme',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: textColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Active',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Theme Store heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Theme Store',
                    style: GoogleFonts.orbitron(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'See all',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Theme Store horizontal scroll cards
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _themes.length,
                  itemBuilder: (context, index) {
                    final theme = _themes[index];
                    final isActive = theme['type'] == themeType;
                    return GestureDetector(
                      onTap: () => themeProvider.setTheme(theme['type'] as MusicThemeType),
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              (theme['color'] as Color).withValues(alpha: 0.5),
                              (theme['secondary'] as Color).withValues(alpha: 0.3),
                            ],
                          ),
                          border: Border.all(
                            color: isActive
                                ? (theme['color'] as Color)
                                : Colors.white.withValues(alpha: 0.1),
                            width: isActive ? 2 : 1,
                          ),
                          boxShadow: isActive
                              ? [MusicTheme.neonShadow(theme['color'] as Color, blurRadius: 10)]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    (theme['name'] as String).split(' ').first,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (isActive)
                                    Text(
                                      'Active',
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        color: theme['color'] as Color,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Settings toggles
              GlassContainer(
                themeType: themeType,
                borderRadius: 18,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildToggleRow(
                      icon: Icons.dark_mode,
                      label: 'Dark Mode',
                      value: _darkMode,
                      color: primaryColor,
                      textColor: textColor,
                      onChanged: (v) => setState(() => _darkMode = v),
                      showDivider: true,
                    ),
                    _buildToggleRow(
                      icon: Icons.surround_sound,
                      label: '3D Audio',
                      value: _audio3D,
                      color: primaryColor,
                      textColor: textColor,
                      onChanged: (v) => setState(() => _audio3D = v),
                      showDivider: true,
                    ),
                    _buildToggleRow(
                      icon: Icons.sensors,
                      label: 'Head Tracking',
                      value: _headTracking,
                      color: primaryColor,
                      textColor: textColor,
                      onChanged: (v) => setState(() => _headTracking = v),
                      showDivider: true,
                    ),
                    _buildNavRow(
                      icon: Icons.high_quality,
                      label: 'High Quality Audio',
                      trailingLabel: 'FLAC',
                      color: primaryColor,
                      textColor: textColor,
                      showDivider: true,
                    ),
                    _buildNavRow(
                      icon: Icons.equalizer,
                      label: 'Equalizer',
                      color: primaryColor,
                      textColor: textColor,
                      showDivider: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Additional settings
              GlassContainer(
                themeType: themeType,
                borderRadius: 18,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildNavRow(
                      icon: Icons.nightlight,
                      label: 'Sleep Timer',
                      color: primaryColor,
                      textColor: textColor,
                      showDivider: true,
                    ),
                    _buildNavRow(
                      icon: Icons.language,
                      label: 'Language',
                      trailingLabel: 'English',
                      color: primaryColor,
                      textColor: textColor,
                      showDivider: true,
                    ),
                    _buildNavRow(
                      icon: Icons.info_outline,
                      label: 'About',
                      color: primaryColor,
                      textColor: textColor,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String label,
    required bool value,
    required Color color,
    required Color textColor,
    required ValueChanged<bool> onChanged,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                 activeThumbColor: color,
                activeTrackColor: color.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.07)),
      ],
    );
  }

  Widget _buildNavRow({
    required IconData icon,
    required String label,
    String? trailingLabel,
    required Color color,
    required Color textColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 15, color: textColor),
                ),
              ),
              if (trailingLabel != null)
                Text(
                  trailingLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: textColor.withValues(alpha: 0.5),
                  ),
                ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_ios,
                color: textColor.withValues(alpha: 0.4),
                size: 14,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.07)),
      ],
    );
  }
}
