import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/home.dart';
import 'package:flutter/material.dart';

class UserCustomBottomBar extends StatefulWidget {
  const UserCustomBottomBar({super.key});

  @override
  State<UserCustomBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<UserCustomBottomBar> {
  int indexColor = 0;
  final List<Widget> screens = [
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),

  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: screens[indexColor],
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          color: kWhiteColor,
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBottomNavigationItem(Icons.home, 0, "Home"),
                _buildBottomNavigationItem(Icons.map, 1, "Inspection"),
                _buildBottomNavigationItem(Icons.dynamic_feed, 2, "Report"),
                _buildBottomNavigationItem(Icons.person, 3, "Account"),
              ],
            ),
          ),
        ),

      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          indexColor = index;
        });
      },
      child: Container(
        height: 60, // Fixed height for tab
        width: MediaQuery.of(context).size.width / 4.5,
        color: indexColor == index ? kPrimaryColor : kWhiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: indexColor == index ? kWhiteColor : kGreyColor,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: indexColor == index ? kWhiteColor : kGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

}