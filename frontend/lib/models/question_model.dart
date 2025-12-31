class Question {
  final int id;
  final int questionNumber;
  final String questionText;
  final String dimension;
  final String optionA;
  final String optionB;
  final String optionAType;
  final String optionBType;

  Question({
    required this.id,
    required this.questionNumber,
    required this.questionText,
    required this.dimension,
    required this.optionA,
    required this.optionB,
    required this.optionAType,
    required this.optionBType,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    try {
      return Question(
        id: json['id'] as int,
        questionNumber: json['questionNumber'] as int,
        questionText: json['questionText'] as String,
        dimension: json['dimension'] as String,
        optionA: json['optionA'] as String,
        optionB: json['optionB'] as String,
        optionAType: json['optionAType'] as String,
        optionBType: json['optionBType'] as String,
      );
    } catch (e) {
      throw Exception('Question.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionNumber': questionNumber,
      'questionText': questionText,
      'dimension': dimension,
      'optionA': optionA,
      'optionB': optionB,
      'optionAType': optionAType,
      'optionBType': optionBType,
    };
  }
}