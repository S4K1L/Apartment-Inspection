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

  InspectionFormPage(
      {super.key, required this.apartmentNumber, required this.apartmentUnit, required this.apartmentName, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: kBlackColor),
          ),
          Image.asset(Const.logo),
          SizedBox(width: 8.sp),
          Text("PRE$apartmentNumber",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          const Spacer(),
          Image.asset(Const.bar, height: 26.sp),
          SizedBox(width: 8.sp),
        ],
      ),
      body: Expanded(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(apartmentNumber,apartmentUnit),
              SizedBox(height: 20.h),
              // _buildTextField("Numéro d\'unité/ ", "Unit number"),
              // SizedBox(height: 20.h),
              _buildTextField('Date de l’inspection. ', "Date of inspection"),
              SizedBox(height: 20.h),
              _buildCommentsField('Commentaire/ ', "Comment", maxLines: 4),
              SizedBox(height: 20.h),
              Obx(() {
                if (controller.selectedImages.isEmpty) {
                  return GestureDetector(
                    onTap:()=> controller.pickImages,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: Icon(Icons.add_a_photo, size: 40.sp, color: Colors.grey),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.selectedImages.length,
                      itemBuilder: (context, index) {
                        final image = controller.selectedImages[index];
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10.w),
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => controller.removeImage(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black54,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              }),

              SizedBox(height: 20.h),
              Divider(
                color: kBlackColor,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FinishedButton(
          onPress: () {
            // Navigate to next page
          },
          title: "Suivante",
        ),
      ),
    );
  }

  Widget _buildHeader(String number, String unite) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Selection de Unité ",
            style: TextStyle(fontSize: 20.sp, color: Colors.grey.shade600),
          ),
          TextSpan(
            text: "$number-$unite",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTextField(String label, String label2, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        label: Row(
          children: [
            Text(
              label,
              style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w500),
            ),
            Text(label2),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        filled: true,
        fillColor: kBackGroundColor,
      ),
    );
  }
  Widget _buildCommentsField(String label, String label2, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        label: Row(
          children: [
            Text(
              label,
              style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w500),
            ),
            Text(label2),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        filled: true,
        fillColor: kBackGroundColor,
        border: OutlineInputBorder()
      ),
    );
  }
}
