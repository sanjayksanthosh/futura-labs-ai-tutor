import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/assessment_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/page_header.dart';
import '../../../widgets/skeleton_loader.dart';
import '../../../widgets/empty_state.dart';

class AssessmentListScreen extends StatefulWidget {
  const AssessmentListScreen({super.key});

  @override
  State<AssessmentListScreen> createState() => _AssessmentListScreenState();
}

class _AssessmentListScreenState extends State<AssessmentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssessmentProvider>().loadAssessments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Assessments',
              subtitle: 'Test your knowledge',
            ),
            Expanded(
              child: Consumer<AssessmentProvider>(
                builder: (_, ap, __) {
                  if (ap.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CardSkeleton(height: 120),
                          CardSkeleton(height: 120),
                          CardSkeleton(height: 120),
                        ],
                      ),
                    );
                  }

                  if (ap.assessments.isEmpty) {
                    return const EmptyState(
                      icon: Icons.quiz_outlined,
                      title: 'No assessments yet',
                      subtitle: 'Check back later for new quizzes',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: ap.assessments.length,
                    itemBuilder: (_, i) {
                      final a = ap.assessments[i];
                      return _buildAssessmentCard(context, a);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard(BuildContext context, dynamic assessment) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        context.push(
          '/quiz',
          extra: assessment.id,
        );
      },
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _difficultyColor(assessment.difficulty).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.quiz,
              color: _difficultyColor(assessment.difficulty),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assessment.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  assessment.courseName,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _chip(
                      '${assessment.questions.length} Qs',
                      AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    _chip(
                      '${assessment.durationMinutes} min',
                      AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    _chip(
                      assessment.difficulty,
                      _difficultyColor(assessment.difficulty),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
