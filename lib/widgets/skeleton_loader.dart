import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/app_colors.dart';

class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.white12 : AppColors.shimmerBase,
      highlightColor: isDark ? Colors.white24 : AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? Colors.white12 : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class CardSkeleton extends StatelessWidget {
  final double height;

  const CardSkeleton({super.key, this.height = 180});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(height: 20, width: 200),
          SizedBox(height: 12),
          SkeletonLoader(height: 14),
          SizedBox(height: 8),
          SkeletonLoader(height: 14, width: 150),
          SizedBox(height: 16),
          SkeletonLoader(height: 8),
          SizedBox(height: 8),
          SkeletonLoader(height: 8, width: 100),
        ],
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  final int count;
  final double itemHeight;

  const ListSkeleton({super.key, this.count = 3, this.itemHeight = 100});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (_) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          height: itemHeight,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              SkeletonLoader(width: 60, height: 60, borderRadius: 12),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonLoader(height: 16, width: 150),
                    SizedBox(height: 8),
                    SkeletonLoader(height: 12),
                    SizedBox(height: 4),
                    SkeletonLoader(height: 12, width: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
