import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/assignment_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/skeleton_loader.dart';
import '../../../widgets/empty_state.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignmentProvider>().loadAssignments();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assignments',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Submit and track your work',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<AssignmentProvider>(
                  builder: (_, ap, __) {
                    if (ap.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CardSkeleton(height: 120),
                            CardSkeleton(height: 120),
                          ],
                        ),
                      );
                    }

                    final assignments = ap.assignments;
                    if (assignments.isEmpty) {
                      return const EmptyState(
                        icon: Icons.assignment_outlined,
                        title: 'No assignments yet',
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: assignments.length,
                      itemBuilder: (_, i) {
                        final a = assignments[i];
                        return _buildAssignmentCard(context, a, ap, isDark);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, dynamic assignment,
      AssignmentProvider ap, bool isDark) {
    final statusColors = _statusColor(assignment.status);
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        context.push(
          '/assignment-detail',
          extra: assignment.id,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColors.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.assignment,
                  color: statusColors,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      assignment.courseName,
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
                  color: statusColors.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  assignment.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColors,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time,
                  size: 14,
                  color: isDark ? Colors.white38 : AppColors.textLight),
              const SizedBox(width: 4),
              Text(
                'Due: ${_formatDate(assignment.dueDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: assignment.isOverdue
                      ? AppColors.error
                      : isDark
                          ? Colors.white60
                          : AppColors.textSecondary,
                ),
              ),
              if (assignment.isOverdue) ...[
                const SizedBox(width: 6),
                const Icon(Icons.warning, size: 14, color: AppColors.error),
              ],
              const Spacer(),
              if (assignment.isGraded) ...[
                Text(
                  '${assignment.obtainedMarks}/${assignment.totalMarks}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ],
              if (assignment.status == 'pending')
                TextButton(
                  onPressed: () {
                    context.push(
                      '/assignment-upload',
                      extra: assignment.id,
                    );
                  },
                  child: const Text('Upload'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'submitted':
        return AppColors.primary;
      case 'graded':
        return AppColors.success;
      default:
        return AppColors.textLight;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
