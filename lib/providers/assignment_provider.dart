import 'package:flutter/foundation.dart';
import '../models/assignment_model.dart';
import '../services/data_service.dart';

class AssignmentProvider extends ChangeNotifier {
  final DataService _dataService;

  AssignmentProvider(this._dataService);
  List<AssignmentModel> _assignments = [];
  AiEvaluationResult? _lastEvaluation;
  bool _isLoading = false;
  double _uploadProgress = 0;
  String? _error;

  List<AssignmentModel> get assignments => _assignments;
  AiEvaluationResult? get lastEvaluation => _lastEvaluation;
  bool get isLoading => _isLoading;
  double get uploadProgress => _uploadProgress;
  String? get error => _error;

  List<AssignmentModel> get pendingAssignments =>
      _assignments.where((a) => a.status == 'pending').toList();
  List<AssignmentModel> get submittedAssignments =>
      _assignments.where((a) => a.status == 'submitted').toList();
  List<AssignmentModel> get gradedAssignments =>
      _assignments.where((a) => a.status == 'graded').toList();

  Future<void> loadAssignments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _assignments = await _dataService.getAssignments();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void simulateUpload() {
    _uploadProgress = 0;
    notifyListeners();
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_uploadProgress >= 1.0) return false;
      _uploadProgress += 0.05;
      notifyListeners();
      return true;
    });
  }

  Future<void> submitAssignment(String id) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index] = AssignmentModel(
        id: _assignments[index].id,
        title: _assignments[index].title,
        description: _assignments[index].description,
        courseId: _assignments[index].courseId,
        courseName: _assignments[index].courseName,
        type: _assignments[index].type,
        dueDate: _assignments[index].dueDate,
        totalMarks: _assignments[index].totalMarks,
        status: 'submitted',
        fileUrl: 'https://example.com/uploads/file.pdf',
        createdAt: _assignments[index].createdAt,
      );
    }
    _isLoading = false;
    _uploadProgress = 0;
    notifyListeners();
  }

  Future<void> evaluateAssignment(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _lastEvaluation = await _dataService.evaluateAssignment(assignmentId: id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearEvaluation() {
    _lastEvaluation = null;
    notifyListeners();
  }
}
