import 'package:apartmentinspection/models/battery_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/apartment_model.dart';

class ApartmentHistoryController extends GetxController {
  final _firestore = FirebaseFirestore.instance;

  RxList<ApartmentModel> apartments = <ApartmentModel>[].obs;
  RxString selectedApartment = ''.obs;
  RxList<SensorHistoryItem> historyList = <SensorHistoryItem>[].obs;

  Future<void> fetchApartments() async {
    final snapshot = await FirebaseFirestore.instance.collection('apartments').get();
    apartments.value = snapshot.docs.map((doc) =>
        ApartmentModel.fromFirestore(doc.data(), doc.id)).toList();
  }

  Future<void> selectApartment(String unit) async {
    selectedApartment.value = unit;
    await fetchSensorHistory(unit);
  }

  Future<void> fetchSensorHistory(String unit) async {
    historyList.clear();

    try {
      final sensorSnapshot = await _firestore
          .collection('apartments')
          .doc(unit)
          .collection('sensor')
          .get();

      for (var doc in sensorSnapshot.docs) {
        final dateKey = doc.id;

        if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(dateKey)) continue;

        final data = doc.data();
        final historyItem = SensorHistoryItem.fromFirestore(dateKey, data);
        historyList.add(historyItem);
      }

      historyList.sort((a, b) => b.dateKey.compareTo(a.dateKey));
    } catch (e) {
      print("Error fetching sensor history: $e");
    }
  }
}
