// models/tips_response.dart
class TipsResponse {
  final List<String> tips;

  TipsResponse({required this.tips});

  factory TipsResponse.fromJson(List<dynamic> json) {
    return TipsResponse(tips: json.map((tip) => tip.toString()).toList());
  }

  List<dynamic> toJson() {
    return tips;
  }
}
