import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/views/user/apartment/inspection_form.dart';
import 'package:apartmentinspection/views/user/apartment/room_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ApartmentCard extends StatelessWidget {
  final String apartmentName;
  final String number;
  final String unit;
  const ApartmentCard({
    super.key,
    required this.number, required this.unit, required this.apartmentName,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> RoomListPage(apartmentNumber: number,apartmentUnit: unit,apartmentName: apartmentName,),transition: Transition.rightToLeft);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      Const.apart,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //const SizedBox(width: 16),
                // Textual Content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Apartment Location",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  number,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.sp,
                                  ),
                                ),
                                Text(
                                  unit,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.bookmark_border, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 4),

                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.sp),
                  child: Text(
                    apartmentName.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      'See more',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
