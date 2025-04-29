import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAuthButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  const CustomAuthButton({
    super.key, required this.title, required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 50.sp,
        width: 200.sp,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3.sp),
                blurRadius: 8.sp,
                offset: Offset(0, 5.sp),
              ),
            ],
            color: kSecondaryColor
        ),
        child:  Center(
          child: Text(title,style: TextStyle(color: kWhiteColor,fontSize: 16.sp,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}