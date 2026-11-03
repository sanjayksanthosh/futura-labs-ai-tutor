class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String role;
  final String? institution;
  final int streak;
  final int totalCourses;
  final int completedLessons;
  final double aiScore;
  final double weeklyProgress;
  final DateTime? lastActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.role = 'student',
    this.institution,
    this.streak = 0,
    this.totalCourses = 0,
    this.completedLessons = 0,
    this.aiScore = 0,
    this.weeklyProgress = 0,
    this.lastActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'student',
      institution: json['institution'] as String?,
      streak: json['streak'] as int? ?? 0,
      totalCourses: json['totalCourses'] as int? ?? 0,
      completedLessons: json['completedLessons'] as int? ?? 0,
      aiScore: (json['aiScore'] as num?)?.toDouble() ?? 0,
      weeklyProgress: (json['weeklyProgress'] as num?)?.toDouble() ?? 0,
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
      'institution': institution,
      'streak': streak,
      'totalCourses': totalCourses,
      'completedLessons': completedLessons,
      'aiScore': aiScore,
      'weeklyProgress': weeklyProgress,
      'lastActive': lastActive?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? role,
    String? institution,
    int? streak,
    int? totalCourses,
    int? completedLessons,
    double? aiScore,
    double? weeklyProgress,
    DateTime? lastActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      institution: institution ?? this.institution,
      streak: streak ?? this.streak,
      totalCourses: totalCourses ?? this.totalCourses,
      completedLessons: completedLessons ?? this.completedLessons,
      aiScore: aiScore ?? this.aiScore,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
