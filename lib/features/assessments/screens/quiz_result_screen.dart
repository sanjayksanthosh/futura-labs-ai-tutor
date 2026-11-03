import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/assessment_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/animated_progress.dart';
import '../../../widgets/gradient_button.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Consumer<AssessmentProvider>(
        builder: (_, ap, __) {
          final result = ap.lastResult;
          if (result == null) {
            return const Center(child: Text('No result data'));
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildScoreHeader(context, result),
                    const SizedBox(height: 24),
                    _buildStatsGrid(context, result),
                    const SizedBox(height: 24),
                    _buildQuestionReview(context, result),
                    const SizedBox(height: 24),
                    GradientButton(
                      label: 'Back to Assessments',
                      onPressed: () {
                        ap.resetAssessment();
                        context.pop();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreHeader(BuildContext context, dynamic result) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: Column(
        children: [
          AnimatedCircularIndicator(
            value: result.percentage / 100,
            centerText: '${result.percentage.toInt()}%',
            gradientColors: result.percentage >= 80
                ? AppColors.gradientSecondary
                : result.percentage >= 60
                    ? AppColors.gradientSunset
                    : [AppColors.error, AppColors.accent],
          ),
          const SizedBox(height: 16),
          Text(
            result.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Grade: ${result.grade}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: result.percentage >= 80
                  ? AppColors.success
                  : result.percentage >= 60
                      ? AppColors.warning
                      : AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Score: ${result.score}/${result.totalMarks}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, dynamic result) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: _statCard(
            'Correct',
            '${result.correctCount}',
            AppColors.success,
            Icons.check_circle,
            isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            'Incorrect',
            '${result.incorrectCount}',
            AppColors.error,
            Icons.cancel,
            isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            'Unanswered',
            '${result.unansweredCount}',
            AppColors.textLight,
            Icons.help_outline,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon,
      bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildQuestionReview(BuildContext context, dynamic result) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Answers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...result.questions.asMap().entries.map((entry) {
          final i = entry.key;
          final q = entry.value;
          final isCorrect = q.isCorrect;
          final isUnanswered = q.selectedAnswer == null;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUnanswered
                    ? AppColors.textLight.withValues(alpha: 0.3)
                    : isCorrect
                        ? AppColors.success.withValues(alpha: 0.5)
                        : AppColors.error.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isUnanswered
                          ? Icons.help
                          : isCorrect
                              ? Icons.check_circle
                              : Icons.cancel,
                      size: 18,
                      color: isUnanswered
                          ? AppColors.textLight
                          : isCorrect
                              ? AppColors.success
                              : AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Q${i + 1}. ${q.question}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (q.explanation != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            q.explanation!,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white60
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
