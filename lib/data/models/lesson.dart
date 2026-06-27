/// Lesson model for education module
class Lesson {
  final String id;
  final int order;
  final String title;
  final String description;
  final String content; // Markdown content
  final String? imageUrl;
  final int estimatedMinutes;
  final List<QuizQuestion>? quiz;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.order,
    required this.title,
    required this.description,
    required this.content,
    this.imageUrl,
    this.estimatedMinutes = 5,
    this.quiz,
    this.isCompleted = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      order: json['order'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
      quiz: (json['quiz'] as List<dynamic>?)
          ?.map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'order': order,
    'title': title,
    'description': description,
    'content': content,
    'imageUrl': imageUrl,
    'estimatedMinutes': estimatedMinutes,
    'quiz': quiz?.map((q) => q.toJson()).toList(),
    'isCompleted': isCompleted,
  };

  Lesson copyWith({bool? isCompleted}) {
    return Lesson(
      id: id,
      order: order,
      title: title,
      description: description,
      content: content,
      imageUrl: imageUrl,
      estimatedMinutes: estimatedMinutes,
      quiz: quiz,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Quiz question model
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correctIndex': correctIndex,
    'explanation': explanation,
  };
}
