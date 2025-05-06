import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/controller/register_controller.dart';
import 'package:apartmentinspection/utils/components/custom_auth_button.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
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
                const Text(
                  'Registre / Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => Skeletonizer(
                      enabled: controller.isLoading.value,
                      enableSwitchAnimation: true,
                      child: BounceInRight(
                        duration: Duration(milliseconds: 700),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            buildTextField(
                                controller.nameController, 'nom / Name'),
                            const SizedBox(height: 16),
                            buildTextField(
                                controller.emailController, 'E-Mail / Email'),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Mot de passe / Password',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                suffixIcon: IconButton(
                                  onPressed: controller.togglePasswordVisibility,
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            CustomAuthButton(
                              onPress: controller.register,
                              title: "Register",
                            ),
                            SizedBox(height: 16.sp),
                            Center(
                              child: TextButton(
                                  onPressed: () {
                                    Get.to(() => LoginScreen(),
                                        transition: Transition.leftToRight);
                                  },
                                  child: const Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account? ",
                                        style: TextStyle(color: kWhiteColor),
                                      ),
                                      Text(
                                        "Login here ",
                                        style: TextStyle(color: kSecondaryColor),
                                      ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
