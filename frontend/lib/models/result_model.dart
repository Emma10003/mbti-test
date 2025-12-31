import 'answer_model.dart';

class Result {
  final int id;
  final String userName;
  final String resultType;
  final int eScore;
  final int iScore;
  final int sScore;
  final int nScore;
  final int tScore;
  final int fScore;
  final int jScore;
  final int pScore;
  final String? createdAt;

  // 조인용 추가 필드 (mbti_types 테이블)
  final String? typeName;
  final String? description;
  final String? characteristics;
  final String? strengths;
  final String? weaknesses;

  // 답변 목록
  final List<Answer>? answers;

  Result({
    required this.id,
    required this.userName,
    required this.resultType,
    required this.eScore,
    required this.iScore,
    required this.sScore,
    required this.nScore,
    required this.tScore,
    required this.fScore,
    required this.jScore,
    required this.pScore,
    this.createdAt,
    this.typeName,
    this.description,
    this.characteristics,
    this.strengths,
    this.weaknesses,
    this.answers,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    try {
      return Result(
        id: json['id'] as int,
        userName: json['userName'] as String,
        resultType: json['resultType'] as String,
        // Spring Boot는 소문자로 보내므로 소문자 키 사용
        eScore: json['escore'] as int,
        iScore: json['iscore'] as int,
        sScore: json['sscore'] as int,
        nScore: json['nscore'] as int,
        tScore: json['tscore'] as int,
        fScore: json['fscore'] as int,
        jScore: json['jscore'] as int,
        pScore: json['pscore'] as int,
        createdAt: json['createdAt'] as String?,
        typeName: json['typeName'] as String?,
        description: json['description'] as String?,
        characteristics: json['characteristics'] as String?,
        strengths: json['strengths'] as String?,
        weaknesses: json['weaknesses'] as String?,
        answers: json['answers'] != null
            ? (json['answers'] as List)
            .map((a) => Answer.fromJson(a))
            .toList()
            : null,
      );
    } catch (e) {
      throw Exception('Result.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'resultType': resultType,
      'eScore': eScore,
      'iScore': iScore,
      'sScore': sScore,
      'nScore': nScore,
      'tScore': tScore,
      'fScore': fScore,
      'jScore': jScore,
      'pScore': pScore,
      'createdAt': createdAt,
      'typeName': typeName,
      'description': description,
      'characteristics': characteristics,
      'strengths': strengths,
      'weaknesses': weaknesses,
    };
  }

  // 각 차원별 우세 타입 계산
  String get eiType => eScore >= iScore ? 'E' : 'I';
  String get snType => sScore >= nScore ? 'S' : 'N';
  String get tfType => tScore >= fScore ? 'T' : 'F';
  String get jpType => jScore >= pScore ? 'J' : 'P';

  // 각 차원별 점수 차이
  int get eiDiff => (eScore - iScore).abs();
  int get snDiff => (sScore - nScore).abs();
  int get tfDiff => (tScore - fScore).abs();
  int get jpDiff => (jScore - pScore).abs();
}