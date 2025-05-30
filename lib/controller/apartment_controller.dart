import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../models/apartment_model.dart';

class ApartmentController extends GetxController {
  var isLoading = true.obs;
  var apartmentList = <ApartmentModel>[].obs;
  var filteredList = <ApartmentModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    fetchApartments();
    super.onInit();
  }

  void fetchApartments() async {
    try {
      isLoading(true);
      final snapshot = await _firestore.collection('apartments').get();
      apartmentList.value = snapshot.docs.map((doc) {
        return ApartmentModel.fromMap(doc.data(), doc.id);
      }).toList();
      filteredList.value = apartmentList;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch data: $e");
    } finally {
      isLoading(false);
    }
  }

  void filterApartments(String query) {
    if (query.isEmpty) {
      filteredList.value = apartmentList;
    } else {
      final q = query.toLowerCase();
      filteredList.value = apartmentList.where((apartment) {
        return apartment.apartmentNumber.toLowerCase().contains(q) ||
            apartment.apartmentUnit.toLowerCase().contains(q) || apartment.apartmentName.toLowerCase().contains(q);
      }).toList();
    }
  }
}
