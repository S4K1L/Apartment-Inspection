import 'package:apartmentinspection/models/battery_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/apartment_model.dart';
import '../models/sensor_model.dart';

class BatteryHistoryController extends GetxController {
  final _firestore = FirebaseFirestore.instance;

  RxList<ApartmentModel> apartments = <ApartmentModel>[].obs;
  RxList<ApartmentModel> filteredApartments = <ApartmentModel>[].obs;
  RxString selectedApartment = ''.obs;

  RxList<SensorHistoryItem> historyList = <SensorHistoryItem>[].obs;
  RxList<SensorHistoryItem> allSensorUnits = <SensorHistoryItem>[].obs;

  RxBool isLoading = false.obs;

  /// Fetch all apartments from Firestore and initialize filtered list
  Future<void> fetchApartments(String apartmentName) async {
    try {
      isLoading.value = true;

      final snapshot = await _firestore.collection('apartments').where('apartmentName', isEqualTo: apartmentName).get();

      final fetchedApartments = snapshot.docs
          .map((doc) => ApartmentModel.fromFirestore(doc.data(), doc.id))
          .toList();

      apartments.assignAll(fetchedApartments);
      filteredApartments.assignAll(fetchedApartments);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error fetching apartments: $e");
    }
  }

  /// Update the selected apartment
  Future<void> selectApartment(String unit) async {
    selectedApartment.value = unit;
  }

  /// Fetch sensor history records for the selected apartment
  Future<void> fetchSensorHistory(String unit) async {
    try {
      isLoading.value = true;
      historyList.clear();
      allSensorUnits.clear();

      final sensorSnapshot = await _firestore
          .collection('apartments')
          .doc(unit)
          .collection('sensor')
          .get();

      final List<SensorHistoryItem> fetchedHistory = [];

      for (var doc in sensorSnapshot.docs) {
        final dateKey = doc.id;

        // Only process valid yyyy-MM formatted keys
        if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(dateKey)) continue;

        final data = doc.data();
        final historyItem = SensorHistoryItem.fromFirestore(dateKey, data);
        fetchedHistory.add(historyItem);
      }

      // Sort history descending by date
      fetchedHistory.sort((a, b) => b.dateKey.compareTo(a.dateKey));

      historyList.assignAll(fetchedHistory);
      allSensorUnits.assignAll(fetchedHistory);
    } catch (e) {
      print("Error fetching sensor history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter apartments by name, number, or unit
  void searchFilter(String query) {
    if (query.isEmpty) {
      filteredApartments.assignAll(apartments);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredApartments.assignAll(
        apartments.where((apartment) =>
        apartment.apartmentName.toLowerCase().contains(lowerQuery) ||
            apartment.apartmentNumber.toLowerCase().contains(lowerQuery) ||
            apartment.apartmentUnit.toLowerCase().contains(lowerQuery)
        ).toList(),
      );
    }
  }

}
