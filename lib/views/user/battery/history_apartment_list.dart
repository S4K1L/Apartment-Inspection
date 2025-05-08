// import 'package:apartmentinspection/controller/battery_history_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'battery_history_page.dart';
//
// class ApartmentListPage extends StatelessWidget {
//   final controller = Get.put(ApartmentHistoryController());
//
//   ApartmentListPage({super.key}) {
//     controller.fetchApartments(); // Trigger only once on widget creation
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Apartments With History"),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Obx(() {
//           if (controller.apartments.isEmpty) {
//             return const Center(child: Text('No apartments with sensor history.'));
//           }
//
//           return ListView.builder(
//             itemCount: controller.apartments.length,
//             itemBuilder: (context, index) {
//               final aptId = controller.apartments[index];
//
//               return Card(
//                 elevation: 4,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: ListTile(
//                   title: Text("Apartment: $aptId",
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: const Text("Tap to view sensor history"),
//                   trailing: const Icon(Icons.arrow_forward_ios),
//                   onTap: () {
//                     controller.selectApartment(aptId);
//                     Get.to(() => SensorHistoryPage());
//                   },
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }
