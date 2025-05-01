import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          SizedBox(width: 8.sp),
          Image.asset(
            Const.logo,
          ),
          Spacer(),
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildProfileHeader(),
            SizedBox(height: 30.h),
            _buildStatsRow(),
            SizedBox(height: 30.h),
            _buildProfileInfoCard(),
            SizedBox(height: 30.h),
            _buildActionButtons(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60.r,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 55.r,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: const Icon(Icons.edit, size: 20, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _neumorphicStatCard("Inspected", "24"),
        _neumorphicStatCard("Reports", "8"),
        _neumorphicStatCard("Rating", "4.9"),
      ],
    );
  }

  Widget _neumorphicStatCard(String title, String value) {
    return Container(
      width: 90.w,
      height: 90.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F6),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xFFA7A9AF),
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text(title,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Full Name", "John Doe"),
          Divider(height: 30.h),
          _infoRow("Email", "john.doe@example.com"),
          Divider(height: 30.h),
          _infoRow("Role", "Inspector"),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
        SizedBox(height: 5.h),
        Text(value,
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _actionButton("Edit Profile", Icons.edit, kPrimaryColor),
        SizedBox(height: 16.h),
        _actionButton("Logout", Icons.logout, Colors.red),
      ],
    );
  }

  Widget _actionButton(String label, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20,color: kWhiteColor,),
        label: Text(label,style: TextStyle(color: kWhiteColor),),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          textStyle: TextStyle(fontSize: 16.sp),
        ),
        onPressed: () {},
      ),
    );
  }
}
