import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
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
      child: GlassmorphicContainer(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        borderRadius: borderRadius,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MusicTheme.glassBackground,
            MusicTheme.glassBackground.withOpacity( 0.1),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MusicTheme.glassBorder,
            MusicTheme.glassBorder.withOpacity( 0.3),
          ],
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
