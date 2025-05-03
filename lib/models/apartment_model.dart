class ApartmentModel {
  final String id;
  final String number;
  final String unit;
  final String apartmentName;

  ApartmentModel({
    required this.id,
    required this.number,
    required this.unit,
    required this.apartmentName,
  });

  factory ApartmentModel.fromMap(Map<String, dynamic> map, String docId) {
    return ApartmentModel(
      id: docId,
      number: map['number'] ?? '',
      unit: map['unit'] ?? '',
      apartmentName: map['apartmentName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'unit': unit,
      'apartmentName': apartmentName,
    };
  }
}
