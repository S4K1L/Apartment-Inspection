import 'dart:ui';

import 'package:apartmentinspection/core/my_app.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/utils/widgets/apartment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> apartmentNumbers =
  List.generate(5, (index) => "Apartment #${index + 1}");

  bool _isLoading = false;

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // You can also update apartment list here if needed
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(width: 8.sp),
          Image.asset(Const.logo),
          SizedBox(width: 8.sp),
          Text("PREV1200",
              style:
              TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          const Spacer(),
          Image.asset(Const.bar, height: 26.sp),
          SizedBox(width: 8.sp),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          RefreshIndicator(
            onRefresh: _refreshData,
            displacement: 50,
            color: kPrimaryColor,
            backgroundColor: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: apartmentNumbers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: ApartmentCard(
                    title: apartmentNumbers[index],
                    description: "Apartment description",
                    price: "1360",
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.7), Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
