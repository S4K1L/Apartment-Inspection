import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFEFF3F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: kWhiteColor,
            )),
        elevation: 0,
        title: const Text(
          "Contact Us",
          style: TextStyle(color: kWhiteColor),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _backgroundGradient(),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    _glassCard(),
                    SizedBox(height: 20.h),
                    _adminContactInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF009688)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _glassCard() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(5, 5),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent, size: 60.sp, color: Colors.white),
          SizedBox(height: 10.h),
          Text(
            "Need Help?",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: const [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black26,
                  offset: Offset(2, 2),
                )
              ],
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "Our Support is Here to Assist",
            style: TextStyle(fontSize: 14.sp, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _adminContactInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Contact Information",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Row(
            children: [
              const Icon(Icons.email, color: Colors.teal),
              SizedBox(width: 10.w),
              Text("apartmentinspection@gmail.com",
                  style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.teal),
              SizedBox(width: 10.w),
              Text("(514) 742-5933", style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.teal),
              SizedBox(width: 10.w),
              Text(
                "Montréal,\n5345 Rang du Bas St-François,\nLaval, Quebec, H7E 4P2",
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactForm() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Send Us a Message",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          TextField(
            decoration: InputDecoration(
              labelText: "Your Name",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            decoration: InputDecoration(
              labelText: "Your Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: "Message",
              alignLabelWithHint: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.send,
                color: kWhiteColor,
              ),
              onPressed: () {
                // TODO: Implement actual send logic
              },
              label: const Text(
                "Send Message",
                style: TextStyle(color: kWhiteColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
