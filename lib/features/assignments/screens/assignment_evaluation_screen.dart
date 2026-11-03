import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/assignment_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/animated_progress.dart';

class AssignmentEvaluationScreen extends StatefulWidget {
  const AssignmentEvaluationScreen({super.key});

  @override
  State<AssignmentEvaluationScreen> createState() =>
      _AssignmentEvaluationScreenState();
}

class _AssignmentEvaluationScreenState
    extends State<AssignmentEvaluationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = ModalRoute.of(context)?.settings.arguments as String?;
      if (id != null) {
        context.read<AssignmentProvider>().evaluateAssignment(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          child: Consumer<AssignmentProvider>(
            builder: (_, ap, __) {
              if (ap.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final evaluation = ap.lastEvaluation;
              if (evaluation == null) {
                return const Center(child: Text('No evaluation data'));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildHeader(context, evaluation),
                    const SizedBox(height: 24),
                    _buildScoreSection(context, evaluation),
                    const SizedBox(height: 24),
                    _buildStrengthsSection(context, evaluation),
                    const SizedBox(height: 16),
                    _buildImprovementsSection(context, evaluation),
                    const SizedBox(height: 16),
                    _buildSuggestionsSection(context, evaluation),
                    const SizedBox(height: 24),
                    GradientButton(
                      label: 'Back to Assignments',
                      onPressed: () {
                        ap.clearEvaluation();
                        context.pop();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic evaluation) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Evaluation Complete',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your assignment has been evaluated by AI',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSection(BuildContext context, dynamic evaluation) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: Column(
        children: [
          AnimatedCircularIndicator(
            value: evaluation.score / 100,
            centerText: '${evaluation.score.toInt()}',
            gradientColors: evaluation.score >= 80
                ? AppColors.gradientSecondary
                : evaluation.score >= 60
                    ? AppColors.gradientSunset
                    : [AppColors.error, AppColors.accent],
          ),
          const SizedBox(height: 16),
          Text(
            evaluation.feedback,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsSection(BuildContext context, dynamic evaluation) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.thumb_up, color: AppColors.success, size: 18),
              const SizedBox(width: 8),
              Text(
                'Strengths',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...evaluation.strengths.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, size: 16, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white70
                              : AppColors.textSecondary,
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

  Widget _buildImprovementsSection(BuildContext context, dynamic evaluation) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.warning, size: 18),
              const SizedBox(width: 8),
              Text(
                'Areas for Improvement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...evaluation.improvements.map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_upward,
                        size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        i,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white70
                              : AppColors.textSecondary,
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

  Widget _buildSuggestionsSection(BuildContext context, dynamic evaluation) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Suggestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...evaluation.suggestions.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white70
                              : AppColors.textSecondary,
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
}
