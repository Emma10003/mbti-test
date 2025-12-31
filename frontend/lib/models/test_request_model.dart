import 'answer_model.dart';

class TestRequest {
  final String userName;
  final List<TestAnswer> answers;

  TestRequest({
    required this.userName,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }

  factory TestRequest.fromJson(Map<String, dynamic> json) {
    return TestRequest(
      userName: json['userName'],
      answers: (json['answers'] as List)
          .map((a) => TestAnswer.fromJson(a))
          .toList(),
    );
  }
}