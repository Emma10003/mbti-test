class TestAnswer {
  final int questionId;
  final String selectedOption; // 'A' or 'B'

  TestAnswer({
    required this.questionId,
    required this.selectedOption,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedOption': selectedOption,
    };
  }

  factory TestAnswer.fromJson(Map<String, dynamic> json) {
    try {
      return TestAnswer(
        questionId: json['questionId'] as int,
        selectedOption: json['selectedOption'] as String,
      );
    } catch (e) {
      throw Exception('TestAnswer.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }
}

class Answer {
  final int id;
  final int resultId;
  final int questionId;
  final String selectedOption;
  final String selectedType;
  final String? createdAt;

  Answer({
    required this.id,
    required this.resultId,
    required this.questionId,
    required this.selectedOption,
    required this.selectedType,
    this.createdAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    try {
      return Answer(
        id: json['id'] as int,
        resultId: json['resultId'] as int,
        questionId: json['questionId'] as int,
        selectedOption: json['selectedOption'] as String,
        selectedType: json['selectedType'] as String,
        createdAt: json['createdAt'] as String?,
      );
    } catch (e) {
      throw Exception('Answer.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }
}