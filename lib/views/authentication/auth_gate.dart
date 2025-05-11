import 'package:apartmentinspection/views/bottom_navbar/admin_bottom_nav_bar.dart';
import 'package:apartmentinspection/views/bottom_navbar/user_bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _route();
            return const SizedBox.shrink();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }

  void _route() async {
    User? user = FirebaseAuth.instance.currentUser;
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    if (documentSnapshot.exists) {
      String userType = documentSnapshot.get('role');
      if (userType == "user") {
        Get.offAll(() => const UserCustomBottomBar());
      } else if (userType == "admin") {
        Get.offAll(() => const AdminCustomBottomBar());
      } else {
        print('user data not found');
      }
    } else {
      print('user data not found');
    }
  }
}
