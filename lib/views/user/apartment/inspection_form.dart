import 'package:apartmentinspection/controller/inspection_form_controller.dart';
import 'package:apartmentinspection/utils/components/finished_button.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InspectionFormPage extends StatelessWidget {
  final InspectionFormController controller = Get.put(InspectionFormController());
  final String apartmentNumber;
  final String apartmentUnit;
  final String roomName;
  final String apartmentName;

  InspectionFormPage({
    super.key,
    required this.apartmentNumber,
    required this.apartmentUnit,
    required this.apartmentName,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: kBlackColor),
        ),
        title: Row(
          children: [
            Image.asset(Const.logo, height: 32.h),
            SizedBox(width: 8.w),
            Text(
              "PRE$apartmentNumber",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: kBlackColor),
            ),
          ],
        ),
        actions: [
          Image.asset(Const.bar, height: 26.sp),
          SizedBox(width: 10.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(apartmentNumber, apartmentUnit),
            SizedBox(height: 20.h),
            //_buildSectionTitle(Icons.calendar_today, "Date de l’inspection / Date of Inspection"),
            _buildTextField(),
            SizedBox(height: 20.h),
            _buildSectionTitle(Icons.comment, "Commentaire / Comment"),
            _buildCommentsField(maxLines: 4),
            SizedBox(height: 20.h),
            _buildSectionTitle(Icons.report_problem, "Niveau d'intervention / Intervention Level"),
            _buildRadioOptions(),
            SizedBox(height: 20.h),
            _buildSectionTitle(Icons.photo_camera, "Photos"),
            _buildImagePicker(context),
            SizedBox(height: 30.h),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FinishedButton(
          onPress: () {
            controller.addRoomEntry(roomName,apartmentNumber: apartmentNumber, apartmentUnit: apartmentUnit, apartmentName: apartmentName);
            Get.back();
          },
          title: "Suivante",
        ),
      ),
    );
  }

  Widget _buildHeader(String number, String unite) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: kPrimaryColor,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(Icons.apartment, color: kPrimaryColor, size: 24.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                "Sélection de l’unité: $number - $unite",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: kWhiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: kPrimaryColor),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller.dateController,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: kPrimaryColor, // customize as needed
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          controller.dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        }
      },
      decoration: InputDecoration(
        hintText: "Date de l’inspection",
        filled: true,
        fillColor: kBackGroundColor,
        suffixIcon: Icon(Icons.calendar_today),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }


  Widget _buildCommentsField({int maxLines = 1}) {
    return TextField(
      controller: controller.commentController,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: "Enter your comments here",
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildRadioOptions() {
    final options = ["🟢 Observation", "🟠 Recommended Action", "🔴 Urgent Intervention"];
    return Column(
      children: options
          .map((option) => Obx(() => RadioListTile<String>(
        title: Text(option),
        value: option,
        groupValue: controller.selectedInterventionLevel.value,
        activeColor: kPrimaryColor,
        onChanged: (val) => controller.setInterventionLevel(val!),
      )))
          .toList(),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return Obx(() {
      if (controller.selectedImages.isEmpty) {
        return GestureDetector(
          onTap: controller.pickImages,
          child: DottedBorderContainer(),
        );
      } else {
        return SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.selectedImages.length,
            itemBuilder: (context, index) {
              final image = controller.selectedImages[index];
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 12.w),
                    width: 160.w,
                    height: 160.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close, color: Colors.white, size: 18.sp),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }
    });
  }
}

class DottedBorderContainer extends StatelessWidget {
  const DottedBorderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 36.sp, color: Colors.grey),
            SizedBox(height: 8.h),
            Text(
              "Ajouter des photos",
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
