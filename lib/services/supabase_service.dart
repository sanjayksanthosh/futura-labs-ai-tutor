import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/assessment_model.dart';
import '../models/assignment_model.dart';
import '../models/analytics_model.dart';
import '../models/activity_model.dart';
import '../core/constants/app_config.dart';

class SupabaseService {
  late final SupabaseClient _client;
  bool _initialized = false;

  SupabaseClient get client => _client;

  Future<void> initialize() async {
    if (_initialized) return;
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
    _initialized = true;
  }

  // ── Users ──

  Future<List<UserModel>> getUsers() async {
    final response = await _client.from('users').select();
    return (response as List).map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<UserModel?> getUserById(String id) async {
    final response = await _client.from('users').select().eq('id', id).maybeSingle();
    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final users = await getUsers();
    final user = users.where((u) => u.email == email).firstOrNull;
    if (user == null) throw Exception('Invalid email or password');
    return user;
  }

  Future<UserModel> signup(String name, String email, String password) async {
    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: 'student',
    );
    await _client.from('users').insert(user.toJson());
    return user;
  }

  Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  // ── Courses ──

  Future<List<CourseModel>> getCourses() async {
    final response = await _client.from('courses').select();
    final list = response as List;
    final courses = <CourseModel>[];
    for (final row in list) {
      final data = Map<String, dynamic>.from(row as Map);
      final lessons = await _getLessons(data['id'] as String);
      data['lessons'] = lessons.map((l) => l.toJson()).toList();
      courses.add(CourseModel.fromJson(data));
    }
    return courses;
  }

  Future<CourseModel> getCourseById(String id) async {
    final response = await _client.from('courses').select().eq('id', id).single();
    final data = Map<String, dynamic>.from(response as Map);
    final lessons = await _getLessons(id);
    data['lessons'] = lessons.map((l) => l.toJson()).toList();
    return CourseModel.fromJson(data);
  }

  Future<List<LessonModel>> _getLessons(String courseId) async {
    final response = await _client.from('lessons').select().eq('course_id', courseId);
    return (response as List).map((e) => LessonModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ── Assessments ──

  Future<List<AssessmentModel>> getAssessments() async {
    final response = await _client.from('assessments').select();
    final list = response as List;
    final assessments = <AssessmentModel>[];
    for (final row in list) {
      final data = Map<String, dynamic>.from(row as Map);
      final questions = await _getQuestions(data['id'] as String);
      data['questions'] = questions.map((q) => q.toJson()).toList();
      assessments.add(AssessmentModel.fromJson(data));
    }
    return assessments;
  }

  Future<AssessmentModel> getAssessmentById(String id) async {
    final response = await _client.from('assessments').select().eq('id', id).single();
    final data = Map<String, dynamic>.from(response as Map);
    final questions = await _getQuestions(id);
    data['questions'] = questions.map((q) => q.toJson()).toList();
    return AssessmentModel.fromJson(data);
  }

  Future<List<QuestionModel>> _getQuestions(String assessmentId) async {
    final response = await _client.from('questions').select().eq('assessment_id', assessmentId);
    return (response as List).map((e) => QuestionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<QuizResultModel> submitAssessment({
    required String assessmentId,
    required String title,
    required List<QuestionModel> questions,
    required int timeTakenSeconds,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final correct = questions.where((q) => q.isCorrect).length;
    final incorrect = questions.where((q) => q.selectedAnswer != null && !q.isCorrect).length;
    final unanswered = questions.where((q) => q.selectedAnswer == null).length;
    final totalMarks = questions.length * 20;
    final score = correct * 20;
    final percentage = totalMarks > 0 ? (score / totalMarks) * 100 : 0.0;

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

  // ── Assignments ──

  Future<List<AssignmentModel>> getAssignments() async {
    final response = await _client.from('assignments').select();
    return (response as List).map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AiEvaluationResult> evaluateAssignment({required String assignmentId}) async {
    await Future.delayed(const Duration(seconds: 2));
    return AiEvaluationResult(
      id: 'eval_${DateTime.now().millisecondsSinceEpoch}',
      assignmentId: assignmentId,
      score: 85.0,
      feedback: 'Your submission demonstrates good understanding of the core concepts.',
      strengths: ['Clear and readable code', 'Good use of functions', 'Well-documented'],
      improvements: ['Add input validation', 'Handle edge cases', 'Optimize performance'],
      suggestions: ['Use type hints for better readability', 'Add unit tests', 'Consider using design patterns'],
    );
  }

  // ── Analytics ──

  Future<AnalyticsModel> getAnalytics(String userId) async {
    final response = await _client.from('analytics').select().eq('user_id', userId).maybeSingle();
    if (response == null) throw Exception('Analytics not found for user $userId');
    final data = Map<String, dynamic>.from(response as Map);
    data['weeklyProgress'] = data.remove('weekly_progress');
    data['completionStats'] = data.remove('completion_stats');
    return AnalyticsModel.fromJson(data);
  }

  // ── Activities ──

  Future<List<ActivityModel>> getActivities() async {
    final response = await _client.from('activities').select().order('timestamp', ascending: false);
    return (response as List).map((e) => ActivityModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ── Admin Data ──

  Future<Map<String, dynamic>> getAdminData() async {
    final response = await _client.from('admin_data').select().maybeSingle();
    if (response == null) throw Exception('Admin data not found');
    return Map<String, dynamic>.from(response as Map);
  }

  // ── Realtime (optional, for future use) ──

  RealtimeChannel subscribeToTable(String table, {
    required void Function(Map<String, dynamic> payload) onUpdate,
    void Function(Map<String, dynamic> payload)? onInsert,
    void Function(Map<String, dynamic> payload)? onDelete,
  }) {
    return _client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          table: table,
          callback: (payload) {
            switch (payload.eventType) {
              case PostgresChangeEvent.update:
                onUpdate(payload.newRecord);
              case PostgresChangeEvent.insert:
                onInsert?.call(payload.newRecord);
              case PostgresChangeEvent.delete:
                onDelete?.call(payload.oldRecord);
              default:
                break;
            }
          },
        )
        .subscribe();
  }
}
