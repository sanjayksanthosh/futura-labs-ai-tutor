import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/assessment_provider.dart';
import '../../../widgets/gradient_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  int _elapsedSeconds = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = ModalRoute.of(context)?.settings.arguments as String?;
      if (id != null) {
        context.read<AssessmentProvider>().startAssessment(id);
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final ap = context.read<AssessmentProvider>();
      ap.tickTimer();
      _elapsedSeconds++;
      if (ap.timeRemaining <= 0) {
        _submitQuiz();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submitQuiz() async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    _timer?.cancel();
    final ap = context.read<AssessmentProvider>();
    await ap.submitAssessment(timeTakenSeconds: _elapsedSeconds);
    if (mounted) {
      context.go('/quiz-result');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Consumer<AssessmentProvider>(
        builder: (_, ap, __) {
          if (ap.isLoading && ap.currentAssessment == null) {
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
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final assessment = ap.currentAssessment;
          if (assessment == null) {
            return const Center(child: Text('Assessment not found'));
          }

          final totalQuestions = assessment.questions.length;

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
                children: [
                  _buildTopBar(context, ap, totalQuestions),
                  _buildProgressBar(context, ap, totalQuestions),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (i) =>
                          setState(() => _currentPage = i),
                      itemCount: totalQuestions,
                      itemBuilder: (_, i) {
                        final q = assessment.questions[i];
                        return _buildQuestionCard(context, q, i, ap);
                      },
                    ),
                  ),
                  _buildBottomNav(context, ap, totalQuestions),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(
      BuildContext context, AssessmentProvider ap, int total) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showExitDialog(context),
          ),
          const Spacer(),
          Text(
            'Question ${_currentPage + 1}/$total',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ap.timeRemaining < 60
                  ? AppColors.error.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: ap.timeRemaining < 60 ? AppColors.error : AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTime(ap.timeRemaining),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: ap.timeRemaining < 60
                        ? AppColors.error
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
      BuildContext context, AssessmentProvider ap, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: ap.answeredCount / total,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          minHeight: 4,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, dynamic question,
      int index, AssessmentProvider ap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _difficultyColor(question.difficulty)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  question.difficulty,
                  style: TextStyle(
                    fontSize: 11,
                    color: _difficultyColor(question.difficulty),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  question.category,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => ap.toggleMarkForReview(index),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: question.isMarkedForReview
                        ? AppColors.warning.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: question.isMarkedForReview
                          ? AppColors.warning
                          : Colors.transparent,
                    ),
                  ),
                  child: Icon(
                    Icons.flag,
                    size: 18,
                    color: question.isMarkedForReview
                        ? AppColors.warning
                        : AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ...question.options.asMap().entries.map((entry) {
            final optIdx = entry.key;
            final option = entry.value;
            final isSelected = question.selectedAnswer == optIdx;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => ap.selectAnswer(index, optIdx),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : isDark
                            ? AppColors.cardDark
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : isDark
                              ? Colors.white12
                              : AppColors.textLight.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textLight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + (optIdx as int)),
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : AppColors.textLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomNav(
      BuildContext context, AssessmentProvider ap, int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            OutlinedButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Previous'),
            ),
          if (_currentPage > 0) const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Answered: ${ap.answeredCount}/$total | Marked: ${ap.markedForReviewCount}',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (_currentPage < total - 1)
            GradientButton(
              label: 'Next',
              width: 100,
              height: 44,
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          if (_currentPage == total - 1)
            GradientButton(
              label: 'Submit',
              width: 120,
              height: 44,
              colors: [AppColors.success, AppColors.secondary],
              onPressed: () => _showSubmitConfirmDialog(context),
            ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave Quiz?'),
        content:
            const Text('Your progress will be lost if you leave now.'),
        actions: [
          TextButton(
          onPressed: () => context.pop(),
          child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              context.pop();
              context.read<AssessmentProvider>().resetAssessment();
            },
            child: const Text('Leave', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showSubmitConfirmDialog(BuildContext context) {
    final ap = context.read<AssessmentProvider>();
    final unanswered =
        ap.totalQuestions - ap.answeredCount;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: Text(
          'You have answered $unanswered out of ${ap.totalQuestions} questions.',
        ),
        actions: [
          TextButton(
          onPressed: () => context.pop(),
          child: const Text('Review'),
          ),
          GradientButton(
            label: 'Submit',
            width: 120,
            height: 40,
            onPressed: () {
              context.pop();
              _submitQuiz();
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
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
