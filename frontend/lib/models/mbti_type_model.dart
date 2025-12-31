class MbtiType {
  final int id;
  final String typeCode;
  final String typeName;
  final String? description;
  final String? characteristics;
  final String? strengths;
  final String? weaknesses;
  final String? createdAt;

  MbtiType({
    required this.id,
    required this.typeCode,
    required this.typeName,
    this.description,
    this.characteristics,
    this.strengths,
    this.weaknesses,
    this.createdAt,
  });

  factory MbtiType.fromJson(Map<String, dynamic> json) {
    try {
      return MbtiType(
        id: json['id'],
        typeCode: json['typeCode'],
        typeName: json['typeName'],
        description: json['description'],
        characteristics: json['characteristics'],
        strengths: json['strengths'],
        weaknesses: json['weaknesses'],
        createdAt: json['createdAt'],
      );
    } catch (e) {
      throw Exception('MbtiType.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'typeCode': typeCode,
      'typeName': typeName,
      'description': description,
      'characteristics': characteristics,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'createdAt': createdAt,
    };
  }
}