class UserModel {
  final String uid;
  final String username;
  final String gender; // "male" أو "female"

  UserModel({
    required this.uid,
    required this.username,
    required this.gender,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      uid: docId,
      username: map['username'] ?? 'مستخدم',
      gender: map['gender'] ?? 'male',
    );
  }
}