import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/controller/login_controller.dart';
import 'package:apartmentinspection/utils/components/custom_auth_button.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ForgotPassword extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1D3D),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1D3D),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kWhiteColor,
              )),
        ),
        title: Text("Back",style: TextStyle(color: kWhiteColor),),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Const.le1200,
                  height: 250,
                ),
                const SizedBox(height: 30),
                Obx(
                  () => Skeletonizer(
                    enabled: controller.isLoading.value,
                    enableSwitchAnimation: true,
                    child: BounceInLeft(
                      duration: const Duration(milliseconds: 700),
                      child: Column(
                        children: [
                          const Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'E-Mail / Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomAuthButton(
                            onPress: () => controller.resetPassword(context),
                            title: "Reset Now",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
