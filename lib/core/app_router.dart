import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants/app_colors.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/courses/screens/course_list_screen.dart';
import '../features/courses/screens/course_detail_screen.dart';
import '../features/courses/screens/lesson_player_screen.dart';
import '../features/assessments/screens/assessment_list_screen.dart';
import '../features/assessments/screens/quiz_screen.dart';
import '../features/assessments/screens/quiz_result_screen.dart';
import '../features/assignments/screens/assignment_list_screen.dart';
import '../features/assignments/screens/assignment_upload_screen.dart';
import '../features/assignments/screens/assignment_evaluation_screen.dart';
import '../features/analytics/screens/analytics_screen.dart';
import '../features/admin/screens/admin_dashboard_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const MainShell(),
      ),
      GoRoute(
        path: '/course-detail',
        builder: (_, state) => const CourseDetailScreen(),
      ),
      GoRoute(
        path: '/lesson-player',
        builder: (_, state) => const LessonPlayerScreen(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (_, state) => const QuizScreen(),
      ),
      GoRoute(
        path: '/quiz-result',
        builder: (_, state) => const QuizResultScreen(),
      ),
      GoRoute(
        path: '/assignment-detail',
        builder: (_, state) => const AssignmentListScreen(),
      ),
      GoRoute(
        path: '/assignment-upload',
        builder: (_, state) => const AssignmentUploadScreen(),
      ),
      GoRoute(
        path: '/assignment-evaluation',
        builder: (_, state) => const AssignmentEvaluationScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (_, state) => const AdminDashboardScreen(),
      ),
    ],
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    CourseListScreen(),
    AssessmentListScreen(),
    AnalyticsScreen(),
    SettingsScreen(),
  ];

  void switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: bottomNavTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_outlined, Icons.home, 'Home', 0),
                _navItem(Icons.school_outlined, Icons.school, 'Courses', 1),
                _navItem(Icons.quiz_outlined, Icons.quiz, 'Assess', 2),
                _navItem(Icons.analytics_outlined, Icons.analytics, 'Analytics', 3),
                _navItem(Icons.person_outline, Icons.person, 'Profile', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData outlined, IconData filled, String label, int index) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final unselectedColor = AppColors.textLight;

    return GestureDetector(
      onTap: () => switchTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? filled : outlined,
                key: ValueKey(isSelected),
                size: 22,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
