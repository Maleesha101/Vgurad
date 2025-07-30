class Medicine {
  final String name;
  final String brand;
  final String type;
  final String activeIngredient;
  final String packSize;
  final String price;
  final String imageUrl;
  final String applicationRate;
  final String method;
  final String frequency;
  final String availability;
  final int priority;
  final String note;

  Medicine({
    required this.name,
    required this.brand,
    required this.type,
    required this.activeIngredient,
    required this.packSize,
    required this.price,
    required this.imageUrl,
    required this.applicationRate,
    required this.method,
    required this.frequency,
    required this.availability,
    required this.priority,
    required this.note,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      brand: json['brand'],
      type: json['type'],
      activeIngredient: json['active_ingredient'],
      packSize: json['pack_size'],
      price: json['price'],
      imageUrl: json['image_url'],
      applicationRate: json['application_rate'],
      method: json['method'],
      frequency: json['frequency'],
      availability: json['availability'],
      priority: json['priority'],
      note: json['note'],
    );
  }
}

class MedicineResponse {
  final String name;
  final List<Medicine> recommendedMedicines;

  MedicineResponse({required this.name, required this.recommendedMedicines});

  factory MedicineResponse.fromJson(Map<String, dynamic> json) {
    var list = json['recommended_medicines'] as List;
    List<Medicine> medicinesList =
        list.map((i) => Medicine.fromJson(i)).toList();

    return MedicineResponse(
      name: json['name'],
      recommendedMedicines: medicinesList,
    );
  }
}
