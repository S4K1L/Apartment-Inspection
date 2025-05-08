import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/battery_history_controller.dart';

class SensorHistoryDetailPage extends StatelessWidget {
  final String apartmentUnit;
  final controller = Get.find<ApartmentHistoryController>();

  SensorHistoryDetailPage({super.key, required this.apartmentUnit});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.fetchSensorHistory(apartmentUnit),  // Fix: use fetchSensorHistory
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final historyList = controller.historyList;  // Use the controller's historyList

        return Scaffold(
          appBar: AppBar(
            title: Text('History: $apartmentUnit'),
            backgroundColor: Colors.blue.shade800,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: historyList.isEmpty
                ? const Center(child: Text('No valid history records.'))
                : ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                final date = DateFormat('MMMM yyyy').format(DateTime.parse('${item.dateKey}-01'));

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(date, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: List.generate(item.sensorStatus.length, (i) {
                            final isActive = item.sensorStatus[i];
                            return Chip(
                              label: Text('Sensor ${i + 1}'),
                              backgroundColor: isActive ? Colors.green[100] : Colors.red[100],
                              labelStyle: TextStyle(color: isActive ? Colors.green[900] : Colors.red[900]),
                            );
                          }),
                        ),
                        if (item.observations?.isNotEmpty ?? false)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Observation: ${item.observations!}",
                                style: const TextStyle(color: Colors.grey)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
