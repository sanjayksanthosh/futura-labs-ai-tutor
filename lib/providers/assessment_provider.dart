import 'package:flutter/foundation.dart';
import '../models/assessment_model.dart';
import '../services/data_service.dart';

class AssessmentProvider extends ChangeNotifier {
  final DataService _dataService;

  AssessmentProvider(this._dataService);
  List<AssessmentModel> _assessments = [];
  AssessmentModel? _currentAssessment;
  QuizResultModel? _lastResult;
  bool _isLoading = false;
  bool _isQuizActive = false;
  int _timeRemaining = 0;
  String? _error;

  List<AssessmentModel> get assessments => _assessments;
  AssessmentModel? get currentAssessment => _currentAssessment;
  QuizResultModel? get lastResult => _lastResult;
  bool get isLoading => _isLoading;
  bool get isQuizActive => _isQuizActive;
  int get timeRemaining => _timeRemaining;
  String? get error => _error;

  Future<void> loadAssessments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _assessments = await _dataService.getAssessments();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startAssessment(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentAssessment = await _dataService.getAssessmentById(id);
      _timeRemaining = _currentAssessment!.durationMinutes * 60;
      _isQuizActive = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    if (_currentAssessment == null) return;
    final questions = List<QuestionModel>.from(_currentAssessment!.questions);
    if (questionIndex < questions.length) {
      questions[questionIndex].selectedAnswer = answerIndex;
      _currentAssessment = _currentAssessment!.copyWith(questions: questions);
      notifyListeners();
    }
  }

  void toggleMarkForReview(int questionIndex) {
    if (_currentAssessment == null) return;
    final questions = List<QuestionModel>.from(_currentAssessment!.questions);
    if (questionIndex < questions.length) {
      questions[questionIndex].isMarkedForReview =
          !questions[questionIndex].isMarkedForReview;
      _currentAssessment = _currentAssessment!.copyWith(questions: questions);
      notifyListeners();
    }
  }

  Future<void> submitAssessment({required int timeTakenSeconds}) async {
    if (_currentAssessment == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      _lastResult = await _dataService.submitAssessment(
        assessmentId: _currentAssessment!.id,
        title: _currentAssessment!.title,
        questions: _currentAssessment!.questions,
        timeTakenSeconds: timeTakenSeconds,
      );
      _isQuizActive = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void tickTimer() {
    if (_timeRemaining > 0) {
      _timeRemaining--;
      notifyListeners();
    }
  }

  void resetAssessment() {
    _currentAssessment = null;
    _lastResult = null;
    _isQuizActive = false;
    _timeRemaining = 0;
    _error = null;
    notifyListeners();
  }

  int get answeredCount {
    if (_currentAssessment == null) return 0;
    return _currentAssessment!.questions
        .where((q) => q.selectedAnswer != null)
        .length;
  }

  int get markedForReviewCount {
    if (_currentAssessment == null) return 0;
    return _currentAssessment!.questions
        .where((q) => q.isMarkedForReview)
        .length;
  }

  int get totalQuestions {
    return _currentAssessment?.questions.length ?? 0;
  }
}
