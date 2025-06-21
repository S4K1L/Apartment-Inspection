import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/email_pdf_controller.dart';
import '../../../utils/theme/colors.dart';

class SendPdfPage extends StatelessWidget {
  final String pdfUrl;

  SendPdfPage({super.key, required this.pdfUrl});

  final EmailPdfController controller = Get.put(EmailPdfController());
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: const Text("Send PDF Report"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Obx(() => Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 8),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email_outlined,
                    color: kPrimaryColor, size: 48.sp),
                SizedBox(height: 16.h),
                Text(
                  "Enter Client Email",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "example@mail.com",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    controller.recipientEmail.value =
                        emailController.text.trim();
                    controller.sendPdfLinkByEmail(
                      subject: "Your Apartment Inspection PDF",
                      messageBody:
                      "Attached is the link to your inspection report.",
                      pdfUrl: pdfUrl,
                    );
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: controller.isLoading.value
                      ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                      : const Text("Send Email"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: 30.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    elevation: 8,
                    shadowColor: kPrimaryColor.withOpacity(0.4),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
