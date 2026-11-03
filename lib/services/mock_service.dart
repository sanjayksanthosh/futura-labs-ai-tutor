import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/assessment_model.dart';
import '../models/assignment_model.dart';
import '../models/analytics_model.dart';
import '../models/activity_model.dart';

class MockService {
  static final MockService _instance = MockService._();
  factory MockService() => _instance;
  MockService._();

  Future<Map<String, dynamic>> _loadJson(String path) async {
    final data = await rootBundle.loadString(path);
    return json.decode(data) as Map<String, dynamic>;
  }

  Future<List<dynamic>> _loadJsonList(String path) async {
    final data = await rootBundle.loadString(path);
    return json.decode(data) as List<dynamic>;
  }

  Future<List<UserModel>> getUsers() async {
    final list = await _loadJsonList('assets/data/mock_users.json');
    return list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CourseModel>> getCourses() async {
    final list = await _loadJsonList('assets/data/mock_courses.json');
    return list.map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CourseModel> getCourseById(String id) async {
    final courses = await getCourses();
    return courses.firstWhere((c) => c.id == id);
  }

  Future<List<AssessmentModel>> getAssessments() async {
    final list = await _loadJsonList('assets/data/mock_assessments.json');
    return list.map((e) => AssessmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AssessmentModel> getAssessmentById(String id) async {
    final assessments = await getAssessments();
    return assessments.firstWhere((a) => a.id == id);
  }

  Future<List<AssignmentModel>> getAssignments() async {
    final list = await _loadJsonList('assets/data/mock_assignments.json');
    return list.map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AnalyticsModel> getAnalytics(String userId) async {
    final data = await _loadJson('assets/data/mock_analytics.json');
    return AnalyticsModel.fromJson(data);
  }

  Future<List<ActivityModel>> getActivities() async {
    final list = await _loadJsonList('assets/data/mock_activities.json');
    return list.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> getAdminData() async {
    return _loadJson('assets/data/mock_admin.json');
  }

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final users = await getUsers();
    final user = users.where((u) => u.email == email).firstOrNull;
    if (user == null) throw Exception('Invalid email or password');
    return user;
  }

  Future<UserModel> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: 'student',
    );
  }

  Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<QuizResultModel> submitAssessment({
    required String assessmentId,
    required String title,
    required List<QuestionModel> questions,
    required int timeTakenSeconds,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    int correct = questions.where((q) => q.isCorrect).length;
    int incorrect = questions.where((q) => q.selectedAnswer != null && !q.isCorrect).length;
    int unanswered = questions.where((q) => q.selectedAnswer == null).length;
    int totalMarks = questions.length * 20;
    int score = (correct * 20);
    double percentage = (score / totalMarks) * 100;

    return QuizResultModel(
      id: 'result_${DateTime.now().millisecondsSinceEpoch}',
      assessmentId: assessmentId,
      title: title,
      score: score,
      totalMarks: totalMarks,
      correctCount: correct,
      incorrectCount: incorrect,
      unansweredCount: unanswered,
      totalQuestions: questions.length,
      percentage: percentage,
      timeTakenSeconds: timeTakenSeconds,
      questions: questions,
    );
  }

  Future<AiEvaluationResult> evaluateAssignment({
    required String assignmentId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return AiEvaluationResult(
      id: 'eval_${DateTime.now().millisecondsSinceEpoch}',
      assignmentId: assignmentId,
      score: 85.0,
      feedback: 'Your submission demonstrates good understanding of the core concepts. The code is well-structured and follows best practices. Consider adding more error handling and edge cases.',
      strengths: [
        'Clear and readable code',
        'Good use of functions',
        'Well-documented',
      ],
      improvements: [
        'Add input validation',
        'Handle edge cases',
        'Optimize performance',
      ],
      suggestions: [
        'Use type hints for better readability',
        'Add unit tests',
        'Consider using design patterns',
      ],
    );
  }
}
