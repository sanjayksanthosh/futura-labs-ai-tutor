class AssessmentModel {
  final String id;
  final String title;
  final String courseId;
  final String courseName;
  final List<QuestionModel> questions;
  final int durationMinutes;
  final int totalMarks;
  final String difficulty;
  final DateTime? scheduledDate;

  AssessmentModel({
    required this.id,
    required this.title,
    required this.courseId,
    required this.courseName,
    this.questions = const [],
    this.durationMinutes = 30,
    this.totalMarks = 100,
    this.difficulty = 'Medium',
    this.scheduledDate,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      durationMinutes: json['durationMinutes'] as int? ?? 30,
      totalMarks: json['totalMarks'] as int? ?? 100,
      difficulty: json['difficulty'] as String? ?? 'Medium',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseId': courseId,
      'courseName': courseName,
      'questions': questions.map((e) => e.toJson()).toList(),
      'durationMinutes': durationMinutes,
      'totalMarks': totalMarks,
      'difficulty': difficulty,
      'scheduledDate': scheduledDate?.toIso8601String(),
    };
  }

  AssessmentModel copyWith({
    String? id,
    String? title,
    String? courseId,
    String? courseName,
    List<QuestionModel>? questions,
    int? durationMinutes,
    int? totalMarks,
    String? difficulty,
    DateTime? scheduledDate,
  }) {
    return AssessmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      questions: questions ?? this.questions,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      totalMarks: totalMarks ?? this.totalMarks,
      difficulty: difficulty ?? this.difficulty,
      scheduledDate: scheduledDate ?? this.scheduledDate,
    );
  }
}

class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? explanation;
  final String category;
  final String difficulty;
  int? selectedAnswer;
  bool isMarkedForReview;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.category = 'General',
    this.difficulty = 'Medium',
    this.selectedAnswer,
    this.isMarkedForReview = false,
  });

  bool get isCorrect => selectedAnswer == correctAnswer;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswer: json['correctAnswer'] as int,
      explanation: json['explanation'] as String?,
      category: json['category'] as String? ?? 'General',
      difficulty: json['difficulty'] as String? ?? 'Medium',
      selectedAnswer: json['selectedAnswer'] as int?,
      isMarkedForReview: json['isMarkedForReview'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
      'selectedAnswer': selectedAnswer,
      'isMarkedForReview': isMarkedForReview,
    };
  }
}

class QuizResultModel {
  final String id;
  final String assessmentId;
  final String title;
  final int score;
  final int totalMarks;
  final int correctCount;
  final int incorrectCount;
  final int unansweredCount;
  final int totalQuestions;
  final double percentage;
  final int timeTakenSeconds;
  final List<QuestionModel> questions;
  final DateTime completedAt;

  QuizResultModel({
    required this.id,
    required this.assessmentId,
    required this.title,
    required this.score,
    required this.totalMarks,
    required this.correctCount,
    required this.incorrectCount,
    required this.unansweredCount,
    required this.totalQuestions,
    required this.percentage,
    required this.timeTakenSeconds,
    this.questions = const [],
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  String get gradeColor {
    if (percentage >= 80) return 'success';
    if (percentage >= 60) return 'warning';
    return 'error';
  }

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'] as String,
      assessmentId: json['assessmentId'] as String,
      title: json['title'] as String,
      score: json['score'] as int,
      totalMarks: json['totalMarks'] as int,
      correctCount: json['correctCount'] as int,
      incorrectCount: json['incorrectCount'] as int,
      unansweredCount: json['unansweredCount'] as int,
      totalQuestions: json['totalQuestions'] as int,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      timeTakenSeconds: json['timeTakenSeconds'] as int? ?? 0,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : DateTime.now(),
    );
  }
}
