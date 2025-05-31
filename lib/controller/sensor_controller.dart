import 'package:apartmentinspection/models/sensor_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorController extends GetxController {
  var sensorUnits = <SensorUnit>[].obs;
  var allSensorUnits = <SensorUnit>[].obs; // Store all units
  final observationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchFromFirebase();
  }

  // 0. Fetch sensor data where isDone == false
  Future<void> fetchFromFirebase() async {
    try {
      final apartmentSnapshot =
          await FirebaseFirestore.instance.collection('apartments').get();

      List<SensorUnit> allUnits = [];

      for (var apartmentDoc in apartmentSnapshot.docs) {
        final sensorSnapshot = await apartmentDoc.reference
            .collection('sensors')
            .where('isDone', isEqualTo: false)
            .orderBy(FieldPath.documentId, descending: true)
            .limit(1)
            .get();

        if (sensorSnapshot.docs.isNotEmpty) {
          final sensorData = sensorSnapshot.docs.first.data();
          final unit = SensorUnit.fromMap({
            ...sensorData,
            'apartmentDocId': apartmentDoc.id,
          });

          allUnits.add(unit);
        }
      }

      allSensorUnits.assignAll(allUnits);
      sensorUnits.assignAll(allUnits);
    } catch (e) {
      print('Error fetching sensor data: $e');
    }
  }

  // 1. Toggle sensor checkbox
  void updateCheckbox(int unitIndex, int sensorIndex, bool value) {
    final unit = sensorUnits[unitIndex];
    final currentStatus = unit.sensorStatus;
    final newStatus = List<bool>.from(currentStatus);

    if (sensorIndex >= newStatus.length) {
      newStatus.length = sensorIndex + 1;
      for (int i = currentStatus.length; i <= sensorIndex; i++) {
        newStatus[i] = false;
      }
    }

    newStatus[sensorIndex] = value;
    sensorUnits[unitIndex] = unit.copyWith(sensorStatus: newStatus);
  }

  // 2 & 3. Save updates, set isDone=true, lastUpdate=now, then create a null sensor doc
  Future<void> saveSensorData(int index) async {
    try {
      final unit = sensorUnits[index];
      final now = DateTime.now();
      final monthKey = "${now.year}-${now.month.toString().padLeft(2, '0')}";

      final updatedUnit = unit.copyWith(
        isDone: true,
        lastUpdate: now,
        observations: observationController.text,
      );

      // Update current document
      await FirebaseFirestore.instance
          .collection("apartments")
          .doc(unit.apartmentUnit)
          .collection("sensor")
          .doc(monthKey)
          .set(updatedUnit.toMap());

      Get.snackbar("Success", "Sensor data updated");
      fetchFromFirebase();
    } catch (e) {
      print("Error saving sensor data: $e");
      Get.snackbar("Error", "Failed to update sensor data");
    }
  }

  // 4. Filter upcoming inspections
  List<SensorUnit> get reminders {
    final now = DateTime.now();
    return sensorUnits.where((unit) {
      final diff = unit.lastUpdate?.difference(now).inDays ?? -999;
      return diff >= 0 && diff <= 30;
    }).toList();
  }

  void searchFilter(String query) {
    if (query.isEmpty) {
      sensorUnits.value = allSensorUnits;
    } else {
      sensorUnits.value = allSensorUnits
          .where((unit) =>
              unit.apartmentName!.toLowerCase().contains(query.toLowerCase()) ||
              unit.apartmentNumber!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              unit.apartmentUnit!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    observationController.clear();
  }
}
