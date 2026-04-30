import 'package:flutter/material.dart';

class ElasticSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color textColor;

  const ElasticSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
    required this.textColor,
  });

  @override
  State<ElasticSlider> createState() => _ElasticSliderState();
}

class _ElasticSliderState extends State<ElasticSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(covariant ElasticSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _currentValue = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChange(double value) {
    setState(() => _currentValue = value);
    widget.onChanged(value);
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: widget.activeColor,
                  inactiveTrackColor: widget.inactiveColor,
                  thumbColor: widget.activeColor,
                  overlayColor: widget.activeColor.withOpacity(0.2),
                  trackHeight: 4,
                  thumbShape: const _GlowingThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: _currentValue,
                  onChanged: _handleChange,
                ),
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1:24', style: TextStyle(fontSize: 12, color: widget.textColor.withOpacity(0.5))),
            Text('3:58', style: TextStyle(fontSize: 12, color: widget.textColor.withOpacity(0.5))),
          ],
        ),
      ],
    );
  }
}

class _GlowingThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;

  const _GlowingThumbShape({this.enabledThumbRadius = 6.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..color = sliderTheme.thumbColor!.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center, enabledThumbRadius + 4, glowPaint);
    canvas.drawCircle(center, enabledThumbRadius, paint);
  }
}
