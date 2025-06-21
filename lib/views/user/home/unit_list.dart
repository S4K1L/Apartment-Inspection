import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/controller/apartment_controller.dart';
import 'package:apartmentinspection/utils/components/custom_search_bar.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:apartmentinspection/utils/widgets/apartment_card.dart';
import 'package:apartmentinspection/views/user/create_apartment/create_apartment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class UnitListPage extends StatefulWidget {
  final String apartmentName;
  const UnitListPage({super.key, required this.apartmentName});

  @override
  State<UnitListPage> createState() => _UnitListPageState();
}

class _UnitListPageState extends State<UnitListPage> {
  final ApartmentController controller = Get.put(ApartmentController());

  @override
  void dispose() {
    controller.unitList.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Fetch only when list is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.unitList.isEmpty) {
        controller.fetchAllUnits(widget.apartmentName);
      }
    });
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: const Icon(Icons.arrow_back_ios_new,color: kBlackColor,)),
        title: Text("Unit List",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Image.asset(Const.bar, height: 26.sp),
          const SizedBox(width: 10,)
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          BounceInRight(
            duration: const Duration(milliseconds: 700),
            child: Column(
              children: [
                CustomSearchBar(controller: controller),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: SpinKitWave(
                          color: kPrimaryColor,
                          size: 50.0,
                        ),
                      );
                    } else if (controller.unitList.isEmpty) {
                      return const Center(child: Text("No units found."));
                    }
                    return RefreshIndicator(
                      onRefresh: () async => controller.fetchAllUnits(widget.apartmentName),
                      color: kPrimaryColor,
                      backgroundColor: Colors.white,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.filteredList.length,
                        itemBuilder: (context, index) {
                          final apartment = controller.filteredList[index];
                          return ApartmentCard(
                            number: apartment.apartmentNumber,
                            unit: apartment.apartmentUnit,
                            apartmentName: apartment.apartmentName,
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: kPrimaryColor),
        child: IconButton(
          onPressed: () {
            Get.to(() => CreateSensorPage(),
                transition: Transition.rightToLeft);
          },
          icon: const Icon(
            Icons.add,
            color: kWhiteColor,
            size: 32,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
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
