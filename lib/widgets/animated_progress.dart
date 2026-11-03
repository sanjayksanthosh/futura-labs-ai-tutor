import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AnimatedProgress extends StatelessWidget {
  final double value;
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? label;

  const AnimatedProgress({
    super.key,
    required this.value,
    this.size = 60,
    this.color,
    this.strokeWidth = 6,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, val, _) {
              return SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: val,
                  strokeWidth: strokeWidth,
                  backgroundColor: (color ?? AppColors.primary).withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(color ?? AppColors.primary),
                  strokeCap: StrokeCap.round,
                ),
              );
            },
          ),
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
                color: color ?? AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}

class AnimatedCircularIndicator extends StatefulWidget {
  final double value;
  final double size;
  final List<Color> gradientColors;
  final double strokeWidth;
  final String centerText;
  final double fontSize;

  const AnimatedCircularIndicator({
    super.key,
    required this.value,
    this.size = 120,
    this.gradientColors = AppColors.gradientPrimary,
    this.strokeWidth = 8,
    this.centerText = '',
    this.fontSize = 24,
  });

  @override
  State<AnimatedCircularIndicator> createState() =>
      _AnimatedCircularIndicatorState();
}

class _AnimatedCircularIndicatorState extends State<AnimatedCircularIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCircularIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _GradientCirclePainter(
            progress: _animation.value * widget.value,
            gradientColors: widget.gradientColors,
            strokeWidth: widget.strokeWidth,
          ),
          child: Center(
            child: Text(
              widget.centerText,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: widget.gradientColors.first,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GradientCirclePainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;
  final double strokeWidth;

  _GradientCirclePainter({
    required this.progress,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = AppColors.shimmerBase.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      colors: gradientColors,
      startAngle: -pi / 2,
      endAngle: -pi / 2 + 2 * pi * progress,
    );
    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant _GradientCirclePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
