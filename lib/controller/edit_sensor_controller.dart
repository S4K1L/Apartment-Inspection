import 'package:apartmentinspection/views/bottom_navbar/user_bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/battery_history_model.dart';

class EditSensorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<bool> sensorStatus = <bool>[].obs;
  RxBool isLoading = false.obs;

  late String apartmentName;
  late String unit;
  late String dateKey;

  final TextEditingController observationController = TextEditingController();

  void initialize(SensorHistoryItem item) {
    sensorStatus.value = List<bool>.from(item.sensorStatus);
    observationController.text = item.observations ?? '';
    apartmentName = item.apartmentName;
    unit = item.apartmentUnit;
    dateKey = item.dateKey;
  }

  void toggleSensor(int index) {
    sensorStatus[index] = !sensorStatus[index];
  }

  Future<void> saveSensorData() async {
    isLoading.value = true;

    try {
      await _firestore
          .collection('apartments')
          .doc(unit)
          .collection('sensor')
          .doc(dateKey)
          .set({
        'sensorStatus': sensorStatus,
        'observations': observationController.text.trim(),
        'lastUpdate': DateTime.now().toIso8601String().split("T").first,
        'apartmentName': apartmentName,
        'apartmentUnit': unit,
        'totalSensors': sensorStatus.length,
      }, SetOptions(merge: true));

      Get.offAll(()=> UserCustomBottomBar());
      Get.snackbar("Success", "Sensor data updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to update sensor data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    observationController.dispose();
    super.onClose();
  }
}
