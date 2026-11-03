import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/course_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/skeleton_loader.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = ModalRoute.of(context)?.settings.arguments as String?;
      if (id != null) {
        context.read<CourseProvider>().loadCourseDetail(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Consumer<CourseProvider>(
        builder: (_, cp, __) {
          if (cp.isLoading) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.surfaceDark, AppColors.backgroundDark]
                      : [const Color(0xFFF0F0FF), const Color(0xFFF8F9FE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SkeletonLoader(height: 200, borderRadius: 16),
                      const SizedBox(height: 16),
                      const SkeletonLoader(height: 24, width: 250),
                      const SizedBox(height: 8),
                      const SkeletonLoader(height: 16, width: 180),
                      const SizedBox(height: 16),
                      const CardSkeleton(height: 120),
                    ],
                  ),
                ),
              ),
            );
          }

          final course = cp.selectedCourse;
          if (course == null) {
            return const Center(child: Text('Course not found'));
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.surfaceDark, AppColors.backgroundDark]
                    : [const Color(0xFFF0F0FF), const Color(0xFFF8F9FE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, course),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCourseInfo(context, course),
                          const SizedBox(height: 16),
                          _buildAboutSection(context, course),
                          const SizedBox(height: 16),
                          _buildInstructorSection(context, course),
                          const SizedBox(height: 16),
                          _buildLessonsSection(context, cp),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic course) {
    return Stack(
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.gradientPrimary,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  const Spacer(),
                  Text(
                    course.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        course.instructor,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${course.rating}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: IconButton(
            icon: Icon(
              course.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () => context.read<CourseProvider>().toggleBookmark(course.id),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseInfo(BuildContext context, dynamic course) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoItem(Icons.menu_book, '${course.totalLessons}', 'Lessons', isDark),
          _infoItem(Icons.access_time, '${course.durationMinutes}m', 'Duration', isDark),
          _infoItem(Icons.people, '${course.studentCount}', 'Students', isDark),
          _infoItem(
            Icons.signal_cellular_alt,
            course.difficulty,
            'Level',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String value, String label, bool isDark) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white60 : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, dynamic course) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Course',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          course.description,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        if (course.prerequisites.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Prerequisites',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: course.prerequisites.map((p) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  p,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildInstructorSection(BuildContext context, dynamic course) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              course.instructor.split(' ').map((s) => s[0]).take(2).join(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.instructor,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Course Instructor',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildLessonsSection(BuildContext context, CourseProvider cp) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final course = cp.selectedCourse!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Course Content',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Text(
              '${course.completedLessons}/${course.totalLessons}',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: course.progress / 100,
            backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 12),
        ...course.lessons.asMap().entries.map((entry) {
          final i = entry.key;
          final lesson = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.transparent,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: lesson.isCompleted
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  lesson.isCompleted
                      ? Icons.check_circle
                      : Icons.play_circle_outline,
                  color: lesson.isCompleted ? AppColors.success : AppColors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                lesson.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                '${lesson.durationMinutes} min',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white60 : AppColors.textSecondary,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (lesson.isBookmarked)
                    const Icon(Icons.bookmark, size: 16, color: AppColors.accent),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
              onTap: () {
                context.push(
                  '/lesson-player',
                  extra: {
                    'courseId': course.id,
                    'lessonIndex': i,
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
