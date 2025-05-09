import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/battery_history_controller.dart';

class SensorHistoryDetailPage extends StatelessWidget {
  final String apartmentUnit;
  SensorHistoryDetailPage({super.key, required this.apartmentUnit});
  final BatteryHistoryController controller = Get.put(BatteryHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28.r),
                bottomRight: Radius.circular(28.r),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF0C2A69), Color(0xFF132D46)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 16.h),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios, color: kWhiteColor)),
                Text(
                  "Battery Details",
                  style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: kWhiteColor),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final historyList = controller.historyList;

              if (historyList.isEmpty) {
                return const Center(
                  child: Text(
                    'No valid history records.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  final item = historyList[index];
                  final date = DateFormat('dd MMMM yyyy')
                      .format(DateTime.parse('${item.lastUpdate}-01'));
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 2.8,
                            children: List.generate(item.sensorStatus.length, (i) {
                              final isActive = item.sensorStatus[i];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFFE0F7E9)
                                      : const Color(0xFFFFEAEA),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isActive
                                          ? Icons.check_circle_outline
                                          : Icons.highlight_off,
                                      size: 18,
                                      color: isActive
                                          ? Colors.green
                                          : Colors.redAccent,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'S${i + 1}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isActive
                                            ? Colors.green.shade800
                                            : Colors.red.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                          if ((item.observations?.isNotEmpty ?? false))
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8E1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.note_alt,
                                      color: Colors.orange),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.observations!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
