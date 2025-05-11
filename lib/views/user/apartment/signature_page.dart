import 'package:apartmentinspection/controller/inspection_form_controller.dart';
import 'package:apartmentinspection/utils/components/finished_button.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import '../../../utils/constant/const.dart';

class SignaturePage extends StatefulWidget {
  final String apartmentNumber;
  final String apartmentUnit;
  final String apartmentName;

  const SignaturePage({
    super.key,
    required this.apartmentNumber,
    required this.apartmentUnit,
    required this.apartmentName,
  });

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final InspectionFormController controller =
      Get.put(InspectionFormController());

  final SignatureController technicianSigController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.white,
    exportBackgroundColor: Colors.black,
  );

  final SignatureController clientSigController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    technicianSigController.dispose();
    clientSigController.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    await controller.uploadSignaturesAndSubmit(
      technicianController: technicianSigController,
      clientController: clientSigController,
      apartmentName: widget.apartmentName,
      apartmentNumber: widget.apartmentNumber,
      apartmentUnit: widget.apartmentUnit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
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
          Text("Signature",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          const Spacer(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Technician Signature"),
                    const SizedBox(height: 8),
                    Container(
                      height: 180.sp,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Signature(
                        controller: technicianSigController,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: technicianSigController.clear,
                          child: const Text("Clear",
                              style: TextStyle(color: kBlackColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("Client Signature"),
                    const SizedBox(height: 8),
                    Container(
                      height: 180.sp,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Signature(
                        controller: clientSigController,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: clientSigController.clear,
                          child: const Text("Clear"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Date de validation de la visite",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: kBlackColor),
                    ),
                    Text(
                      "Date of validation of the visit",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w300,
                          color: kGreyColor),
                    ),
                  ],
                );
        }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FinishedButton(
          onPress: handleSubmit,
          title: "FAITE",
        ),
      ),
    );
  }
}
