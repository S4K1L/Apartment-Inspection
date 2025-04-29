import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminCustomBottomBar extends StatefulWidget {
  const AdminCustomBottomBar({super.key});

  @override
  State<AdminCustomBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<AdminCustomBottomBar> {
  int indexColor = 0;
  final List<Widget> screens = [

  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: screens[indexColor],
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          color: kWhiteColor,
          shape: const CircularNotchedRectangle(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBottomNavigationItem(Icons.map, 1,"Statistics"),
                  _buildBottomNavigationItem(CupertinoIcons.lock_shield, 2, "Search"),
                  _buildBottomNavigationItem(Icons.home, 0,"Dashboard"),
                  _buildBottomNavigationItem(Icons.dynamic_feed, 3, "Analysis "),
                  _buildBottomNavigationItem(Icons.person, 4, "Account"),
                ],
              ),
            ],
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: indexColor == index ? kPrimaryColor : kGreyColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,color: indexColor == index ? kPrimaryColor : kGreyColor,),),
          ),
        ],
      ),
    );
  }

}