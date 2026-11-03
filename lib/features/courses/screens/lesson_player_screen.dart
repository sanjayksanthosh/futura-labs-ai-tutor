import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/course_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';

class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  late int _lessonIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _lessonIndex = args['lessonIndex'] as int;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<CourseProvider>(
      builder: (_, cp, __) {
        final course = cp.selectedCourse;
        if (course == null || _lessonIndex >= course.lessons.length) {
          return const Scaffold(body: Center(child: Text('Lesson not found')));
        }
        final lesson = course.lessons[_lessonIndex];

        return Scaffold(
          body: Container(
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
              child: Column(
                children: [
                  _buildTopBar(context, lesson),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildVideoPlaceholder(context),
                          const SizedBox(height: 16),
                          _buildLessonContent(context, lesson),
                          const SizedBox(height: 16),
                          if (lesson.keyPoints != null)
                            _buildKeyPoints(context, lesson.keyPoints!),
                          if (lesson.summary != null) ...[
                            const SizedBox(height: 16),
                            _buildSummary(context, lesson.summary!),
                          ],
                          const SizedBox(height: 24),
                          _buildAiPanel(context, lesson),
                          const SizedBox(height: 24),
                          GradientButton(
                            label: lesson.isCompleted
                                ? '✓ Completed'
                                : 'Mark as Complete',
                            colors: lesson.isCompleted
                                ? [AppColors.success, AppColors.success]
                                : null,
                            onPressed: lesson.isCompleted
                                ? null
                                : () {
                                    cp.markLessonComplete(lesson.id);
                                    setState(() {});
                                  },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, dynamic lesson) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              lesson.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              lesson.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: lesson.isBookmarked ? AppColors.accent : null,
            ),
            onPressed: () =>
                context.read<CourseProvider>().toggleLessonBookmark(lesson.id),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlaceholder(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: AppColors.gradientPrimary,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Video Player',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonContent(BuildContext context, dynamic lesson) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: MarkdownBody(
        data: lesson.content,
        styleSheet: MarkdownStyleSheet(
          h1: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          h2: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          p: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : AppColors.textSecondary,
            height: 1.6,
          ),
          listBullet: TextStyle(
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyPoints(BuildContext context, List<String> keyPoints) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Text(
                'Key Points',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...keyPoints.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.primary)),
                    Expanded(
                      child: Text(
                        p,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, String summary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      gradient: [AppColors.primary.withValues(alpha: 0.05), AppColors.secondary.withValues(alpha: 0.05)],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.summarize, color: AppColors.secondary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Summary',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  summary,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiPanel(BuildContext context, dynamic lesson) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      gradient: [AppColors.primary.withValues(alpha: 0.1), AppColors.accent.withValues(alpha: 0.05)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'AI Tutor',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Ask a question about this lesson...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDark ? Colors.white12 : Colors.white,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send, size: 16),
              label: const Text('Ask AI'),
            ),
          ),
        ],
      ),
    );
  }
}
