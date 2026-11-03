import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/analytics_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/page_header.dart';


class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<AnalyticsProvider>().loadAnalytics(user.id);
      }
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
        child: Consumer<AnalyticsProvider>(
          builder: (_, analytics, __) {
            if (analytics.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(
                    title: 'Your Analytics',
                    subtitle: 'Track your learning journey',
                  ),
                  const SizedBox(height: 16),
                  _buildCompletionStats(context, analytics),
                  const SizedBox(height: 16),
                  _buildWeeklyProgressChart(context, analytics),
                  const SizedBox(height: 16),
                  _buildSkillRadar(context, analytics),
                  const SizedBox(height: 16),
                  _buildPerformanceChart(context, analytics),
                  const SizedBox(height: 16),
                  _buildAiRecommendations(context, analytics),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompletionStats(BuildContext context, AnalyticsProvider ap) {
    final stats = ap.completionStats;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                '${stats.completedLessons}/${stats.totalLessons} lessons',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _progressItem(
                'Courses',
                stats.totalCourses,
                stats.completedCourses,
                AppColors.primary,
              ),
              const SizedBox(width: 12),
              _progressItem(
                'Lessons',
                stats.totalLessons,
                stats.completedLessons,
                AppColors.secondary,
              ),
              const SizedBox(width: 12),
              _progressItem(
                'Quizzes',
                stats.totalQuizzes,
                stats.completedQuizzes,
                AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressItem(
      String label, int total, int completed, Color color) {
    final rate = total > 0 ? completed / total : 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: rate,
                  strokeWidth: 5,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(color),
                  strokeCap: StrokeCap.round,
                ),
                Text(
                  '${(rate * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
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

  Widget _buildWeeklyProgressChart(
      BuildContext context, AnalyticsProvider ap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = ap.weeklyProgress;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Learning Hours',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: data.isEmpty
                ? const Center(child: Text('No data'))
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
                              width: 20,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                            ),
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
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
        ],
      ),
    );
  }

  Widget _buildSkillRadar(BuildContext context, AnalyticsProvider ap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skills = ap.skills;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skill Proficiency',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...skills.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          s.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${s.proficiency.toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: _skillColor(s.proficiency),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: s.proficiency / 100,
                        backgroundColor:
                            _skillColor(s.proficiency).withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation(
                            _skillColor(s.proficiency)),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Color _skillColor(double value) {
    if (value >= 80) return AppColors.success;
    if (value >= 50) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildPerformanceChart(
      BuildContext context, AnalyticsProvider ap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final performances = ap.performance;
    if (performances.isEmpty) return const SizedBox.shrink();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Trends',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineBarsData: performances.asMap().entries.map((e) {
                  final colors = [
                    AppColors.primary,
                    AppColors.secondary,
                    AppColors.accent,
                  ];
                  return LineChartBarData(
                    spots: e.value.scores
                        .asMap()
                        .entries
                        .map((s) => FlSpot(
                            s.key.toDouble(), s.value))
                        .toList(),
                    color: colors[e.key % colors.length],
                    barWidth: 2.5,
                    dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: colors[e.key % colors.length],
                        strokeWidth: 0,
                      );
                    }),
                    isCurved: true,
                    curveSmoothness: 0.3,
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (performances.isNotEmpty &&
                            idx < performances.first.labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              performances.first.labels[idx].length > 6
                                  ? performances.first.labels[idx]
                                      .substring(0, 6)
                                  : performances.first.labels[idx],
                              style: TextStyle(
                                fontSize: 9,
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: isDark ? Colors.white10 : Colors.grey[200]!,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiRecommendations(
      BuildContext context, AnalyticsProvider ap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recs = ap.recommendations;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, size: 18, color: AppColors.accent),
            const SizedBox(width: 6),
            Text(
              'AI Recommendations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recs.map((r) => GlassCard(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _recPriorityColor(r.priority)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      r.type == 'course'
                          ? Icons.school
                          : r.type == 'practice'
                              ? Icons.touch_app
                              : Icons.article,
                      color: _recPriorityColor(r.priority),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          r.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white60
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _recPriorityColor(r.priority)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      r.priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        color: _recPriorityColor(r.priority),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Color _recPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.textLight;
    }
  }
}
