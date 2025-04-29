import 'package:apartmentinspection/controller/register_controller.dart';
import 'package:apartmentinspection/utils/components/custom_auth_button.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
                const SizedBox(height: 30),
                buildTextField(controller.nameController, 'nom / Name'),
                const SizedBox(height: 16),
                buildTextField(controller.emailController, 'E-Mail / Email'),
                const SizedBox(height: 16),
                buildPasswordField(controller.passwordController, 'Mot de passe / Password'),
                const SizedBox(height: 24),
                CustomAuthButton(
                  onPress: controller.register,
                  title: "Register",
                ),
                SizedBox(height: 16.sp),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Get.to(()=> LoginScreen(),transition: Transition.rightToLeft);
                      },
                      child: Row(
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
          ),
        ),
      ),
    );
  }

  TextField buildPasswordField(TextEditingController controller, String label) {
    return TextField(
                controller: controller,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: label,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
  }
}
