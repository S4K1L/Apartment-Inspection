import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/user/home/home.dart';
import 'package:apartmentinspection/views/profile/profile.dart';
import 'package:apartmentinspection/views/user/report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../user/battery_history/battery_history_page.dart';
import '../user/sensor/sensor.dart';

class UserCustomBottomBar extends StatefulWidget {
  const UserCustomBottomBar({super.key});

  @override
  State<UserCustomBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<UserCustomBottomBar> {
  int indexColor = 0;
  final List<Widget> screens = [
    HomePage(),
    SensorPage(),
    SensorHistoryPage(),
    ReportPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: screens[indexColor],
      bottomNavigationBar: SizedBox(
        height: 60.sp,
        child: Row(
          children: [
            _buildBottomNavigationItem(CupertinoIcons.battery_full, 1, "Battery"),
            _buildBottomNavigationItem(Icons.history_toggle_off, 2, "History"),
            _buildBottomNavigationItem(Icons.home, 0, "Home"),
            _buildBottomNavigationItem(Icons.dynamic_feed, 3, "Report"),
            _buildBottomNavigationItem(Icons.person, 4, "Account"),
          ],
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          color: isSelected ? kPrimaryColor : kBackGroundColor,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected ? kWhiteColor : kGreyColor,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSelected ? kWhiteColor : kGreyColor,
                ),
                child: Text(title),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
