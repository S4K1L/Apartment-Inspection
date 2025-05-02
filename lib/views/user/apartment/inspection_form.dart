import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InspectionFormPage extends StatelessWidget {
  final String location;
  const InspectionFormPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            Get.back();
          }, icon: const Icon(Icons.arrow_back_ios,color: kBlackColor,)),
          Image.asset(Const.logo),
          SizedBox(width: 8.sp),
          Text("PRE$location",
              style:
              TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          const Spacer()
        ],
      ),
      body: Expanded(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selection de Unité $location',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              _buildTextField("Numéro d\'unité/ ","Unit number"),
        
              SizedBox(height: 20.h),
              _buildTextField('Date de l’inspection. ',"Date of inspection"),
        
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Photo capture logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text("Prendre une photo",style: TextStyle(fontSize: 16.sp),),
                ),
              ),
        
              SizedBox(height: 20.h),
              _buildTextField('Commentaire/ ',"Comment",maxLines: 2),
        
              const Spacer(),
              Divider(color: kBlackColor,),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Submit logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
                  ),
                  child: const Text("Terminé", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,String label2,{int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        label: Row(
          children: [
            Text(label,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.w500),),
            Text(label2),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        filled: true,
        fillColor: kBackGroundColor,
      ),
    );
  }
}
