import 'package:flutter/material.dart';

import '../core/theme/music_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final MusicThemeType themeType;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    required this.themeType,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final glowColor = _getPrimaryColor(themeType);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        boxShadow: [MusicTheme.neonShadow(glowColor, blurRadius: 8)],
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MusicTheme.glassBackground,
              MusicTheme.glassBackground.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: MusicTheme.glassBorder,
            width: 1,
          ),
          boxShadow: [MusicTheme.neonShadow(glowColor, blurRadius: 8)],
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Color _getPrimaryColor(MusicThemeType type) => MusicTheme.getPrimaryColor(type);
}
