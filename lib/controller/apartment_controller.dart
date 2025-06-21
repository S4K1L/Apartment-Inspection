import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../models/apartment_model.dart';

class ApartmentController extends GetxController {
  var isLoading = true.obs;
  var apartmentList = <String>[].obs;
  var unitList = <ApartmentModel>[].obs;
  var filteredList = <ApartmentModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    fetchApartments();
    super.onInit();
  }

  /// Fetch unique apartment names from /apartments_data/
  void fetchApartments() async {
    try {
      isLoading(true);
      apartmentList.clear();

      final snapshot = await _firestore.collection('apartments').get();

      final Set<String> apartmentNames = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey("apartmentName")) {
          apartmentNames.add(data["apartmentName"]);
        }
      }

      if (apartmentNames.isEmpty) {
        print("⭕️ No apartments found.");
      } else {
        print("✅ Apartments found: ${apartmentNames.length}");
      }
      apartmentList.value = apartmentNames.toList();
    } catch (e) {
      print("❌ Firestore error: $e");
      Get.snackbar("Error", "Failed to fetch apartments: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Fetch all units in /apartments_data/ with matching apartmentName
  void fetchAllUnits(String apartmentName) async {
    try {
      isLoading(true);
      unitList.clear();

      final snapshot = await _firestore
          .collection('apartments')
          .where('apartmentName', isEqualTo: apartmentName)
          .orderBy('apartmentUnit', descending: false)
          .get();

      final units = snapshot.docs.map((doc) {
        return ApartmentModel.fromMap(doc.data(), doc.id);
      }).toList();

      unitList.value = units;
      filteredList.value = units;

      print("✅ Fetched ${units.length} units for '$apartmentName'");
    } catch (e) {
      print("❌ Failed to fetch units: $e");
      Get.snackbar("Error", "Failed to fetch units: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Filter units by apartment name, unit, or number
  void filterApartments(String query) {
    if (query.isEmpty) {
      filteredList.value = unitList;
    } else {
      final q = query.toLowerCase();
      filteredList.value = unitList.where((unit) {
        return unit.apartmentName.toLowerCase().contains(q) ||
            unit.apartmentUnit.toLowerCase().contains(q) ||
            unit.apartmentNumber.toLowerCase().contains(q);
      }).toList();
    }
  }
}
