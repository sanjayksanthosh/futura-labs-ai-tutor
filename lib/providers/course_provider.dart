import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../services/data_service.dart';

class CourseProvider extends ChangeNotifier {
  final DataService _dataService;

  CourseProvider(this._dataService);
  List<CourseModel> _courses = [];
  CourseModel? _selectedCourse;
  bool _isLoading = false;
  String? _error;
  List<CourseModel> _bookmarkedCourses = [];

  List<CourseModel> get courses => _courses;
  CourseModel? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CourseModel> get bookmarkedCourses => _bookmarkedCourses;

  List<CourseModel> get inProgressCourses =>
      _courses.where((c) => c.progress > 0 && c.progress < 100).toList();

  List<CourseModel> get recommendedCourses => _courses;

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _dataService.getCourses();
      _bookmarkedCourses = _courses.where((c) => c.isBookmarked).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCourseDetail(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedCourse = await _dataService.getCourseById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleBookmark(String courseId) {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      _courses[index] = _courses[index].copyWith(
        isBookmarked: !_courses[index].isBookmarked,
      );
      _bookmarkedCourses = _courses.where((c) => c.isBookmarked).toList();
      if (_selectedCourse?.id == courseId) {
        _selectedCourse = _courses[index];
      }
      notifyListeners();
    }
  }

  void toggleLessonBookmark(String lessonId) {
    if (_selectedCourse == null) return;
    final lessons = _selectedCourse!.lessons.map((l) {
      if (l.id == lessonId) {
        return l.copyWith(isBookmarked: !l.isBookmarked);
      }
      return l;
    }).toList();
    _selectedCourse = _selectedCourse!.copyWith(lessons: lessons);
    notifyListeners();
  }

  void markLessonComplete(String lessonId) {
    if (_selectedCourse == null) return;
    final lessons = _selectedCourse!.lessons.map((l) {
      if (l.id == lessonId) {
        return l.copyWith(isCompleted: true);
      }
      return l;
    }).toList();
    final completed = lessons.where((l) => l.isCompleted).length;
    final progress = (completed / lessons.length) * 100;
    _selectedCourse = _selectedCourse!.copyWith(
      lessons: lessons,
      completedLessons: completed,
      progress: progress,
    );
    notifyListeners();
  }

  void clearSelectedCourse() {
    _selectedCourse = null;
  }
}
