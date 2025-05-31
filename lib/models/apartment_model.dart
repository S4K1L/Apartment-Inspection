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

  /// Creates an ApartmentModel from Firestore document data
  factory ApartmentModel.fromMap(Map<String, dynamic> map, String docId) {
    return ApartmentModel(
      id: docId,
      apartmentNumber: map['apartmentNumber'] ?? '',
      apartmentUnit: map['apartmentUnit'] ?? '',
      apartmentName: map['apartmentName'] ?? '',
    );
  }

  /// Converts the model into a Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'apartmentNumber': apartmentNumber,
      'apartmentUnit': apartmentUnit,
      'apartmentName': apartmentName,
    };
  }

  /// Optionally support creating a model from Firestore data
  factory ApartmentModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ApartmentModel.fromMap(data, docId);
  }
}
