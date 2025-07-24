import 'package:animate_do/animate_do.dart';
import 'package:apartmentinspection/controller/report_controller.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  final ReportController controller = Get.put(ReportController());
  ReportPage({super.key});
  void _showMonthYearPicker(BuildContext context) {
    final now = DateTime.now();
    final years = List.generate(10, (index) => now.year - index); // Last 10 years
    final months = List.generate(12, (index) => index + 1);
    int selectedMonth = controller.selectedMonth.value != 0 ? controller.selectedMonth.value : now.month;
    int selectedYear = controller.selectedYear.value != 0 ? controller.selectedYear.value : now.year;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select Month & Year", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        controller.updateMonthYear(selectedMonth, selectedYear);
                        Navigator.pop(context);
                      },
                      child: const Text("Apply", style: TextStyle(fontSize: 16)),
                    )
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  children: [
                    // Month Picker
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: selectedMonth - 1),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          selectedMonth = months[index];
                        },
                        children: months.map((m) => Center(child: Text(DateFormat.MMMM().format(DateTime(0, m))))).toList(),
                      ),
                    ),
                    // Year Picker
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: years.indexOf(selectedYear)),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          selectedYear = years[index];
                        },
                        children: years.map((y) => Center(child: Text(y.toString()))).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Bounce(
        duration: const Duration(milliseconds: 700),
        child: Column(
          children: [
            // Header with gradient and controls
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
              padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reports",
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: kWhiteColor),
                      ),
                      TextButton.icon(
                        onPressed: () => _showMonthYearPicker(context),
                        icon: const Icon(Icons.filter_alt_rounded, color: Colors.white),
                        label: Obx(() {
                          final m = controller.selectedMonth.value;
                          final y = controller.selectedYear.value;
                          return Text(
                            (m == 0 || y == 0) ? "Filter" : "${DateFormat.MMMM().format(DateTime(0, m))} $y",
                            style: const TextStyle(color: Colors.white),
                          );
                        }),
                      )

                    ],
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
                      onChanged: controller.searchReports,
                    ),
                  ),
                ],
              ),
            ),

            // Reports list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: SpinKitWave(color: kPrimaryColor, size: 50.0),
                  );
                }

                if (controller.reports.isEmpty) {
                  return const Center(child: Text("No reports found"));
                }

                return RefreshIndicator(
                  onRefresh: () async => controller.fetchAllReports(),
                  color: kPrimaryColor,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    itemCount: controller.reports.length,
                    itemBuilder: (context, index) {
                      final report = controller.reports[index];
                      final createdAt = (report['createdAt'] as Timestamp?)?.toDate();
                      final dateStr = createdAt != null
                          ? DateFormat('dd MMM yyyy').format(createdAt)
                          : 'Unknown';

                      return FadeInUp(
                        duration: Duration(milliseconds: 300 * (index + 1)),
                        child: Container(
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
                                      middleText: "Are you sure you want to delete this report?",
                                      textCancel: "No",
                                      textConfirm: "Yes",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () async {
                                        Get.back();
                                        await controller.deleteReport(report['id']);
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
                                    final pdfBytes = await controller.generatePdf(report);
                                    await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
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
                                  child: Image.asset(Const.report, fit: BoxFit.cover),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${report['apartmentName']} ${report['apartmentNumber']} (${report['apartmentUnit']})",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          "Created at: $dateStr",
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
                          ),
                        ),
                      );
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
