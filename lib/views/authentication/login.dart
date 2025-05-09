import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/controller/login_controller.dart';
import 'package:apartmentinspection/utils/components/custom_auth_button.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/authentication/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'forgot_password.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1D3D),
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
                            'Connexion / Log In',
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
                          const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Mot de passe / Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            suffixIcon: IconButton(
                              onPressed: controller.togglePasswordVisibility,
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please enter the password";
                            } else if (val.length <= 6) {
                              return "Password should be 6 characters or more";
                            }
                            return null;
                          },
                        ),

                          Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => ForgotPassword(),
                                      transition: Transition.rightToLeft);
                                },
                                child:const Text(
                                  "Forgot Password ? ",
                                  style: TextStyle(color: kWhiteColor),
                                ),
                              ),),
                          const SizedBox(height: 16),
                          CustomAuthButton(
                            onPress: () => controller.login(context),
                            title: "Log In",
                          ),
                          SizedBox(height: 16.sp),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Get.to(() => RegisterScreen(),
                                    transition: Transition.rightToLeft);
                              },
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(color: kWhiteColor),
                                  ),
                                  Text(
                                    "Register here ",
                                    style: TextStyle(color: kSecondaryColor),
                                  ),
                                ],
                              ),
                            ),
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

