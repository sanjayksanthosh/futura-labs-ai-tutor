class AnalyticsModel {
  final String id;
  final String userId;
  final List<WeeklyProgress> weeklyProgress;
  final List<SkillData> skills;
  final List<HeatmapData> heatmap;
  final List<PerformanceData> performance;
  final List<AiRecommendation> recommendations;
  final CompletionStats completionStats;

  AnalyticsModel({
    required this.id,
    required this.userId,
    this.weeklyProgress = const [],
    this.skills = const [],
    this.heatmap = const [],
    this.performance = const [],
    this.recommendations = const [],
    required this.completionStats,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weeklyProgress: (json['weeklyProgress'] as List<dynamic>?)
              ?.map((e) => WeeklyProgress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => SkillData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      heatmap: (json['heatmap'] as List<dynamic>?)
              ?.map((e) => HeatmapData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      performance: (json['performance'] as List<dynamic>?)
              ?.map((e) =>
                  PerformanceData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) =>
                  AiRecommendation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      completionStats: CompletionStats.fromJson(
          json['completionStats'] as Map<String, dynamic>),
    );
  }
}

class WeeklyProgress {
  final String day;
  final int hours;
  final int lessonsCompleted;
  final int quizzesTaken;

  WeeklyProgress({
    required this.day,
    required this.hours,
    this.lessonsCompleted = 0,
    this.quizzesTaken = 0,
  });

  factory WeeklyProgress.fromJson(Map<String, dynamic> json) {
    return WeeklyProgress(
      day: json['day'] as String,
      hours: json['hours'] as int,
      lessonsCompleted: json['lessonsCompleted'] as int? ?? 0,
      quizzesTaken: json['quizzesTaken'] as int? ?? 0,
    );
  }
}

class SkillData {
  final String name;
  final double proficiency;
  final String category;

  SkillData({
    required this.name,
    required this.proficiency,
    this.category = 'General',
  });

  factory SkillData.fromJson(Map<String, dynamic> json) {
    return SkillData(
      name: json['name'] as String,
      proficiency: (json['proficiency'] as num).toDouble(),
      category: json['category'] as String? ?? 'General',
    );
  }
}

class HeatmapData {
  final DateTime date;
  final int intensity;
  final String label;

  HeatmapData({
    required this.date,
    required this.intensity,
    required this.label,
  });

  factory HeatmapData.fromJson(Map<String, dynamic> json) {
    return HeatmapData(
      date: DateTime.parse(json['date'] as String),
      intensity: json['intensity'] as int,
      label: json['label'] as String,
    );
  }
}

class PerformanceData {
  final String subject;
  final List<double> scores;
  final List<String> labels;

  PerformanceData({
    required this.subject,
    required this.scores,
    required this.labels,
  });

  factory PerformanceData.fromJson(Map<String, dynamic> json) {
    return PerformanceData(
      subject: json['subject'] as String,
      scores: (json['scores'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      labels:
          (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
}

class AiRecommendation {
  final String id;
  final String title;
  final String description;
  final String type;
  final String priority;

  AiRecommendation({
    required this.id,
    required this.title,
    required this.description,
    this.type = 'course',
    this.priority = 'medium',
  });

  factory AiRecommendation.fromJson(Map<String, dynamic> json) {
    return AiRecommendation(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String? ?? 'course',
      priority: json['priority'] as String? ?? 'medium',
    );
  }
}

class CompletionStats {
  final int totalCourses;
  final int completedCourses;
  final int totalLessons;
  final int completedLessons;
  final int totalQuizzes;
  final int completedQuizzes;
  final int totalAssignments;
  final int submittedAssignments;
  final int totalHoursLearned;

  CompletionStats({
    this.totalCourses = 0,
    this.completedCourses = 0,
    this.totalLessons = 0,
    this.completedLessons = 0,
    this.totalQuizzes = 0,
    this.completedQuizzes = 0,
    this.totalAssignments = 0,
    this.submittedAssignments = 0,
    this.totalHoursLearned = 0,
  });

  double get courseCompletionRate =>
      totalCourses > 0 ? completedCourses / totalCourses * 100 : 0;
  double get lessonCompletionRate =>
      totalLessons > 0 ? completedLessons / totalLessons * 100 : 0;
  double get quizCompletionRate =>
      totalQuizzes > 0 ? completedQuizzes / totalQuizzes * 100 : 0;

  factory CompletionStats.fromJson(Map<String, dynamic> json) {
    return CompletionStats(
      totalCourses: json['totalCourses'] as int? ?? 0,
      completedCourses: json['completedCourses'] as int? ?? 0,
      totalLessons: json['totalLessons'] as int? ?? 0,
      completedLessons: json['completedLessons'] as int? ?? 0,
      totalQuizzes: json['totalQuizzes'] as int? ?? 0,
      completedQuizzes: json['completedQuizzes'] as int? ?? 0,
      totalAssignments: json['totalAssignments'] as int? ?? 0,
      submittedAssignments: json['submittedAssignments'] as int? ?? 0,
      totalHoursLearned: json['totalHoursLearned'] as int? ?? 0,
    );
  }
}
