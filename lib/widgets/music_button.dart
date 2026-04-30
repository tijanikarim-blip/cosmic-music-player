import 'package:flutter/material.dart';
import '../core/theme/music_theme.dart';

class MusicButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final MusicThemeType? themeType;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isOutlined;
  final IconData? icon;

  const MusicButton({
    super.key,
    required this.label,
    this.onPressed,
    this.themeType,
    this.color,
    this.textColor,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.isOutlined = false,
    this.icon,
  }) : assert(themeType != null || color != null, 'Either themeType or color must be provided');

  Color _getColor() {
    if (color != null) return color!;
    return MusicTheme.getPrimaryColor(themeType!);
  }

  Color _getTextColor() {
    if (textColor != null) return textColor!;
    if (themeType == MusicThemeType.goldenEclipse) return const Color(0xFF080600);
    if (themeType == MusicThemeType.emberOdyssey) return const Color(0xFF0D0501);
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final btnColor = _getColor();
    final txtColor = _getTextColor();
    return isOutlined
        ? OutlinedButton.icon(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: btnColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: padding,
              shadowColor: btnColor.withOpacity( 0.3),
              elevation: 0,
            ),
            icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
            label: Text(
              label,
              style: TextStyle(
                color: btnColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              foregroundColor: txtColor,
              shadowColor: btnColor.withOpacity( 0.5),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: padding,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
            label: Text(label),
          );
  }
}
