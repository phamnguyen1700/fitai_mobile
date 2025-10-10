class UserModel {
  final String id;
  final String email;
  final String token;

  UserModel({required this.id, required this.email, required this.token});

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
    id: m['id'] as String,
    email: m['email'] as String,
    token: m['token'] as String,
  );
}
