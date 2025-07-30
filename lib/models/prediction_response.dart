class PredictionResponse {
  final String predictedClass;
  final double confidence;
  final Map<String, double> allConfidences;

  PredictionResponse({
    required this.predictedClass,
    required this.confidence,
    required this.allConfidences,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      predictedClass: json['predicted_class'],
      confidence: (json['confidence'] as num).toDouble(),
      allConfidences: Map<String, double>.from(
        json['all_confidences'].map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
    );
  }
}
