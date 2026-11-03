import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/page_header.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadAdminData();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const PageHeader(
                      title: 'Admin Panel',
                      subtitle: 'Institution Management',
                      trailing: Icon(Icons.admin_panel_settings, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              _buildTabBar(context),
              Expanded(
                child: Consumer<AdminProvider>(
                  builder: (_, admin, __) {
                    if (admin.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    switch (_tabIndex) {
                      case 0:
                        return _buildOverviewTab(context, admin);
                      case 1:
                        return _buildStudentsTab(context, admin);
                      case 2:
                        return _buildBatchesTab(context, admin);
                      default:
                        return _buildFacultyTab(context, admin);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _tabItem('Overview', 0),
          const SizedBox(width: 8),
          _tabItem('Students', 1),
          const SizedBox(width: 8),
          _tabItem('Batches', 2),
          const SizedBox(width: 8),
          _tabItem('Faculty', 3),
        ],
      ),
    );
  }

  Widget _tabItem(String label, int index) {
    final selected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? null
              : Border.all(color: AppColors.textLight.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, AdminProvider admin) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reports = admin.reports;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _overviewCard(
                'Total Students',
                '${reports['totalStudents'] ?? 0}',
                Icons.people,
                AppColors.primary,
                isDark,
              ),
              const SizedBox(width: 12),
              _overviewCard(
                'Active Students',
                '${reports['activeStudents'] ?? 0}',
                Icons.person_pin,
                AppColors.success,
                isDark,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _overviewCard(
                'Courses',
                '${reports['totalCourses'] ?? 0}',
                Icons.menu_book,
                AppColors.accent,
                isDark,
              ),
              const SizedBox(width: 12),
              _overviewCard(
                'Hours Learned',
                '${reports['totalHoursLearned'] ?? 0}h',
                Icons.timer,
                AppColors.warning,
                isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Overview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _perfItem('Avg. Completion', '${reports['averageCompletionRate'] ?? 0}%', AppColors.primary),
                    _perfItem('Avg. Score', '${reports['averageScore'] ?? 0}%', AppColors.success),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: SizedBox(
              height: 180,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16, left: 8),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barGroups: admin.batches.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value['avgProgress'] as double,
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
                            if (idx >= 0 && idx < admin.batches.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Batch ${idx + 1}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
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
          ),
        ],
      ),
    );
  }

  Widget _overviewCard(String title, String value, IconData icon,
      Color color, bool isDark) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white60 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _perfItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab(BuildContext context, AdminProvider admin) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final students = admin.students;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      itemBuilder: (_, i) {
        final s = students[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage:
                    NetworkImage(s['avatar'] as String),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${s['courseCount']} courses | ${s['completionRate']}% complete',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (s['status'] == 'active'
                          ? AppColors.success
                          : AppColors.textLight)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (s['status'] as String).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: s['status'] == 'active'
                        ? AppColors.success
                        : AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBatchesTab(BuildContext context, AdminProvider admin) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: admin.batches.length,
      itemBuilder: (_, i) {
        final b = admin.batches[i];
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    b['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${b['studentCount']} students',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                b['course'] as String,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _batchStat('Progress', '${b['avgProgress']}%'),
                  const SizedBox(width: 16),
                  _batchStat('Avg Score', '${b['avgScore']}%'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _batchStat(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFacultyTab(BuildContext context, AdminProvider admin) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: admin.faculty.length,
      itemBuilder: (_, i) {
        final f = admin.faculty[i];
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage:
                    NetworkImage(f['avatar'] as String),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      f['department'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${f['courses']} courses | ${f['students']} students',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: AppColors.warning),
                  const SizedBox(width: 2),
                  Text(
                    '${f['rating']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
