import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/course_provider.dart';
import '../../../providers/analytics_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/course_card.dart';
import '../../../widgets/skeleton_loader.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<AnalyticsProvider>().loadAnalytics(user.id);
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildAiAssistantCard(context),
                const SizedBox(height: 20),
                _buildDashboardCards(context),
                const SizedBox(height: 20),
                _buildContinueLearning(context),
                const SizedBox(height: 20),
                _buildRecommendedCourses(context),
                const SizedBox(height: 20),
                _buildWeeklyProgressChart(context),
                const SizedBox(height: 20),
                _buildRecentActivity(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user?.name.split(' ').first ?? 'Learner'}! 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.05),
            const SizedBox(height: 4),
            Text(
              'Ready to learn something new?',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildStreakBadge(context),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 22,
              backgroundImage: user?.avatar != null
                  ? NetworkImage(user!.avatar!)
                  : null,
              child: user?.avatar == null
                  ? Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakBadge(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.warning, AppColors.accent]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            '${user?.streak ?? 0}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiAssistantCard(BuildContext context) {
    return GlassCard(
      gradient: AppColors.gradientOcean,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'AI Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'I recommend you continue with\nMachine Learning Fundamentals',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Continue',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.smart_toy_outlined,
            size: 60,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCards(BuildContext context) {
    return Consumer2<AuthProvider, AnalyticsProvider>(
      builder: (_, auth, analytics, __) {
        final stats = analytics.completionStats;
        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (_, index) {
            switch (index) {
              case 0:
                return _dashboardCard(
                  'Total Courses',
                  '${stats.totalCourses}',
                  Icons.menu_book,
                  AppColors.primary,
                  '${stats.completedCourses} completed',
                );
              case 1:
                return _dashboardCard(
                  'Completed',
                  '${stats.completedLessons}',
                  Icons.check_circle,
                  AppColors.success,
                  'of ${stats.totalLessons} lessons',
                );
              case 2:
                return _dashboardCard(
                  'AI Score',
                  '${auth.user?.aiScore.toInt() ?? 0}',
                  Icons.auto_awesome,
                  AppColors.accent,
                  'points',
                );
              case 3:
                return _dashboardCard(
                  'Hours Learned',
                  '${stats.totalHoursLearned}h',
                  Icons.timer,
                  AppColors.warning,
                  'this month',
                );
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _dashboardCard(
      String title, String value, IconData icon, Color color, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueLearning(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<CourseProvider>(
      builder: (_, cp, __) {
        if (cp.isLoading) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader(height: 20, width: 200),
              SizedBox(height: 12),
              CardSkeleton(height: 160),
            ],
          );
        }
        final inProgress = cp.inProgressCourses;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Continue Learning',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: inProgress.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final course = inProgress[i];
                  return SizedBox(
                    width: 260,
                    child: CourseCard(
                      title: course.title,
                      instructor: course.instructor,
                      thumbnail: course.thumbnail,
                      category: course.category,
                      difficulty: course.difficulty,
                      progress: course.progress,
                      rating: course.rating,
                      totalLessons: course.totalLessons,
                      durationMinutes: course.durationMinutes,
                      isBookmarked: course.isBookmarked,
                      onTap: () => context.push(
                        '/course-detail',
                        extra: course.id,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecommendedCourses(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<CourseProvider>(
      builder: (_, cp, __) {
        if (cp.isLoading) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader(height: 20, width: 200),
              SizedBox(height: 12),
              CardSkeleton(height: 160),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 18, color: AppColors.accent),
                    const SizedBox(width: 6),
                    Text(
                      'Recommended for You',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cp.recommendedCourses.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final course = cp.recommendedCourses[i];
                  return SizedBox(
                    width: 260,
                    child: CourseCard(
                      title: course.title,
                      instructor: course.instructor,
                      thumbnail: course.thumbnail,
                      category: course.category,
                      difficulty: course.difficulty,
                      progress: course.progress,
                      rating: course.rating,
                      totalLessons: course.totalLessons,
                      durationMinutes: course.durationMinutes,
                      isBookmarked: course.isBookmarked,
                      onTap: () => context.push(
                        '/course-detail',
                        extra: course.id,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeeklyProgressChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<AnalyticsProvider>(
      builder: (_, analytics, __) {
        final data = analytics.weeklyProgress;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16, left: 8),
                child: data.isEmpty
                    ? const Center(child: Text('No data yet'))
                    : BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 4,
                          barGroups: data.asMap().entries.map((e) {
                            return BarChartGroupData(
                              x: e.key,
                              barRods: [
                                BarChartRodData(
                                  toY: e.value.hours.toDouble(),
                                  color: AppColors.primary,
                                  width: 18,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6)),
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  final idx = value.toInt();
                                  if (idx >= 0 && idx < data.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        data[idx].day,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? Colors.white60
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<AnalyticsProvider>(
      builder: (_, analytics, __) {
        final activities = analytics.activities;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),
            if (activities.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No recent activity'),
              )
            else
              ...activities.take(3).map((a) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.cardDark
                          : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _activityColor(a.type).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _activityIcon(a.type),
                            color: _activityColor(a.type),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                a.description,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white60 : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _timeAgo(a.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white38 : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
        );
      },
    );
  }

  IconData _activityIcon(String type) {
    switch (type) {
      case 'lesson':
        return Icons.menu_book;
      case 'quiz':
        return Icons.quiz;
      case 'achievement':
        return Icons.emoji_events;
      case 'course':
        return Icons.school;
      case 'assignment':
        return Icons.assignment;
      default:
        return Icons.notifications;
    }
  }

  Color _activityColor(String type) {
    switch (type) {
      case 'lesson':
        return AppColors.primary;
      case 'quiz':
        return AppColors.warning;
      case 'achievement':
        return AppColors.accent;
      case 'course':
        return AppColors.secondary;
      case 'assignment':
        return AppColors.success;
      default:
        return AppColors.textLight;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'now';
  }
}

