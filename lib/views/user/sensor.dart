import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/controller/sensor_controller.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/user/sensor/sensor_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SensorPage extends StatelessWidget {
  final SensorController controller = Get.put(SensorController());
  SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf4f6fb),
      appBar: AppBar(
        elevation: 4,
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 8.sp),
            Image.asset(Const.logo, height: 30.sp),
            SizedBox(width: 10.sp),
            Text("Sensor Manager",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, color: kPrimaryColor)),
            const Spacer(),
            Image.asset(Const.bar, height: 26.sp),
            SizedBox(width: 8.sp),
          ],
        ),
      ),
      body: Obx(() {
        return Bounce(
          duration: const Duration(milliseconds: 700),
          child: RefreshIndicator(
            onRefresh: () async => controller.fetchFromFirebase(),
            color: kPrimaryColor,
            backgroundColor: Colors.white,
            child: ListView.builder(
              itemCount: controller.sensorUnits.length,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
              itemBuilder: (context, index) {
                final unit = controller.sensorUnits[index];
                final isReminderDue = controller.reminders.contains(unit);
                return GestureDetector(
                  onTap: () => Get.to(() => SensorDetailPage(unit: unit, index: index),transition: Transition.rightToLeft),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.apartment, color: kPrimaryColor),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  "${unit.apartmentName} - ${unit.apartmentNumber} (${unit.apartmentUnit})",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 16.sp),
                            ],
                          ),
                          Divider(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total: ${unit.totalSensors}"),
                              Text("Regular: ${unit.regularSensors}"),
                              Text("Cables: ${unit.threeFeetCables}"),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Last Update: ${unit.lastUpdate?.toLocal().toIso8601String().split('T')[0] ?? '-'}",
                            style: TextStyle(
                              color: isReminderDue ? Colors.red : Colors.grey[700],
                              fontWeight: isReminderDue ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
