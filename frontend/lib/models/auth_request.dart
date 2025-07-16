// Valid request for user authorisation
class AuthRequest {
  String login;
  String password;

  AuthRequest({required this.login, required this.password});

  Map<String, dynamic> toJson() {
    return {"login": login, "password": password};
  }

  factory AuthRequest.fromJson(Map<String, dynamic> json) {
    return AuthRequest(
      login: json['login'] as String,
      password: json['password'] as String,
    );
  }
}
