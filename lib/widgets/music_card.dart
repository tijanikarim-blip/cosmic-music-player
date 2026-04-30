import 'package:flutter/material.dart';
import '../core/theme/music_theme.dart';

class MusicCard extends StatelessWidget {
  final Widget child;
  final MusicThemeType themeType;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  const MusicCard({
    super.key,
    required this.child,
    required this.themeType,
    this.onTap,
    this.borderRadius = 16,
    this.padding,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    final glowColor = _getPrimaryColor(themeType);
    return Container(
      decoration: MusicTheme.glassDecoration(glowColor, borderRadius: borderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: glowColor.withValues(alpha: 0.2),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
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
}
