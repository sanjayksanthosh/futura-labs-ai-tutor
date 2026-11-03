import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/app_colors.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.white12 : AppColors.shimmerBase,
      highlightColor: isDark ? Colors.white24 : AppColors.shimmerHighlight,
      child: widget.child,
    );
  }
}

class AnimatedShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const AnimatedShimmerList({
    super.key,
    this.itemCount = 4,
    this.itemHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerLoading(
            child: Container(
              height: itemHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      }),
    );
  }
}
