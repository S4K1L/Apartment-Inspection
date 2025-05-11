import 'package:apartmentinspection/controller/profile_controller.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatelessWidget {
  final controller = Get.find<ProfileController>();
  final TextEditingController nameController = TextEditingController();

  EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    nameController.text = controller.userName.value;

    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title:
            const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 12,
                  spreadRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: kPrimaryColor.withOpacity(0.1),
                  backgroundImage: (controller.user.value.imageUrl != null &&
                          controller.user.value.imageUrl!.isNotEmpty)
                      ? NetworkImage(controller.user.value.imageUrl!)
                      : null,
                  child: controller.user.value.imageUrl == null ||
                          controller.user.value.imageUrl!.isEmpty
                      ? Icon(Icons.person, size: 50.sp, color: kPrimaryColor)
                      : null,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Update Your Name",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: nameController,
                  style: TextStyle(fontSize: 15.sp),
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          const BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => _updateProfile(nameController.text.trim()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 6,
                      shadowColor: kPrimaryColor.withOpacity(0.4),
                    ),
                    child: Text(
                      "Save Changes",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateProfile(String newName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'name': newName});
      controller.fetchLoggedInUser(); // Refresh profile
      Get.back();
    }
  }
}
