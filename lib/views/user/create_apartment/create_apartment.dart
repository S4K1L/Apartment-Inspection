import 'package:apartmentinspection/controller/create_apartment_controller.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CreateSensorPage extends StatelessWidget {
  final CreateApartmentController controller = Get.put(CreateApartmentController());

  CreateSensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Apartment Information"),
                    _buildDropdown("Apartment Name", controller.selectedApartmentName, ['Stanley', 'Drummond']),
                    _buildInput("Apartment Number", controller.apartmentNumber),
                    _buildInput("Apartment Unit", controller.apartmentUnit),
                    SizedBox(height: 16.h),
                    _sectionTitle("Sensor Configuration"),
                    _buildInput("Regular Sensors", controller.regularSensors, isNumber: true),
                    _buildInput("3ft Cables", controller.threeFeetCables, isNumber: true),
                    SizedBox(height: 30.h),
                    Obx(() => controller.isLoading.value
                        ? Center(child: SpinKitWave(color: kPrimaryColor, size: 45.sp))
                        : _buildCreateButton())
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, RxString selectedValue, List<String> options) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: () {
          showCupertinoModalPopup(
            context: Get.context!,
            builder: (_) => Container(
              height: 250.h,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 40.h,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextButton(
                      child: const Text("Done"),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(
                        initialItem: options.indexOf(selectedValue.value),
                      ),
                      onSelectedItemChanged: (index) {
                        selectedValue.value = options[index];
                      },
                      children: options.map((item) => Center(child: Text(item))).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedValue.value.isEmpty ? "Select $label" : selectedValue.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: selectedValue.value.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
            ],
          ),
        )),
      ),
    );
  }


  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () => controller.uploadSensorData(),
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF4A00E0), Color(0xFF214EE5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "CREATE",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C2A69), Color(0xFF132D46)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          SizedBox(width: 10.w),
          Text(
            "Create Apartment",
            style: TextStyle(
              fontSize: 22.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
