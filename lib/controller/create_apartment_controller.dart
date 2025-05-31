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

      /// Unit metadata to be saved in /apartments_data/{unitId}
      final unitData = {
        "apartmentName": name,
        "apartmentNameLower": name.toLowerCase(),
        "apartmentNumber": number,
        "apartmentUnit": unit,
        "createdAt": FieldValue.serverTimestamp(), // Optional metadata
      };

      /// Sensor-specific data for /sensors/ subcollection
      final sensorData = {
        "regularSensors": regular,
        "threeFeetCables": cables,
        "totalSensors": total,
        "sensorStatus": sensorStatus,
        "isDone": false,
        "lastUpdate": null,
        "observations": "",
        "apartmentName": name,
        "apartmentNumber": number,
        "apartmentUnit": unit,
      };

      /// Add unit document to /apartments/
      final unitDocRef = await FirebaseFirestore.instance
          .collection('apartments')
          .add(unitData);

      /// Add sensor document under /apartments_data/{unitId}/sensors/
      await unitDocRef.collection('sensors').add(sensorData);

      Get.snackbar("Success", "Sensor data uploaded successfully",
          snackPosition: SnackPosition.BOTTOM);
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
