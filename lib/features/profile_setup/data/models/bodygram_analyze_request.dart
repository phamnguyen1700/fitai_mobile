class BodygramAnalyzeRequest {
  final String bodyDataId;

  BodygramAnalyzeRequest({required this.bodyDataId});

  Map<String, dynamic> toJson() {
    return {'bodyDataId': bodyDataId};
  }
}
