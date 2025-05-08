import 'package:apartmentinspection/views/user/battery/battery_history_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/battery_history_controller.dart';

class SensorHistoryPage extends StatelessWidget {
  final controller = Get.put(ApartmentHistoryController());

  SensorHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchApartments();  // Fetch apartments with valid sensor history

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Apartment'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Obx(() {
        final apartments = controller.apartments;
        if (apartments.isEmpty) {
          return const Center(child: Text('No apartment history found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: apartments.length,
          itemBuilder: (context, index) {
            final unit = apartments[index].apartmentUnit;
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title: Text('Apartment Unit: $unit'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(() => SensorHistoryDetailPage(apartmentUnit: unit));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
