class ApartmentModel {
  final String id;
  final String apartmentNumber;
  final String apartmentUnit;
  final String apartmentName;

  ApartmentModel({
    required this.id,
    required this.apartmentNumber,
    required this.apartmentUnit,
    required this.apartmentName,
  });

  factory ApartmentModel.fromMap(Map<String, dynamic> map, String docId) {
    return ApartmentModel(
      id: docId,
      apartmentNumber: map['apartmentNumber'] ?? '',
      apartmentUnit: map['apartmentUnit'] ?? '',
      apartmentName: map['apartmentName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'apartmentNumber': apartmentNumber,
      'apartment': apartmentUnit,
      'apartmentName': apartmentName,
    };
  }

  factory ApartmentModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ApartmentModel(
      id: docId,
      apartmentName: data['apartmentName'] ?? '',
      apartmentNumber: data['apartmentNumber'] ?? '',
      apartmentUnit: data['apartmentUnit'] ?? '',
    );
  }

  }
