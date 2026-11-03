import 'package:flutter/foundation.dart';
import '../services/data_service.dart';

class AdminData {
  final List<Map<String, dynamic>> students;
  final List<Map<String, dynamic>> batches;
  final List<Map<String, dynamic>> faculty;
  final Map<String, dynamic> reports;

  AdminData({
    this.students = const [],
    this.batches = const [],
    this.faculty = const [],
    this.reports = const {},
  });
}

class AdminProvider extends ChangeNotifier {
  final DataService _dataService;

  AdminProvider(this._dataService);
  AdminData? _adminData;
  bool _isLoading = false;
  String? _error;

  AdminData? get adminData => _adminData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAdminData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _dataService.getAdminData();
      _adminData = AdminData(
        students: (data['students'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList(),
        batches: (data['batches'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList(),
        faculty: (data['faculty'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList(),
        reports: data['reports'] as Map<String, dynamic>,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> get students => _adminData?.students ?? [];
  List<Map<String, dynamic>> get batches => _adminData?.batches ?? [];
  List<Map<String, dynamic>> get faculty => _adminData?.faculty ?? [];
  Map<String, dynamic> get reports => _adminData?.reports ?? {};
}
