class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String? thumbnail;
  final String category;
  final String difficulty;
  final double progress;
  final int totalLessons;
  final int completedLessons;
  final int durationMinutes;
  final double rating;
  final int studentCount;
  final bool isBookmarked;
  final List<LessonModel> lessons;
  final List<LessonModel>? completedLessonList;
  final List<String> prerequisites;
  final DateTime createdAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    this.thumbnail,
    required this.category,
    this.difficulty = 'Beginner',
    this.progress = 0,
    this.totalLessons = 0,
    this.completedLessons = 0,
    this.durationMinutes = 0,
    this.rating = 0,
    this.studentCount = 0,
    this.isBookmarked = false,
    this.lessons = const [],
    this.completedLessonList,
    this.prerequisites = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      instructor: json['instructor'] as String,
      thumbnail: json['thumbnail'] as String?,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String? ?? 'Beginner',
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      totalLessons: json['totalLessons'] as int? ?? 0,
      completedLessons: json['completedLessons'] as int? ?? 0,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      studentCount: json['studentCount'] as int? ?? 0,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      prerequisites: (json['prerequisites'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'thumbnail': thumbnail,
      'category': category,
      'difficulty': difficulty,
      'progress': progress,
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'durationMinutes': durationMinutes,
      'rating': rating,
      'studentCount': studentCount,
      'isBookmarked': isBookmarked,
      'lessons': lessons.map((e) => e.toJson()).toList(),
      'prerequisites': prerequisites,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? instructor,
    String? thumbnail,
    String? category,
    String? difficulty,
    double? progress,
    int? totalLessons,
    int? completedLessons,
    int? durationMinutes,
    double? rating,
    int? studentCount,
    bool? isBookmarked,
    List<LessonModel>? lessons,
    List<LessonModel>? completedLessonList,
    List<String>? prerequisites,
    DateTime? createdAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      thumbnail: thumbnail ?? this.thumbnail,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      progress: progress ?? this.progress,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rating: rating ?? this.rating,
      studentCount: studentCount ?? this.studentCount,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lessons: lessons ?? this.lessons,
      completedLessonList: completedLessonList ?? this.completedLessonList,
      prerequisites: prerequisites ?? this.prerequisites,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LessonModel {
  final String id;
  final String title;
  final String content;
  final String? videoUrl;
  final int durationMinutes;
  final bool isCompleted;
  final bool isBookmarked;
  final List<String>? keyPoints;
  final String? summary;

  LessonModel({
    required this.id,
    required this.title,
    this.content = '',
    this.videoUrl,
    this.durationMinutes = 0,
    this.isCompleted = false,
    this.isBookmarked = false,
    this.keyPoints,
    this.summary,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      videoUrl: json['videoUrl'] as String?,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      keyPoints: (json['keyPoints'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'videoUrl': videoUrl,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'isBookmarked': isBookmarked,
      'keyPoints': keyPoints,
      'summary': summary,
    };
  }

  LessonModel copyWith({
    String? id,
    String? title,
    String? content,
    String? videoUrl,
    int? durationMinutes,
    bool? isCompleted,
    bool? isBookmarked,
    List<String>? keyPoints,
    String? summary,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      videoUrl: videoUrl ?? this.videoUrl,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      keyPoints: keyPoints ?? this.keyPoints,
      summary: summary ?? this.summary,
    );
  }
}

class TopicSummary {
  final String id;
  final String title;
  final String summary;
  final List<String> keyConcepts;
  final String difficulty;

  TopicSummary({
    required this.id,
    required this.title,
    required this.summary,
    required this.keyConcepts,
    this.difficulty = 'Medium',
  });

  factory TopicSummary.fromJson(Map<String, dynamic> json) {
    return TopicSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      keyConcepts: (json['keyConcepts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      difficulty: json['difficulty'] as String? ?? 'Medium',
    );
  }
}
