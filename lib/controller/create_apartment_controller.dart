import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreateApartmentController extends GetxController {
  final apartmentNumber = TextEditingController();
  final apartmentUnit = TextEditingController();
  final regularSensors = TextEditingController();
  final threeFeetCables = TextEditingController();

  final isLoading = false.obs;
  RxString selectedApartmentName = ''.obs;

  Future<void> uploadSensorData() async {
    isLoading.value = true;
    try {
      final String name = selectedApartmentName.value.trim();
      final String number = apartmentNumber.text.trim();
      final String unit = apartmentUnit.text.trim();
      final int regular = int.tryParse(regularSensors.text) ?? 0;
      final int cables = int.tryParse(threeFeetCables.text) ?? 0;
      final int total = regular + cables;

      final List<bool> sensorStatus = List.generate(total, (_) => false);

      final data = {
        "apartmentName": name,
        "apartmentNumber": number,
        "apartmentUnit": unit,
        "regularSensors": regular,
        "threeFeetCables": cables,
        "totalSensors": total,
        "sensorStatus": sensorStatus,
        "isDone": false,
        "lastUpdate": null,
        "observations": "",
      };

      final apartmentRef = FirebaseFirestore.instance.collection('apartments').doc(unit);

      await apartmentRef.set({
        "apartmentName": name,
        "apartmentNumber": number,
        "apartmentUnit": unit,
      });

      await apartmentRef.collection('sensor').add(data);

      Get.snackbar("Success", "Sensor data uploaded successfully", snackPosition: SnackPosition.BOTTOM);
      clearFields();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    selectedApartmentName.value = "";
    apartmentUnit.clear();
    apartmentNumber.clear();
    regularSensors.clear();
    threeFeetCables.clear();
  }
}
