class AssignmentModel {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String courseName;
  final String type;
  final DateTime dueDate;
  final int totalMarks;
  final int obtainedMarks;
  final String status;
  final String? fileUrl;
  final String? feedback;
  final double? aiScore;
  final List<String>? aiRecommendations;
  final DateTime createdAt;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.courseName,
    this.type = 'PDF',
    DateTime? dueDate,
    this.totalMarks = 100,
    this.obtainedMarks = 0,
    this.status = 'pending',
    this.fileUrl,
    this.feedback,
    this.aiScore,
    this.aiRecommendations,
    DateTime? createdAt,
  })  : dueDate = dueDate ?? DateTime.now().add(const Duration(days: 7)),
        createdAt = createdAt ?? DateTime.now();

  bool get isSubmitted => status == 'submitted';
  bool get isGraded => status == 'graded';
  bool get isOverdue => !isSubmitted && DateTime.now().isAfter(dueDate);

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      type: json['type'] as String? ?? 'PDF',
      dueDate: DateTime.parse(json['dueDate'] as String),
      totalMarks: json['totalMarks'] as int? ?? 100,
      obtainedMarks: json['obtainedMarks'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      fileUrl: json['fileUrl'] as String?,
      feedback: json['feedback'] as String?,
      aiScore: (json['aiScore'] as num?)?.toDouble(),
      aiRecommendations: (json['aiRecommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'courseName': courseName,
      'type': type,
      'dueDate': dueDate.toIso8601String(),
      'totalMarks': totalMarks,
      'obtainedMarks': obtainedMarks,
      'status': status,
      'fileUrl': fileUrl,
      'feedback': feedback,
      'aiScore': aiScore,
      'aiRecommendations': aiRecommendations,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class UploadProgressModel {
  final String fileName;
  final double progress;
  final String status;
  final String? error;

  UploadProgressModel({
    required this.fileName,
    this.progress = 0,
    this.status = 'idle',
    this.error,
  });

  UploadProgressModel copyWith({
    String? fileName,
    double? progress,
    String? status,
    String? error,
  }) {
    return UploadProgressModel(
      fileName: fileName ?? this.fileName,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class AiEvaluationResult {
  final String id;
  final String assignmentId;
  final double score;
  final String feedback;
  final List<String> strengths;
  final List<String> improvements;
  final List<String> suggestions;
  final DateTime evaluatedAt;

  AiEvaluationResult({
    required this.id,
    required this.assignmentId,
    required this.score,
    required this.feedback,
    this.strengths = const [],
    this.improvements = const [],
    this.suggestions = const [],
    DateTime? evaluatedAt,
  }) : evaluatedAt = evaluatedAt ?? DateTime.now();

  factory AiEvaluationResult.fromJson(Map<String, dynamic> json) {
    return AiEvaluationResult(
      id: json['id'] as String,
      assignmentId: json['assignmentId'] as String,
      score: (json['score'] as num).toDouble(),
      feedback: json['feedback'] as String,
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      improvements: (json['improvements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      evaluatedAt: DateTime.parse(json['evaluatedAt'] as String),
    );
  }
}
