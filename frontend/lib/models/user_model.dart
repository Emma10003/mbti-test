class User {
  final int id;
  final String userName;
  final String? createdAt;
  final String? lastLogin;

  User({
    required this.id,
    required this.userName,
    this.createdAt,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      userName: json['userName'] as String,
      createdAt: json['createdAt'] as String?,
      lastLogin: json['lastLogin'] as String?,
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
    };
  }
}