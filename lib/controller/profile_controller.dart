import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import '../utils/theme/colors.dart';
import '../views/authentication/login.dart';

class ProfileController extends GetxController {
  var userName = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  final isPasswordVisible = false.obs;
  var user = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoggedInUser();
  }

  // Fetch the logged-in user's data
  Future<void> fetchLoggedInUser() async {
    isLoading.value = true;
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (doc.exists) {
          user.value = UserModel.fromSnapshot(doc);
        } else {
          user.value = UserModel(); // Assign default empty model if no data found
          print("No user data found in Firestore");
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      user.value = UserModel(); // Fallback to default empty model
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (error) {
      if (kDebugMode) {
        print('Error resetting password: $error');
      }
      rethrow;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }


  void updateName(String newName) {
    user.update((user) {
      if (user != null) user.name = newName;
    });
    _updateFirestoreField('name', newName);
  }


  void updatePassword(String newPassword) {
    user.update((user) {
      if (user != null) user.password = newPassword;
    });
    _updateFirestoreField('password', newPassword);
  }

  Future<void> _updateFirestoreField(String field, String value) async {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await _firestore.collection('users').doc(firebaseUser.uid).update({field: value});
    }
  }

  void logout(BuildContext context) async {
    try {
      Get.delete<ProfileController>();
      // Sign out from Firebase
      await _auth.signOut();
      Get.deleteAll(force: true);
      // Navigate to login screen
      Get.offAll(() => LoginScreen(),transition: Transition.fadeIn);
      const snackBar = SnackBar(
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Logged Out!',
          message: 'Anda telah log keluar.',
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  void deleteUserAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid != null) {
        // Delete user data from Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();

        // Delete Firebase Auth account
        await user!.delete();
        Get.offAll(()=> LoginScreen());
        Get.snackbar("Account Deleted", "Your account has been permanently deleted.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete account. Please reauthenticate.");
      // Note: Firebase requires recent login for sensitive operations
    }
  }


  Future<int> getTotalUserReports() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return 0;

    try {
      final reportsSnapshot = await _firestore
          .collection('reports')
          .where('inspectedBy', isEqualTo:  userId)
          .get();

      return reportsSnapshot.size;
    } catch (e) {
      print("Error fetching reports: $e");
      return 0;
    }
  }


  Future<int> getTotalUsers() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      return usersSnapshot.size;
    } catch (e) {
      print("Error counting users: $e");
      return 0;
    }
  }

  Future<void> pickAndUploadUserImage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      Get.dialog(
        const Center(child: SpinKitWave(
          color: kPrimaryColor,
          size: 50.0,
        ),),
        barrierDismissible: false,
      );

      File imageFile = File(pickedFile.path);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(userId)
          .child(fileName);

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'imageUrl': downloadUrl});

      await fetchLoggedInUser();
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      Get.back(); // dismiss dialog
    }
  }


}