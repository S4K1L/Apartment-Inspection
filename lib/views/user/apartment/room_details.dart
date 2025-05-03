import 'package:apartmentinspection/utils/components/finished_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/constant/const.dart';
import '../../../utils/theme/colors.dart';

class RoomDetails extends StatelessWidget {
  final String number;
  final String unit;
  final String roomName;
  final String apartmentName;
  const RoomDetails({super.key, required this.number, required this.unit, required this.roomName, required this.apartmentName});

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
          Text("PRE$number",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          const Spacer(),
          Image.asset(Const.bar, height: 26.sp),
          SizedBox(width: 8.sp),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32)
                ),
                child: Image.asset(Const.apart,fit: BoxFit.cover,),
              ),
              SizedBox(height: 20.sp),
              _buildTextField('Commentaire/ ', "Comment", maxLines: 8),
        
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
          title: "Terminé",
        ),
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
        border: OutlineInputBorder()
      ),
    );
  }

}
