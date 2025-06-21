import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../controller/battery_history_controller.dart';
import 'sensor_history_details_page.dart';

class SensorHistoryList extends StatelessWidget {
  final String apartmentName;
  final BatteryHistoryController controller = Get.put(BatteryHistoryController());

  SensorHistoryList({super.key, required this.apartmentName});

  @override
  Widget build(BuildContext context) {
    controller.fetchApartments(apartmentName);

    return Scaffold(
      backgroundColor: kBackGroundColor,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
                    ),
                    Text(
                      "Sensor History",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: kWhiteColor,
                      ),
                    ),
                    Image.asset(Const.bar, height: 26.sp, color: kWhiteColor),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      onChanged: controller.searchFilter,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: "Search here",
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        prefixIcon: const Icon(Icons.search, color: Colors.black54),
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
              ],
            ),
          ),
          Obx(() {
            final apartments = controller.filteredApartments;
            if (controller.isLoading.value) {
              return const Expanded(
                child: Center(
                  child: SpinKitWave(
                    color: kPrimaryColor,
                    size: 50.0,
                  ),
                ),
              );
            }

            return Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchApartments(apartmentName),
                color: kPrimaryColor,
                child: BounceInRight(
                  duration: const Duration(milliseconds: 700),
                  child: Skeletonizer(
                    enabled: controller.isLoading.value,
                    enableSwitchAnimation: true,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: apartments.length,
                      itemBuilder: (context, index) {
                        final apartment = apartments[index];
                        return GestureDetector(
                          onTap: () async {
                            await controller.fetchSensorHistory(apartment.apartmentUnit);
                            Get.to(
                                  () => SensorHistoryDetailPage(apartmentUnit: apartment.apartmentUnit),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.indigo.shade700, Colors.indigo.shade800],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 6),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(Const.battery, fit: BoxFit.contain),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${apartment.apartmentName} ${apartment.apartmentNumber} (${apartment.apartmentUnit})",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Tap to view sensor history",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
