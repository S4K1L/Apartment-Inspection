import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TermsAndPolicyPage extends StatelessWidget {
  const TermsAndPolicyPage({super.key});

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
        title: const Text(
          "Terms & Policy",
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
                    _termsContent(),
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
          Icon(Icons.verified_user, size: 60.sp, color: Colors.white),
          SizedBox(height: 10.h),
          Text(
            "Terms & Conditions",
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
            "Effective from Jan 1, 2024",
            style: TextStyle(fontSize: 14.sp, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _termsContent() {
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
      child: Text(
        '''
Welcome to Apartment Inspection. By using our platform, you agree to the following terms and conditions:

1. **User Responsibilities**
You agree to provide accurate information and use the platform in accordance with all applicable laws and regulations.

2. **Data Privacy**
Your personal data is handled securely and in compliance with international data protection laws. Please review our Privacy Policy for more details.

3. **Service Availability**
We strive to provide uninterrupted access to our services, but we cannot guarantee absolute uptime or performance.

4. **Account Termination**
We reserve the right to suspend or terminate accounts that violate our policies or engage in harmful behavior.

5. **Intellectual Property**
All content, branding, and technology used in the platform are the intellectual property of Apartment Inspection and may not be reproduced without permission.

6. **Dispute Resolution**
Any disputes shall be resolved under the jurisdiction of our operational headquarters, and you agree to binding arbitration where applicable.

7. **Amendments**
These terms may be updated periodically. Continued use of the platform constitutes acceptance of the updated terms.

If you have any questions or concerns regarding these terms, please contact us at apartmentinspection@gmail.com.

Thank you for trusting Apartment Inspection.
            ''',
        style: TextStyle(fontSize: 14.sp, height: 1.5),
      ),
    );
  }
}
