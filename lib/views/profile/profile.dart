import 'package:apartmentinspection/controller/profile_controller.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/comapny_details/about_us.dart';
import 'package:apartmentinspection/views/comapny_details/contact_admin.dart';
import 'package:apartmentinspection/views/comapny_details/terms_and_policy.dart';
import 'package:apartmentinspection/views/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildStats(),
            SizedBox(height: 20.h),
            _buildShortBio(context),
            SizedBox(height: 20.h),
            _buildButtons(context),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 260.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00BCD4), Color(0xFF009688)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Positioned(
          top: 100.h,
          left: 40.h,
          right: 0,
          child: Row(
            children: [
              CircleAvatar(
                radius: 60.sp,
                backgroundColor: kWhiteColor,
                backgroundImage: controller.user.value.imageUrl!.isNotEmpty
                    ? NetworkImage(controller.user.value.imageUrl.toString())
                    : const AssetImage(
                        Const.profile,
                      ),
              ),
              SizedBox(width: 10.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.user.value.name.toString(),
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    controller.user.value.email.toString(),
                    style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => EditProfilePage(),
                          transition: Transition.rightToLeft);
                    },
                    child: Container(
                        height: 50.sp,
                        width: 120.sp,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                bottomRight: Radius.circular(32)),
                            color: kPrimaryColor),
                        child: Center(
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statItem("Report", "120"),
          _statItem("Inspection", "06"),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
      ],
    );
  }

  Widget _buildShortBio(BuildContext context) {
    return Column(
      children: [
        Text("Settings",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        _accountDetails(),
        _accountSecurity(context),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.logout(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.sp),
        child: Container(
            height: 50.sp,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32)),
                color: kPrimaryColor),
            child: Center(
              child: Text(
                "Logout",
                style: TextStyle(color: kWhiteColor, fontSize: 16.sp),
              ),
            )),
      ),
    );
  }

  Widget _accountDetails() {
    return Column(
      children: [
        _profileTile(() {
          Get.to(() => AboutUsPage(), transition: Transition.rightToLeft);
        }, Icons.abc_outlined, "About us", iconColor: kBlackColor),
        _profileTile(() {
          Get.to(() => ContactUsPage(), transition: Transition.rightToLeft);
        }, Icons.admin_panel_settings_outlined, "Contact Us"),
        _profileTile(() {
          Get.to(() => TermsAndPolicyPage(),
              transition: Transition.rightToLeft);
        }, Icons.policy, "Terms & Policy", iconColor: Colors.black),
      ],
    );
  }

  Widget _accountSecurity(BuildContext context) {
    return Column(
      children: [
        _profileTile(
          () => showDeleteConfirmationDialog(
            context,
            "Clear Cache",
            "Are you sure you want to Clear Cache? This action is irreversible.",
            () {},
          ),
          Icons.auto_delete,
          "Clear Cache",
        ),
        _profileTile(
          () => showDeleteConfirmationDialog(
            context,
            "Clear History",
            "Are you sure you want to Clear History? This action is irreversible.",
            () {},
          ),
          Icons.history,
          "Clear History",
        ),
        _profileTile(
            () => showDeleteConfirmationDialog(
                  context,
                  "Delete Account",
                  "Are you sure you want to delete your account? This action is irreversible.",
                  () {
                    Get.back();
                    controller.deleteUserAccount();
                  },
                ),
            Icons.delete_outline_rounded,
            "Delete Account",
            iconColor: Colors.red),
      ],
    );
  }

  Widget _profileTile(VoidCallback onPress, IconData icon, String title,
      {Color iconColor = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(fontSize: 15.sp)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onPress,
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, String title,
      String middleText, VoidCallback onPress) {
    Get.defaultDialog(
      title: title,
      middleText: middleText,
      textCancel: "NO",
      textConfirm: "YES",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: onPress,
    );
  }
}
