import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/assessment_model.dart';
import '../models/assignment_model.dart';
import '../models/analytics_model.dart';
import '../models/activity_model.dart';
import 'mock_service.dart';
import 'supabase_service.dart';

class DataService {
  final MockService _mock = MockService();
  final SupabaseService _supabase = SupabaseService();
  bool _supabaseAvailable = false;

  bool get isSupabaseAvailable => _supabaseAvailable;

  Future<void> initialize() async {
    try {
      await _supabase.initialize();
      _supabaseAvailable = true;
    } catch (e) {
      debugPrint('Supabase init failed, using mock data: $e');
      _supabaseAvailable = false;
    }
  }

  // ── Users ──

  Future<List<UserModel>> getUsers() async {
    if (_supabaseAvailable) {
      try { return await _supabase.getUsers(); } catch (_) {}
    }
    return _mock.getUsers();
  }

  Future<UserModel> login(String email, String password) async {
    if (_supabaseAvailable) {
      try { return await _supabase.login(email, password); } catch (_) {}
    }
    return _mock.login(email, password);
  }

  Future<UserModel> signup(String name, String email, String password) async {
    if (_supabaseAvailable) {
      try { return await _supabase.signup(name, email, password); } catch (_) {}
    }
    return _mock.signup(name, email, password);
  }

  Future<bool> forgotPassword(String email) async {
    if (_supabaseAvailable) {
      try { return await _supabase.forgotPassword(email); } catch (_) {}
    }
    return _mock.forgotPassword(email);
  }

  // ── Courses ──

  Future<List<CourseModel>> getCourses() async {
    if (_supabaseAvailable) {
      try { return await _supabase.getCourses(); } catch (_) {}
    }
    return _mock.getCourses();
  }

  Future<CourseModel> getCourseById(String id) async {
    if (_supabaseAvailable) {
      try { return await _supabase.getCourseById(id); } catch (_) {}
    }
    return _mock.getCourseById(id);
  }

  // ── Assessments ──

  Future<List<AssessmentModel>> getAssessments() async {
    if (_supabaseAvailable) {
      try { return await _supabase.getAssessments(); } catch (_) {}
    }
    return _mock.getAssessments();
  }

  Future<AssessmentModel> getAssessmentById(String id) async {
    if (_supabaseAvailable) {
      try { return await _supabase.getAssessmentById(id); } catch (_) {}
    }
    return _mock.getAssessmentById(id);
  }

  Future<QuizResultModel> submitAssessment({
    required String assessmentId,
    required String title,
    required List<QuestionModel> questions,
    required int timeTakenSeconds,
  }) async {
    if (_supabaseAvailable) {
      try {
        return await _supabase.submitAssessment(
          assessmentId: assessmentId,
          title: title,
          questions: questions,
          timeTakenSeconds: timeTakenSeconds,
        );
      } catch (_) {}
    }
    return _mock.submitAssessment(
      assessmentId: assessmentId,
      title: title,
      questions: questions,
      timeTakenSeconds: timeTakenSeconds,
    );
  }

  // ── Assignments ──

  Future<List<AssignmentModel>> getAssignments() async {
    if (_supabaseAvailable) {
      try { return await _supabase.getAssignments(); } catch (_) {}
    }
    return _mock.getAssignments();
  }

  Future<AiEvaluationResult> evaluateAssignment({required String assignmentId}) async {
    if (_supabaseAvailable) {
      try { return await _supabase.evaluateAssignment(assignmentId: assignmentId); } catch (_) {}
    }
    return _mock.evaluateAssignment(assignmentId: assignmentId);
  }

  // ── Analytics ──

  Future<AnalyticsModel> getAnalytics(String userId) async {
    if (_supabaseAvailable) {
      try { return await _supabase.getAnalytics(userId); } catch (_) {}
    }
    return _mock.getAnalytics(userId);
  }

  // ── Activities ──

  Future<List<ActivityModel>> getActivities() async {
    if (_supabaseAvailable) {
      try { return await _supabase.getActivities(); } catch (_) {}
    }
    return _mock.getActivities();
  }

  // ── Admin Data ──

  Future<Map<String, dynamic>> getAdminData() async {
    if (_supabaseAvailable) {
      try { return await _supabase.getAdminData(); } catch (_) {}
    }
    return _mock.getAdminData();
  }
}
