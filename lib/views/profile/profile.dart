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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());
  int reportCount = 0;
  int users = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    reportCount = await controller.getTotalUserReports();
    users = await controller.getTotalUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 16.h), // space below header's Stack
            _buildStats(reportCount, users),
            SizedBox(height: 20.h),
            _buildShortBio(context),
            SizedBox(height: 30.h),
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
              colors: [Color(0xFF0C2A69), Color(0xFF132D46)],
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
          left: 30.w,
          right: 30.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Obx(() => CircleAvatar(
                        radius: 50.sp,
                        backgroundColor: kWhiteColor,
                        backgroundImage: (controller.user.value.imageUrl !=
                                    null &&
                                controller.user.value.imageUrl!.isNotEmpty)
                            ? NetworkImage(controller.user.value.imageUrl!)
                            : const AssetImage(Const.profile) as ImageProvider,
                      )),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: () async {
                        await controller.pickAndUploadUserImage();
                        await controller.fetchLoggedInUser();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kWhiteColor, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.w),
              Obx(() => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.user.value.name ?? "User Name",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          controller.user.value.email ?? "user@email.com",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () => Get.to(() => EditProfilePage(),
                              transition: Transition.rightToLeft),
                          child: Container(
                            height: 40.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(32),
                                topLeft: Radius.circular(32),
                              ),
                              color: kPrimaryColor,
                              border: Border.all(color: kWhiteColor, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 6.r,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats(int reportCount, int users) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statItem("Reports", "$reportCount"),
          _statItem("Users", "$users"),
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
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Container(
          height: 50.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            color: kPrimaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.4),
                blurRadius: 8.r,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Logout",
              style: TextStyle(color: kWhiteColor, fontSize: 16.sp),
            ),
          ),
        ),
      ),
    );
  }

  Widget _accountDetails() {
    return Column(
      children: [
        _profileTile(() {
          Get.to(() => const AboutUsPage(), transition: Transition.rightToLeft);
        }, Icons.info_outline, "About Us"),
        _profileTile(() {
          Get.to(() => const ContactUsPage(),
              transition: Transition.rightToLeft);
        }, Icons.support_agent, "Contact Us"),
        _profileTile(() {
          Get.to(() => const TermsAndPolicyPage(),
              transition: Transition.rightToLeft);
        }, Icons.policy_outlined, "Terms & Policy"),
      ],
    );
  }

  Widget _accountSecurity(BuildContext context) {
    return Column(
      children: [
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
          Icons.delete_outline,
          "Delete Account",
          iconColor: Colors.red,
        ),
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
      String middleText, VoidCallback onConfirm) {
    Get.defaultDialog(
      title: title,
      middleText: middleText,
      textCancel: "NO",
      textConfirm: "YES",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: onConfirm,
    );
  }
}
