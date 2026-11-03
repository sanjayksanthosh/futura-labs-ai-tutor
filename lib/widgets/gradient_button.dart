import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final List<Color>? colors;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.colors,
    this.width,
    this.height = 52,
    this.icon,
    this.isLoading = false,
    this.padding,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  final _colors = <Color>[];

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.colors ?? AppColors.gradientPrimary;
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: GestureDetector(
          onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
          onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: isDisabled
                    ? gradientColors.map((c) => c.withValues(alpha: 0.5)).toList()
                    : gradientColors,
              ),
              boxShadow: isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: gradientColors.first.withValues(alpha: _isPressed ? 0.15 : 0.35),
                        blurRadius: _isPressed ? 8 : 14,
                        offset: Offset(0, _isPressed ? 2 : 5),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isDisabled ? null : widget.onPressed,
                borderRadius: BorderRadius.circular(14),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: isDisabled ? 0.6 : 1.0,
                  child: Center(
                    child: Padding(
                      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24),
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(widget.icon, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  widget.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
