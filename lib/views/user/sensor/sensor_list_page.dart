import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/views/user/sensor/sensor_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../controller/sensor_controller.dart';
import '../../../utils/constant/const.dart';
import '../../../utils/theme/colors.dart';
import 'package:get/get.dart';


class SensorListPage extends StatelessWidget {
  final SensorController controller = Get.put(SensorController());
  final String apartmentName;
  SensorListPage({super.key, required this.apartmentName});

  @override
  Widget build(BuildContext context) {
    controller.fetchFromFirebase(apartmentName);
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: kWhiteColor,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: const Icon(Icons.arrow_back_ios)),
        title: Text("Unit List",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Image.asset(Const.bar, height: 26.sp),
          const SizedBox(width: 10,)
        ],
      ),
      body: Bounce(
        duration: const Duration(milliseconds: 700),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(4, 4),
                      blurRadius: 12,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: TextField(
                      onChanged: controller.searchFilter,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: "Search here",
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        prefixIcon:
                        const Icon(Icons.search, color: Colors.black54),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                    () {
                      if (controller.isLoading.value) {
                        return const Expanded(
                          child: Center(child: SpinKitWave(
                            color: kPrimaryColor,
                            size: 50.0,
                          ),),
                        );
                      }

                  return RefreshIndicator(
                    onRefresh: () async => controller.fetchFromFirebase(apartmentName),
                    color: kPrimaryColor,
                    backgroundColor: Colors.white,
                    child: ListView.builder(
                      itemCount: controller.sensorUnits.length,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 16.h),
                      itemBuilder: (context, index) {
                        final unit = controller.sensorUnits[index];
                        controller.reminders.contains(unit);
                        return GestureDetector(
                          onTap: () => Get.to(
                                  () => SensorDetailPage(unit: unit, index: index),
                              transition: Transition.rightToLeft,),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D2D2D),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 6),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.apartment,
                                          color: kWhiteColor,
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Text(
                                            "${unit.apartmentName} - ${unit.apartmentNumber} (${unit.apartmentUnit})",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                                color: kWhiteColor),
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward_ios,
                                            size: 16.sp, color: kWhiteColor),
                                      ],
                                    ),
                                    Divider(height: 20.h),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total: ${unit.totalSensors}",
                                          style: const TextStyle(
                                              color: kWhiteColor),
                                        ),
                                        Text(
                                          "Regular: ${unit.regularSensors}",
                                          style: const TextStyle(
                                              color: kWhiteColor),
                                        ),
                                        Text(
                                          "Cables: ${unit.threeFeetCables}",
                                          style: const TextStyle(
                                              color: kWhiteColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}