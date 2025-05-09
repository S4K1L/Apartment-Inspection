import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apartmentinspection/models/sensor_model.dart';
import 'package:apartmentinspection/controller/sensor_controller.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';

class SensorDetailPage extends StatelessWidget {
  final SensorUnit unit;
  final int index;

  SensorDetailPage({required this.unit, required this.index, super.key});

  final SensorController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final TextEditingController observationController =
    TextEditingController(text: unit.observations ?? '');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Obx(() {
              final updatedUnit = controller.sensorUnits.length > index
                  ? controller.sensorUnits[index]
                  : unit;

              return BounceInRight(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildApartmentHeader(updatedUnit),
                      SizedBox(height: 20.h),
                      Text(
                        "Battery Status",
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: updatedUnit.totalSensors ?? updatedUnit.sensorStatus.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, i) {
                          bool isChecked = updatedUnit.sensorStatus.length > i
                              ? updatedUnit.sensorStatus[i]
                              : false;
                          return _buildSensorTile(i, isChecked);
                        },
                      ),
                      SizedBox(height: 24.h),
                      Text("Observations", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      _buildObservationField(observationController),
                      SizedBox(height: 24.h),
                      _buildSaveButton(index),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
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
      padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 20.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new, color: kWhiteColor),
          ),
          Text(
            "Sensor Management",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: kWhiteColor),
          ),
        ],
      ),
    );
  }

  Widget _buildApartmentHeader(SensorUnit unit) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      elevation: 4,
      color: kPrimaryColor,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Row(
          children: [
            Icon(Icons.apartment, color: Colors.white, size: 26.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                "${unit.apartmentName} - ${unit.apartmentNumber} (${unit.apartmentUnit})",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTile(int index, bool isChecked) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: isChecked ? kPrimaryColor : Colors.grey.shade300, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(Icons.sensors, color: isChecked ? kPrimaryColor : Colors.grey),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "Sensor ${index + 1}",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Checkbox(
            value: isChecked,
            activeColor: kPrimaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
            onChanged: (val) {
              controller.updateCheckbox(this.index, index, val ?? false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildObservationField(TextEditingController controllerText) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller.observationController,
        decoration: InputDecoration(
          hintText: "Enter notes or issues...",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        ),
        maxLines: 3,
      ),
    );
  }

  Widget _buildSaveButton(int index) {
    return GestureDetector(
      onTap: () {
        controller.saveSensorData(index);
        Get.back();
      },
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4169E1), Color(0xFF27408B)],
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save_alt_rounded, color: Colors.white),
            SizedBox(width: 10.w),
            Text(
              "Save Changes",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
