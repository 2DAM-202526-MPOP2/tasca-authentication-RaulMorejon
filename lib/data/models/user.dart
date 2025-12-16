
class User {
  final String username;
  final bool authenticated;
  final int id;
  final String? email; // IMPORTANT QUE SIGUI NULLABLE 
  final String? accessToken;

  User({
    required this.username,
    required this.authenticated,
    required this.id,
    this.email,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    
    return User(
      username: json['username'] as String,
      authenticated: true,
      id: json['id'] as int,
      email: json['email'] as String?,
      accessToken: json['token'] as String?, 
    );
    
  }
}