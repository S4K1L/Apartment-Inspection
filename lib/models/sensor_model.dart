import 'package:cloud_firestore/cloud_firestore.dart';

class SensorUnit {
  final String? apartmentUnit;
  final int? totalSensors;
  final int? regularSensors;
  final int? threeFeetCables;
  final DateTime? batteryChangeDate;
  final List<bool> sensorStatus;
  final String? observations;
  final String? apartmentName;
  final String? apartmentNumber;

  SensorUnit({
    this.apartmentUnit,
    this.totalSensors,
    this.regularSensors,
    this.threeFeetCables,
    this.batteryChangeDate,
    required this.sensorStatus,
    this.observations,
    this.apartmentName,
    this.apartmentNumber,
  });

  factory SensorUnit.fromMap(Map<String, dynamic> map) {
    return SensorUnit(
      apartmentUnit: map['apartmentUnit'],
      totalSensors: map['totalSensors'],
      regularSensors: map['regularSensors'],
      threeFeetCables: map['threeFeetCables'],
      batteryChangeDate: (map['batteryChangeDate'] is Timestamp)
          ? (map['batteryChangeDate'] as Timestamp).toDate()
          : null,
      sensorStatus: map['sensorStatus'] != null
          ? List<bool>.from((map['sensorStatus'] as List).map((item) {
        if (item is bool) return item;
        if (item is String) return item.toLowerCase() == 'true';
        return false; // Default fallback
      }))
          : [],
      observations: map['observations'],
      apartmentName: map['apartmentName'],
      apartmentNumber: map['apartmentNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'apartmentUnit': apartmentUnit,
      'totalSensors': totalSensors,
      'regularSensors': regularSensors,
      'threeFeetCables': threeFeetCables,
      'batteryChangeDate': batteryChangeDate,
      'sensorStatus': sensorStatus,
      'observations': observations,
      'apartmentName': apartmentName,
      'apartmentNumber': apartmentNumber,
    };
  }

  SensorUnit copyWith({
    String? apartmentUnit,
    int? totalSensors,
    int? regularSensors,
    int? threeFeetCables,
    DateTime? batteryChangeDate,
    List<bool>? sensorStatus,
    String? observations,
    String? apartmentName,
    String? apartmentNumber,
  }) {
    return SensorUnit(
      apartmentUnit: apartmentUnit ?? this.apartmentUnit,
      totalSensors: totalSensors ?? this.totalSensors,
      regularSensors: regularSensors ?? this.regularSensors,
      threeFeetCables: threeFeetCables ?? this.threeFeetCables,
      batteryChangeDate: batteryChangeDate ?? this.batteryChangeDate,
      sensorStatus: sensorStatus ?? this.sensorStatus,
      observations: observations ?? this.observations,
      apartmentName: apartmentName ?? this.apartmentName,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
    );
  }
}
