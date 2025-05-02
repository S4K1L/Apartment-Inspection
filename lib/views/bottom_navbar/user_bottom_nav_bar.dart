import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/user/home.dart';
import 'package:apartmentinspection/views/profile/profile.dart';
import 'package:apartmentinspection/views/user/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../user/inspection.dart';

class UserCustomBottomBar extends StatefulWidget {
  const UserCustomBottomBar({super.key});

  @override
  State<UserCustomBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<UserCustomBottomBar> {
  int indexColor = 0;
  final List<Widget> screens = [
    HomePage(),
    InspectionPage(),
    ReportPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kBackGroundColor,
        body: screens[indexColor],
        bottomNavigationBar: SizedBox(
          height: 60.sp,
          child: Row(
            children: [
              _buildBottomNavigationItem(Icons.home, 0, "Home"),
              _buildBottomNavigationItem(Icons.map, 1, "Inspection"),
              _buildBottomNavigationItem(Icons.dynamic_feed, 2, "Report"),
              _buildBottomNavigationItem(Icons.person, 3, "Account"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, int index, String title) {
    final bool isSelected = indexColor == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            indexColor = index;
          });
        },
        child: Container(
          height: double.infinity,
          color: isSelected ? kPrimaryColor : kBackGroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? kWhiteColor : kGreyColor,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSelected ? kWhiteColor : kGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
