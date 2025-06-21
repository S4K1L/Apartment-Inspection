import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/edit_sensor_controller.dart';
import '../../../controller/battery_history_controller.dart';
import '../../../models/battery_history_model.dart';
import '../../../utils/constant/const.dart';
import '../../../utils/theme/colors.dart';

class EditSensorDetailPage extends StatelessWidget {
  final String unit;
  final int index;

  EditSensorDetailPage({super.key, required this.unit, required this.index});

  final EditSensorController controller = Get.put(EditSensorController());

  @override
  Widget build(BuildContext context) {
    final SensorHistoryItem item =
    Get.find<BatteryHistoryController>().historyList[index];

    controller.initialize(item);

    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildAppBar(),
            _buildSensorGrid(),
            const SizedBox(height: 20),
            _buildObservationField(),
            const SizedBox(height: 20),
            _buildSaveButton(),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor)),
          Text(
            "Edit Sensor",
            style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: kWhiteColor),
          ),
          Image.asset(Const.bar, height: 26.sp, color: kWhiteColor),
        ],
      ),
    );
  }

  Widget _buildSensorGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
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
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: controller.sensorStatus.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, i) {
                final isActive = controller.sensorStatus[i];
                return GestureDetector(
                  onTap: () => controller.toggleSensor(i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFE0F7E9)
                          : const Color(0xFFFFEAEA),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                          color: isActive
                              ? kGreenAccentColor
                              : Colors.grey.shade300,
                          width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isActive
                              ? Icons.check_circle_outline
                              : Icons.highlight_off,
                          color:
                          isActive ? Colors.green : Colors.redAccent,
                          size: 18,
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
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildObservationField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
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
            hintText: "Observation notes...",
            border: InputBorder.none,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
          maxLines: 3,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo.shade800,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: controller.saveSensorData,
      icon: const Icon(Icons.send_and_archive, color: kWhiteColor),
      label: Text(
        "Save Changes",
        style: TextStyle(color: kWhiteColor, fontSize: 16.sp),
      ),
    );
  }
}
