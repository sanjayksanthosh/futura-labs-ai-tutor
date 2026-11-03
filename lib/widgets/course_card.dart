import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';
import 'glass_card.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String instructor;
  final String? thumbnail;
  final String category;
  final String difficulty;
  final double progress;
  final double rating;
  final int totalLessons;
  final int durationMinutes;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;

  const CourseCard({
    super.key,
    required this.title,
    required this.instructor,
    this.thumbnail,
    required this.category,
    this.difficulty = 'Beginner',
    this.progress = 0,
    this.rating = 0,
    this.totalLessons = 0,
    this.durationMinutes = 0,
    this.isBookmarked = false,
    this.onTap,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: thumbnail != null
                      ? CachedNetworkImage(
                          imageUrl: thumbnail!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: isDark ? Colors.white12 : Colors.grey[200],
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            child: const Icon(Icons.school, size: 40),
                          ),
                        )
                      : Container(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(Icons.school, size: 40),
                        ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onBookmark,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      size: 18,
                      color: isBookmarked ? AppColors.accent : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              if (progress > 0)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    color: Colors.black12,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.gradientPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(Icons.access_time, '$durationMinutes min', isDark),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.menu_book, '$totalLessons lessons', isDark),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: AppColors.warning),
                          const SizedBox(width: 2),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: isDark ? Colors.white38 : AppColors.textLight),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white38 : AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
