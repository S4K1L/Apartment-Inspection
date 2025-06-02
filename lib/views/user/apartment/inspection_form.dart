import 'package:apartmentinspection/controller/inspection_form_controller.dart';
import 'package:apartmentinspection/utils/components/finished_button.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InspectionFormPage extends StatelessWidget {
  final InspectionFormController controller =
      Get.put(InspectionFormController());
  final String apartmentNumber;
  final String apartmentUnit;
  final String roomName;
  final String checkingName;
  final String apartmentName;

  InspectionFormPage({
    super.key,
    required this.apartmentNumber,
    required this.apartmentUnit,
    required this.apartmentName,
    required this.roomName,
    required this.checkingName,
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
        title: Text(
          "Inspection Form",
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: kBlackColor),
        ),
        centerTitle: true,
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
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildSectionTitle(Icons.comment, "Commentaire / Comment"),
            _buildCommentsField(maxLines: 4),
            SizedBox(height: 20.h),
            _buildSectionTitle(Icons.report_problem,
                "Niveau d'intervention / Intervention Level"),
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
            controller.addRoomEntry(
              roomName,
              apartmentNumber: apartmentNumber,
              apartmentUnit: apartmentUnit,
              apartmentName: apartmentName,
              checkingName: checkingName,
            );
            Get.back();
          },
          title: "Submit",
          icon: Icons.drive_folder_upload_outlined,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: kPrimaryColor,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(Icons.roofing, color: kWhiteColor, size: 24.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                checkingName,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kWhiteColor),
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
    final options = [
      "Observation",
      "Recommended Action",
      "Urgent Intervention"
    ];
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
          onTap:() async => controller.pickImageSource(context),
          child: const DottedBorderContainer(),
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
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87,
                        ),
                        padding: const EdgeInsets.all(4),
                        child:
                            Icon(Icons.close, color: Colors.white, size: 18.sp),
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
        border: Border.all(
            color: Colors.grey, style: BorderStyle.solid, width: 1.5),
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
