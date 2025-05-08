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
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: const Icon(Icons.arrow_back_ios_new,color: kWhiteColor,)),
        title: const Text("Sensor Management",style: TextStyle(color: kWhiteColor),),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 4,
      ),
      body: Obx(() {
        final updatedUnit = controller.sensorUnits[index];
        return BounceInRight(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Apartment Header Card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  color: kPrimaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Row(
                      children: [
                        const Icon(Icons.room_preferences, color: kWhiteColor),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            "Apartment: ${updatedUnit.apartmentName} - ${updatedUnit.apartmentNumber} (${updatedUnit.apartmentUnit})",
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600,color: kWhiteColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
          
                Text("Batteries",
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 10.h),
          
                // Sensor Grid with Checkbox
                Expanded(
                  child: GridView.builder(
                    itemCount: updatedUnit.totalSensors ?? updatedUnit.sensorStatus.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, i) {
                      bool isChecked = updatedUnit.sensorStatus.length > i
                          ? updatedUnit.sensorStatus[i]
                          : false;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.grey.shade100,
                          border: Border.all(
                            color: isChecked ? kPrimaryColor : Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Sensor ${i + 1}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: isChecked,
                              activeColor: kPrimaryColor,
                              onChanged: (val) {
                                controller.updateCheckbox(index, i, val ?? false);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
          
                Text("Observations",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 8.h),
          
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: observationController,
                    decoration: InputDecoration(
                      hintText: "Enter notes or issues...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    ),
                    maxLines: 3,
                    onChanged: (val) => controller.updateObservation(index, val),
                  ),
                ),
                SizedBox(height: 20.h),
          
                GestureDetector(
                  onTap: () => controller.saveSensorData(index),
                  child: Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kPrimaryColor, Colors.teal],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
