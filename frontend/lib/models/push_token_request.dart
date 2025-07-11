// models/push_token_request.dart
class PushTokenRequest {
  final String token;
  final String platform;

  PushTokenRequest({required this.token, required this.platform});

  Map<String, dynamic> toJson() {
    return {'token': token, 'platform': platform};
  }
}
