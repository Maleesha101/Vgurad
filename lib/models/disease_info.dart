class DiseaseInfo {
  final String diseaseName;
  final String causedBy;
  final String description;
  final List<String> symptoms;
  final List<String> factors;
  final List<String> prevention;
  final String treatment;
  final String note;

  DiseaseInfo({
    required this.diseaseName,
    required this.causedBy,
    required this.description,
    required this.symptoms,
    required this.factors,
    required this.prevention,
    required this.treatment,
    required this.note,
  });

  factory DiseaseInfo.fromJson(Map<String, dynamic> json) {
    return DiseaseInfo(
      diseaseName: json['info']['disease_name'],
      causedBy: json['info']['caused_by'],
      description: json['info']['description'],
      symptoms: List<String>.from(json['info']['symptoms']),
      factors: List<String>.from(json['info']['factors']),
      prevention: List<String>.from(json['info']['prevention']),
      treatment: json['info']['treatment'],
      note: json['info']['note'],
    );
  }
}
