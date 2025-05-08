import 'package:cloud_firestore/cloud_firestore.dart';

class SensorHistoryItem {
  final String dateKey;
  final String apartmentName;
  final String apartmentNumber;
  final String apartmentUnit;
  final bool isDone;
  final DateTime? lastUpdate;
  final String? observations;
  final int regularSensors;
  final int threeFeetCables;
  final int totalSensors;
  final List<bool> sensorStatus;

  SensorHistoryItem({
    required this.dateKey,
    required this.apartmentName,
    required this.apartmentNumber,
    required this.apartmentUnit,
    required this.isDone,
    required this.lastUpdate,
    this.observations,
    required this.regularSensors,
    required this.threeFeetCables,
    required this.totalSensors,
    required this.sensorStatus,
  });

  factory SensorHistoryItem.fromFirestore(String dateKey, Map<String, dynamic> data) {
    return SensorHistoryItem(
      dateKey: dateKey,
      apartmentName: data['apartmentName'] ?? '',
      apartmentNumber: data['apartmentNumber'] ?? '',
      apartmentUnit: data['apartmentUnit'] ?? '',
      isDone: data['isDone'] ?? false,
      lastUpdate: (data['lastUpdate'] as Timestamp?)?.toDate(),
      observations: data['observations'],
      regularSensors: data['regularSensors'] ?? 0,
      threeFeetCables: data['threeFeetCables'] ?? 0,
      totalSensors: data['totalSensors'] ?? 0,
      sensorStatus: List<bool>.from(data['sensorStatus'] ?? []),
    );
  }
}
