import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/theme/colors.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFEFF3F6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: kWhiteColor,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _backgroundGradient(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  _glassCard(),
                  SizedBox(height: 20.h),
                  _aboutText(),
                ],
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
          Icon(Icons.apartment, size: 60.sp, color: Colors.white),
          SizedBox(height: 10.h),
          Text(
            "Apartment Inspection",
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
            "Smart & Secure Living",
            style: TextStyle(fontSize: 14.sp, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _aboutText() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
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
          child: Text(
            '''
Apartment Inspection is a modern, AI-powered platform dedicated to providing safe, smart, and transparent housing evaluations. 

We aim to revolutionize the rental and real estate industry by introducing intelligent inspection tools, real-time reporting, and data-driven safety insights for both property owners and tenants.

Our mission is to empower communities with trust and technology—by making every inspection seamless, professional, and credible.

With our app, you can:
- Schedule inspections
- Get real-time reports
- Communicate with property managers
- Access safety guidelines

Join thousands of users who rely on us for a safer living experience!
            ''',
            style: TextStyle(fontSize: 14.sp, height: 1.5),
          ),
        ),
      ),
    );
  }
}
