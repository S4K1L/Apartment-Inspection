import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/controller/report_controller.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

class ReportPage extends StatelessWidget {
  final ReportController controller = Get.put(ReportController());

  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.reports.isEmpty) {
        controller.fetchReports();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Bounce(
        duration: const Duration(milliseconds: 700),
        child: Column(
          children: [
            // Header with curved background
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28.r),
                  bottomRight: Radius.circular(28.r),
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0C2A69), Color(0xFF132D46)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reports",
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: kWhiteColor),
                  ),
                  SizedBox(height: 12.h),
                  // Search bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search for Report",
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                      onChanged: controller
                          .searchReports, // Add this method in controller if needed
                    ),
                  ),
                ],
              ),
            ),

            // Body list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: SpinKitWave(
                      color: kPrimaryColor,
                      size: 50.0,
                    ),
                  );
                }

                if (controller.reports.isEmpty && controller.isLoading.value) {
                  return const Center(child: Text("No reports found"));
                }

                return RefreshIndicator(
                  onRefresh: () async => controller.fetchReports(),
                  color: kPrimaryColor,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    itemCount: controller.reports.length,
                    itemBuilder: (context, index) {
                      final report = controller.reports[index];
                      return Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.indigo.shade700,
                                Colors.indigo.shade800
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 6),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Slidable(
                            key: ValueKey(report['id']),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) {
                                    Get.defaultDialog(
                                      title: "Confirm Deletion",
                                      middleText:
                                          "Are you sure you want to delete this report?",
                                      textCancel: "No",
                                      textConfirm: "Yes",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () async {
                                        Get.back(); // Close the dialog first
                                        await controller
                                            .deleteReport(report['id']);
                                      },
                                    );
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) async {
                                    final pdfBytes =
                                        await controller.generatePdf(report);
                                    await Printing.layoutPdf(
                                        onLayout: (_) async => pdfBytes);
                                  },
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.picture_as_pdf,
                                  label: 'Download PDF',
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 100.h,
                                  width: 100.w,
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(Const.report,
                                      fit: BoxFit.cover),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${report['apartmentName']} ${report['apartmentNumber']} (${report['apartmentUnit']})",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Swap left or right",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: Colors.white, size: 18),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
