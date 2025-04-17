class User {
  final String id;
  final String nickname;
  final String birthYear;
  final String gender;
  final String location;
  final String phoneNumber;
  final DateTime createdAt;

  User({
    required this.id,
    required this.nickname,
    required this.birthYear,
    required this.gender,
    required this.location,
    required this.phoneNumber,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nickname: json['nickname'],
      birthYear: json['birthYear'],
      gender: json['gender'],
      location: json['location'],
      phoneNumber: json['phoneNumber'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'birthYear': birthYear,
      'gender': gender,
      'location': location,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
