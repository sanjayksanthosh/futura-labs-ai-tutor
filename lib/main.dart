import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/course_provider.dart';
import 'providers/assessment_provider.dart';
import 'providers/assignment_provider.dart';
import 'providers/analytics_provider.dart';
import 'providers/admin_provider.dart';
import 'services/data_service.dart';

final DataService dataService = DataService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dataService.initialize();
  runApp(const FuturaLabsAiTutorApp());
}

class FuturaLabsAiTutorApp extends StatelessWidget {
  const FuturaLabsAiTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(dataService)),
        ChangeNotifierProvider(create: (_) => CourseProvider(dataService)),
        ChangeNotifierProvider(create: (_) => AssessmentProvider(dataService)),
        ChangeNotifierProvider(create: (_) => AssignmentProvider(dataService)),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider(dataService)),
        ChangeNotifierProvider(create: (_) => AdminProvider(dataService)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, __) {
          return MaterialApp.router(
            title: 'FuturaLabs Ai Tutor',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
