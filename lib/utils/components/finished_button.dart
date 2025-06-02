import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinishedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final IconData icon;

  const FinishedButton({
    super.key,
    required this.title,
    required this.onPress, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,color: kWhiteColor,size: 26.sp),
            SizedBox(width: 8.sp),
            Text(title, style: TextStyle(color: Colors.white,fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }
}
