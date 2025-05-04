import 'package:apartmentinspection/models/sensor_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorController extends GetxController {
  var sensorUnits = <SensorUnit>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFromFirebase();
  }

  Future<void> fetchFromFirebase() async {
    try {
      final apartmentSnapshot = await FirebaseFirestore.instance.collection('apartments').get();

      List<SensorUnit> allUnits = [];

      for (var apartmentDoc in apartmentSnapshot.docs) {
        final sensorSnapshot = await apartmentDoc.reference
            .collection('sensor')
            .orderBy(FieldPath.documentId, descending: true)
            .limit(1)
            .get();

        if (sensorSnapshot.docs.isNotEmpty) {
          final sensorData = sensorSnapshot.docs.first.data();

          final unit = SensorUnit.fromMap({
            ...sensorData,
            'apartmentUnit': apartmentDoc.id,
          });

          allUnits.add(unit);
        }
      }

      sensorUnits.assignAll(allUnits);
    } catch (e) {
      print('Error fetching apartments with sensors: $e');
    }
  }

  void updateCheckbox(int unitIndex, int sensorIndex, bool value) {
    final unit = sensorUnits[unitIndex];
    final currentStatus = unit.sensorStatus ?? List.filled(14, false);
    final newStatus = List<bool>.from(currentStatus);
    if (sensorIndex < newStatus.length) {
      newStatus[sensorIndex] = value;
    } else {
      // Extend the list if needed
      newStatus.length = sensorIndex + 1;
      newStatus[sensorIndex] = value;
    }
    sensorUnits[unitIndex] = unit.copyWith(sensorStatus: newStatus);
  }

  void updateObservation(int unitIndex, String text) {
    final unit = sensorUnits[unitIndex];
    sensorUnits[unitIndex] = unit.copyWith(observations: text);
  }

  Future<void> uploadToFirebase() async {
    final now = DateTime.now();
    final monthKey = "${now.year}-${now.month.toString().padLeft(2, '0')}";

    for (var unit in sensorUnits) {
      final unitId = unit.apartmentUnit ?? "unknown";
      await FirebaseFirestore.instance
          .collection("apartments")
          .doc(unitId)
          .collection("sensor")
          .doc(monthKey)
          .set(unit.toMap());
    }
  }

  List<SensorUnit> get reminders {
    final now = DateTime.now();
    return sensorUnits.where((unit) {
      final diff = unit.batteryChangeDate?.difference(now).inDays ?? -999;
      return diff >= 0 && diff <= 30;
    }).toList();
  }
}
