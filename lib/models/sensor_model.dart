import 'package:cloud_firestore/cloud_firestore.dart';

class SensorUnit {
  final String? apartmentUnit;
  final int? totalSensors;
  final int? regularSensors;
  final int? threeFeetCables;
  final DateTime? lastUpdate;
  final List<bool> sensorStatus;
  final String? observations;
  final String? apartmentName;
  final String? apartmentNumber;
  final bool? isDone;

  SensorUnit({
    this.apartmentUnit,
    this.totalSensors,
    this.regularSensors,
    this.threeFeetCables,
    this.lastUpdate,
    required this.sensorStatus,
    this.observations,
    this.apartmentName,
    this.apartmentNumber,
    this.isDone,
  });

  factory SensorUnit.fromMap(Map<String, dynamic> map) {
    return SensorUnit(
      apartmentUnit: map['apartmentUnit'],
      totalSensors: map['totalSensors'],
      regularSensors: map['regularSensors'],
      threeFeetCables: map['threeFeetCables'],
      lastUpdate: (map['lastUpdate'] is Timestamp)
          ? (map['lastUpdate'] as Timestamp).toDate()
          : null,
      sensorStatus: map['sensorStatus'] != null
          ? List<bool>.from((map['sensorStatus'] as List).map((item) {
        if (item is bool) return item;
        if (item is String) return item.toLowerCase() == 'true';
        return false;
      }))
          : [],
      observations: map['observations'],
      apartmentName: map['apartmentName'],
      apartmentNumber: map['apartmentNumber'],
      isDone: map['isDone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'apartmentUnit': apartmentUnit,
      'totalSensors': totalSensors,
      'regularSensors': regularSensors,
      'threeFeetCables': threeFeetCables,
      'lastUpdate': lastUpdate,
      'sensorStatus': sensorStatus,
      'observations': observations,
      'apartmentName': apartmentName,
      'apartmentNumber': apartmentNumber,
      'isDone': isDone,
    };
  }

  SensorUnit copyWith({
    String? apartmentUnit,
    int? totalSensors,
    int? regularSensors,
    int? threeFeetCables,
    DateTime? lastUpdate,
    List<bool>? sensorStatus,
    String? observations,
    String? apartmentName,
    String? apartmentNumber,
    bool? isDone,
  }) {
    return SensorUnit(
      apartmentUnit: apartmentUnit ?? this.apartmentUnit,
      totalSensors: totalSensors ?? this.totalSensors,
      regularSensors: regularSensors ?? this.regularSensors,
      threeFeetCables: threeFeetCables ?? this.threeFeetCables,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      sensorStatus: sensorStatus ?? this.sensorStatus,
      observations: observations ?? this.observations,
      apartmentName: apartmentName ?? this.apartmentName,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      isDone: isDone ?? this.isDone,
    );
  }
}
