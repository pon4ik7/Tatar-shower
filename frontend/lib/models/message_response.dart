//TODO: Verify if the model valid
class MessageResponse {
  String message;

  MessageResponse({required this.message});

  Map<String, dynamic> toJson() {
    return {"message": message};
  }

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(message: json['message'] as String);
  }
}
