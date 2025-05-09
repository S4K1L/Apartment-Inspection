import 'package:apartmentinspection/utils/components/finished_button.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/user/apartment/signature_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'inspection_form.dart';
import 'room_details.dart';

class RoomListPage extends StatefulWidget {
  final String apartmentNumber;
  final String apartmentUnit;
  final String apartmentName;

  const RoomListPage({super.key, required this.apartmentNumber, required this.apartmentUnit, required this.apartmentName});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  int selectedIndex = -1;

  final List<Map<String, String>> rooms = [
    {"fr": "Chambre à coucher", "en": "Bed Room"},
    {"fr": "Salles de bain", "en": "Bathrooms"},
    {"fr": "Saile de lavage", "en": "Laundry Room"},
    {"fr": "Cuioine", "en": "Kitchen"},
    {"fr": "Salle mécanique", "en": "Mechanical Room"},
    {"fr": "Saile mécanique / Divers", "en": "Miscellaneous"},
    {"fr": "Sailerourovad", "en": "Ovenvation"},
    {"fr": "Cuich ge", "en": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: kBlackColor),
          ),
          Image.asset(Const.logo),
          SizedBox(width: 8.sp),
          Text("PRE${widget.apartmentNumber}",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          const Spacer(),
          Image.asset(Const.bar, height: 26.sp),
          SizedBox(width: 8.sp),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(widget.apartmentNumber, widget.apartmentUnit),
              SizedBox(height: 24.h),
              ...List.generate(
                rooms.length,
                    (index) => _buildRoomTile(
                  onPress: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    Get.to(()=> InspectionFormPage(apartmentNumber: widget.apartmentNumber, apartmentUnit: widget.apartmentUnit,roomName: rooms[index]["en"].toString(),apartmentName: widget.apartmentName,),transition: Transition.rightToLeft);
                  },
                  fr: rooms[index]["fr"]!,
                  en: rooms[index]["en"]!,
                  isSelected: selectedIndex == index,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FinishedButton(
          onPress: () {
            Get.to(() => SignaturePage(
              apartmentNumber: widget.apartmentNumber,
              apartmentUnit: widget.apartmentUnit,
              apartmentName: widget.apartmentName,
            ),transition: Transition.rightToLeft);
          },
          title: "Suivante",
        ),
      ),
    );
  }

  Widget _buildHeader(String number, String unite) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Emplacement Unité ",
            style: TextStyle(fontSize: 20.sp, color: Colors.grey.shade600),
          ),
          TextSpan(
            text: "$number-$unite",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomTile({
    required VoidCallback onPress,
    required String fr,
    required String en,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fr,
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 4.h),
                Text(en,
                    style: TextStyle(
                        fontSize: 15.sp, color: Colors.grey.shade600)),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: kBlackColor),
          ],
        ),
      ),
    );
  }
}
