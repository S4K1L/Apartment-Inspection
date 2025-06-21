import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/controller/sensor_controller.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/user/sensor/sensor_details_page.dart';
import 'package:apartmentinspection/views/user/sensor/sensor_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../controller/apartment_controller.dart';
import '../create_apartment/create_apartment.dart';
import '../home/unit_list.dart';

class SensorPage extends StatelessWidget {
  final ApartmentController controller = Get.put(ApartmentController());

  SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 8.sp),
            Image.asset(Const.logo, height: 30.sp),
            SizedBox(width: 10.sp),
            Text("Sensor Management",
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor)),
            const Spacer(),
            Image.asset(Const.bar, height: 26.sp),
            SizedBox(width: 8.sp),
          ],
        ),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Bounce(
            duration: const Duration(milliseconds: 700),
            child: Column(
              children: [
                Expanded(child: Obx(() {
                  if (controller.isLoading.value && controller.apartmentList.isEmpty) {
                    return const Center(
                      child: SpinKitWave(
                        color: kPrimaryColor,
                        size: 50.0,
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh:() async => controller.fetchApartments(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.apartmentList.length,
                      itemBuilder: (context, index) {
                        final apartment = controller.apartmentList[index];
                        return GestureDetector(
                          onTap: (){
                            Get.to(()=> SensorListPage(apartmentName: apartment),transition: Transition.rightToLeft);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(16),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          Const.apart,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    //const SizedBox(width: 16),
                                    // Textual Content
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 16.sp),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      apartment,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      apartment == "Stanley" ?
                                                      "1200" : "1210",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Icon(Icons.bookmark_border, color: Colors.white),
                                            ],
                                          ),
                                          const SizedBox(height: 4),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'See more',
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.7), Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

