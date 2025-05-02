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
  @override
  Widget build(BuildContext context) {
    nameController.text = controller.userName.value;
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () => _updateProfile(nameController.text.trim()),
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }

  void _updateProfile(String newName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'name': newName,
      });
      controller.fetchLoggedInUser(); // Refresh profile
      Get.back();
    }
  }
}
