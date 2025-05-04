import 'package:apartmentinspection/controller/sensor_controller.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {},
        icon: const Icon(Icons.cloud_upload,color: kWhiteColor,),
        label: const Text("Upload",style: TextStyle(color: kWhiteColor),),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async => controller.fetchFromFirebase(),
          color: kPrimaryColor,
          backgroundColor: Colors.white,
          child: ListView.builder(
            itemCount: controller.sensorUnits.length,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
            itemBuilder: (context, index) {
              final unit = controller.sensorUnits[index];
              final isReminderDue = controller.reminders.contains(unit);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                    colors: isReminderDue
                        ? [Colors.orange.shade100, Colors.orange.shade200]
                        : [Colors.white, Colors.grey.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🔧 ${unit.apartmentName}: ${unit.apartmentNumber}-${unit.apartmentUnit}",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Total: ${unit.totalSensors} | Regular: ${unit.regularSensors} | Cables: ${unit.threeFeetCables}",
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                      ),
                      Text(
                        "Battery Change: ${unit.batteryChangeDate!.toLocal().toIso8601String().split('T')[0]}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isReminderDue ? Colors.red : Colors.grey[800],
                          fontWeight: isReminderDue ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.white.withOpacity(0.8),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 14,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 3,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemBuilder: (context, i) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("S${i + 1}", style: TextStyle(fontSize: 12.sp)),
                                Checkbox(
                                  value: unit.sensorStatus[i],
                                  activeColor: kPrimaryColor,
                                  onChanged: (val) =>
                                      controller.updateCheckbox(index, i, val ?? false),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Observations",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        maxLines: 2,
                        controller: TextEditingController(text: unit.observations),
                        onChanged: (val) => controller.updateObservation(index, val),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
