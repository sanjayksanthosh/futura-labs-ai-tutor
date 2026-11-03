import 'package:flutter/foundation.dart';
import '../models/analytics_model.dart';
import '../models/activity_model.dart';
import '../services/data_service.dart';

class AnalyticsProvider extends ChangeNotifier {
  final DataService _dataService;

  AnalyticsProvider(this._dataService);
  AnalyticsModel? _analytics;
  List<ActivityModel> _activities = [];
  bool _isLoading = false;
  String? _error;

  AnalyticsModel? get analytics => _analytics;
  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAnalytics(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _analytics = await _dataService.getAnalytics(userId);
      _activities = await _dataService.getActivities();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<WeeklyProgress> get weeklyProgress =>
      _analytics?.weeklyProgress ?? [];
  List<SkillData> get skills => _analytics?.skills ?? [];
  List<PerformanceData> get performance => _analytics?.performance ?? [];
  List<AiRecommendation> get recommendations =>
      _analytics?.recommendations ?? [];
  CompletionStats get completionStats =>
      _analytics?.completionStats ?? CompletionStats();

  double get averageSkillProficiency {
    if (skills.isEmpty) return 0;
    return skills.fold(0.0, (sum, s) => sum + s.proficiency) / skills.length;
  }
}
