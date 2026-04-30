import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum MusicThemeType { emberOdyssey, auroraWave, goldenEclipse, galaxyStorm, immersive }

class MusicTheme {
  // Ember Odyssey Theme
  static const Color emberBg = Color(0xFF0D0501);
  static const Color emberPrimary = Color(0xFFFF4500);
  static const Color emberSecondary = Color(0xFFFF8C00);
  static const Color emberText = Color(0xFFFFD580);

  // Aurora Wave Theme
  static const Color auroraBg = Color(0xFF050A14);
  static const Color auroraPrimary = Color(0xFF00E5FF);
  static const Color auroraSecondary = Color(0xFF7B2FFF);
  static const Color auroraText = Color(0xFFE0F7FF);

  // Golden Eclipse Theme
  static const Color goldenBg = Color(0xFF080600);
  static const Color goldenPrimary = Color(0xFFFFB800);
  static const Color goldenSecondary = Color(0xFFD4820A);
  static const Color goldenText = Color(0xFFFFF3CC);

  // Galaxy Storm Theme
  static const Color galaxyBg = Color(0xFF06030F);
  static const Color galaxyPrimary = Color(0xFF7C3FFF);
  static const Color galaxySecondary = Color(0xFF2D9CFF);
  static const Color galaxyText = Color(0xFFE8DFFF);

  // Immersive/Cosmic Deep Theme
  static const Color immersiveBg = Color(0xFF04020E);
  static const Color immersivePrimary = Color(0xFFC040FF);
  static const Color immersiveSecondary = Color(0xFF4B00CC);
  static const Color immersiveText = Color(0xFFDDD0FF);

  // Glassmorphism colors (universal)
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  static ThemeData getTheme(MusicThemeType type) {
    Color bg, primary, secondary, text;

    switch (type) {
      case MusicThemeType.emberOdyssey:
        bg = emberBg; primary = emberPrimary; secondary = emberSecondary; text = emberText;
        break;
      case MusicThemeType.auroraWave:
        bg = auroraBg; primary = auroraPrimary; secondary = auroraSecondary; text = auroraText;
        break;
      case MusicThemeType.goldenEclipse:
        bg = goldenBg; primary = goldenPrimary; secondary = goldenSecondary; text = goldenText;
        break;
      case MusicThemeType.galaxyStorm:
        bg = galaxyBg; primary = galaxyPrimary; secondary = galaxySecondary; text = galaxyText;
        break;
      case MusicThemeType.immersive:
        bg = immersiveBg; primary = immersivePrimary; secondary = immersiveSecondary; text = immersiveText;
        break;
    }

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: bg.withOpacity( 0.8),
        onPrimary: type == MusicThemeType.goldenEclipse ? const Color(0xFF080600) : bg,
        onSecondary: bg,
        onSurface: text,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(color: text, fontSize: 32, fontWeight: FontWeight.w700),
        displayMedium: GoogleFonts.orbitron(color: text, fontSize: 24, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: text, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: text.withOpacity( 0.7), fontSize: 14),
        labelLarge: GoogleFonts.inter(color: text, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.orbitron(color: text, fontSize: 20, fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(color: text),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: type == MusicThemeType.goldenEclipse ? const Color(0xFF080600) : bg,
          elevation: 4,
          shadowColor: primary.withOpacity( 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          foregroundColor: primary,
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: glassBorder,
        thumbColor: primary,
        overlayColor: primary.withOpacity( 0.2),
        trackHeight: 4,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bg.withOpacity( 0.95),
        selectedItemColor: primary,
        unselectedItemColor: text.withOpacity( 0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
      ),
    );
  }

  static BoxShadow neonShadow(Color color, {double blurRadius = 12}) {
    return BoxShadow(color: color.withOpacity( 0.6), blurRadius: blurRadius, spreadRadius: 2);
  }

  static BoxDecoration glassDecoration(Color glowColor, {double borderRadius = 16}) {
    return BoxDecoration(
      color: glassBackground,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: glassBorder, width: 1),
      boxShadow: [neonShadow(glowColor, blurRadius: 8)],
    );
  }

  static Color getPrimaryColor(MusicThemeType type) {
    switch (type) {
      case MusicThemeType.emberOdyssey: return emberPrimary;
      case MusicThemeType.auroraWave: return auroraPrimary;
      case MusicThemeType.goldenEclipse: return goldenPrimary;
      case MusicThemeType.galaxyStorm: return galaxyPrimary;
      case MusicThemeType.immersive: return immersivePrimary;
    }
  }

  static Color getTextColor(MusicThemeType type) {
    switch (type) {
      case MusicThemeType.emberOdyssey: return emberText;
      case MusicThemeType.auroraWave: return auroraText;
      case MusicThemeType.goldenEclipse: return goldenText;
      case MusicThemeType.galaxyStorm: return galaxyText;
      case MusicThemeType.immersive: return immersiveText;
    }
  }

  static Color getSecondaryColor(MusicThemeType type) {
    switch (type) {
      case MusicThemeType.emberOdyssey: return emberSecondary;
      case MusicThemeType.auroraWave: return auroraSecondary;
      case MusicThemeType.goldenEclipse: return goldenSecondary;
      case MusicThemeType.galaxyStorm: return galaxySecondary;
      case MusicThemeType.immersive: return immersiveSecondary;
    }
  }

  static BoxDecoration cosmicBackground(MusicThemeType type) {
    Color bg1, bg2, bg3;
    switch (type) {
      case MusicThemeType.emberOdyssey:
        bg1 = emberBg; bg2 = const Color(0xFF1A0A02); bg3 = const Color(0xFF0F0500);
        break;
      case MusicThemeType.auroraWave:
        bg1 = auroraBg; bg2 = const Color(0xFF0A1428); bg3 = const Color(0xFF050A14);
        break;
      case MusicThemeType.goldenEclipse:
        bg1 = goldenBg; bg2 = const Color(0xFF1A1400); bg3 = const Color(0xFF0D0900);
        break;
      case MusicThemeType.galaxyStorm:
        bg1 = galaxyBg; bg2 = const Color(0xFF0C06A3); bg3 = const Color(0xFF06030F);
        break;
      case MusicThemeType.immersive:
        bg1 = immersiveBg; bg2 = const Color(0xFF080428); bg3 = const Color(0xFF04020E);
        break;
    }
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [bg1, bg2, bg3],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }
}
