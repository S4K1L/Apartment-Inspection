import 'package:apartmentinspection/utils/components/finished_button.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/views/user/apartment/signature_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/inspection_form_controller.dart';
import 'inspection_form.dart';
import 'inspection_list.dart';

class RoomListPage extends StatefulWidget {
  final String apartmentNumber;
  final String apartmentUnit;
  final String apartmentName;

  const RoomListPage(
      {super.key,
      required this.apartmentNumber,
      required this.apartmentUnit,
      required this.apartmentName});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  int selectedIndex = -1;

  final List<Map<String, String>> rooms = [
    {"fr": "SALLE DE BAINS 1", "en": "BATHROOM 1"},
    {"fr": " SALLE DE BAINS 2", "en": "BATHROOM 2"},
    {"fr": "TOILETTE 1", "en": "TOILETTE 1"},
    {"fr": "TOILETTE 2", "en": "TOILETTE 2"},
    {"fr": "CUISINE", "en": "CUISINE"},
    {"fr": "Salle mécanique / lavage", "en": "Mechanical room/washing"},
    {"fr": "Diversas", "en": "Divers"},
  ];

  @override
  Widget build(BuildContext context) {
    final InspectionFormController controller = Get.put(InspectionFormController());
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
          Text("INSPECCIÓN",
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
              _buildTextField(controller),
              SizedBox(height: 24.h),
              ...List.generate(
                rooms.length,
                (index) => _buildRoomTile(
                  onPress: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    // Get.to(
                    //     () => InspectionFormPage(
                    //           apartmentNumber: widget.apartmentNumber,
                    //           apartmentUnit: widget.apartmentUnit,
                    //           roomName: rooms[index]["en"].toString(),
                    //           apartmentName: widget.apartmentName,
                    //         ),
                    //     transition: Transition.rightToLeft);
                    Get.to(
                        () => InspectionListPage(
                              roomName: rooms[index]["en"].toString(),
                            ),
                        transition: Transition.rightToLeft);
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
            Get.to(
                () => SignaturePage(
                      apartmentNumber: widget.apartmentNumber,
                      apartmentUnit: widget.apartmentUnit,
                      apartmentName: widget.apartmentName,
                    ),
                transition: Transition.rightToLeft);
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

  Widget _buildTextField(InspectionFormController controller) {
    return TextField(
      controller: controller.dateController,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: kPrimaryColor, // customize as needed
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          controller.dateController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        }
      },
      decoration: InputDecoration(
        hintText: "Date de l’inspection",
        filled: true,
        fillColor: kBackGroundColor,
        suffixIcon: const Icon(Icons.calendar_today),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
