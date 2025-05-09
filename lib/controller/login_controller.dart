import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/bottom_navbar/admin_bottom_nav_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../views/bottom_navbar/user_bottom_nav_bar.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final forgotEmailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var user = UserModel().obs;

  /// Login function
  Future<void> login(BuildContext context) async {
    if (!_validateInputs()) return;
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (doc.exists) {
          user.value = UserModel.fromSnapshot(doc);
        } else {
          user.value = UserModel();
          print("No user data found in Firestore");
        }
      }
      isLoading.value = false;
      routing(context);
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      String errorMessage = 'An unexpected error occurred. Please try again.';

      // Handle specific Firebase exceptions
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = "Check your email and password";
      }

      // Show error message using GetX Snack bar
      Get.snackbar(
        'Login Failed',
        errorMessage,
        colorText: kWhiteColor,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );

      if (kDebugMode) {
        print('Login error: $errorMessage');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again later.',
        colorText: kWhiteColor,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
      if (kDebugMode) {
        print('Unknown error: $e');
      }
    }
  }

  //routing
  void routing(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    var documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    if (documentSnapshot.exists) {
      String userType = documentSnapshot.get('role');
      if (userType == "user") {
        const snackBar = SnackBar(
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Login Successfully',
            message: 'Welcome to Apartment Inspection',
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        Get.offAll(()=> UserCustomBottomBar());
      }
      else if (userType == "admin") {
        const snackBar = SnackBar(
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Login Successfully',
            message: 'Welcome to Apartment Inspection',
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        Get.offAll(()=> AdminCustomBottomBar());
      }
      else {
        const snackBar = SnackBar(
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Try again',
            message: 'Some error in logging in!',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
    else {
      print('user data not found');
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    isLoading.value = true;
    String email = forgotEmailController.text;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      const snackBar = SnackBar(
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Reset Successful',
          message: 'Check your mail to reset password',
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      if (kDebugMode) {
        print('Error resetting password: $error');
      }
      rethrow;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validateInputs() {
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Error', 'Enter a valid email address',
        colorText: kWhiteColor,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),);
      return false;
    }
    if (passwordController.text.trim().length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
        colorText: kWhiteColor,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),);
      return false;
    }
    return true;
  }
}