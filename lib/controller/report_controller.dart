import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class ReportController extends GetxController {
  final reports = [].obs;
  final isLoading = false.obs;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> fetchReports() async {
    isLoading.value = true;
    try {
      final user = _auth.currentUser;
      if (user == null) throw "No logged in user";

      final query = await _firestore
          .collection('reports')
          .where('inspectedBy', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      reports.value = query.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch reports: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Uint8List> generatePdf(Map<String, dynamic> report) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    final logo = await rootBundle.load(Const.logo);

    Uint8List? techSignature;
    Uint8List? clientSignature;
    if (report['signatures'] != null) {
      techSignature = await networkImageToBytes(report['signatures']['technician']);
      clientSignature = await networkImageToBytes(report['signatures']['client']);
    }

    // Preload all room entry images
    final roomWidgets = <pw.Widget>[];
    for (var room in report['rooms']) {
      final entryWidgets = <pw.Widget>[];

      for (var entry in room['entries']) {
        Uint8List? imageBytes;
        if (entry['imageUrl'] != null) {
          try {
            imageBytes = await networkImageToBytes(entry['imageUrl']);
          } catch (_) {
            // Fail silently if image fails to load
          }
        }

        entryWidgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Date: ${entry['date']}\nLevel: ${entry['interventionLevel']}\nComment: ${entry['comment']}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                if (imageBytes != null) ...[
                  pw.Spacer(),
                  pw.Image(pw.MemoryImage(imageBytes), height: 150,width: 150),
                  pw.SizedBox(width: 10),
                ],
              ],
            ),
          ),
        );
      }

      roomWidgets.add(
        pw.Container(
          margin: const pw.EdgeInsets.symmetric(vertical: 5),
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(room['roomName'], style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...entryWidgets,
            ],
          ),
        ),
      );
    }

    // Now safe to build the PDF synchronously
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf),
        build: (context) {
          return [
            pw.Container(
              color: PdfColors.blue200,
              padding: const pw.EdgeInsets.all(12),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Apartment Inspection Report',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.Image(pw.MemoryImage(logo.buffer.asUint8List()), width: 50),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text('${report['apartmentName']} : ${report['apartmentNumber']} - ${report['apartmentUnit']}',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Covers summary, rooms, schedule and comments',
                      style: pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _infoCard('Date', report['inspectionDate']),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _scheduleTable(report['schedule']),
                      pw.SizedBox(height: 10),
                      _timeTable(report['timeEstimates']),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Room Inspections', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            ...roomWidgets,
            if (techSignature != null || clientSignature != null)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 20),
                      pw.Text("Signatures", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      if (techSignature != null)
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Technician :"),
                            pw.SizedBox(height: 10),
                            pw.Image(pw.MemoryImage(techSignature), height: 50),
                          ],
                        ),
                    ]
                  ),
                  pw.Spacer(),
                  pw.Column(
                    children: [
                      if (clientSignature != null)
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(height: 40),
                            pw.Text("Client :"),
                            pw.SizedBox(height: 10),
                            pw.Image(pw.MemoryImage(clientSignature), height: 50),
                          ],
                        ),
                    ]
                  ),
                ],
              ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Center(
              child: pw.Text(
                'Generated by Apartment Inspection App',
                style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }


// Helper for info blocks
  pw.Widget _infoCard(String title, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
          pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  // Search function
  void searchReports(String query) {
    if (query.isEmpty) {
      reports.value = List.from(reports);
    } else {
      reports.value = reports.where((report) {
        final apartment = report['apartmentNumber'].toString().toLowerCase();
        final apartmentName = report['apartmentName'].toString().toLowerCase();
        final unit = report['apartmentUnit'].toString().toLowerCase();
        final search = query.toLowerCase();

        return apartmentName.contains(search) || apartment.contains(search) || unit.contains(search);
      }).toList();
    }
  }

//delete
  Future<void> deleteReport(String id) async {
    try {
      await _firestore.collection('reports').doc(id).delete();
      fetchReports(); // Refresh list after deletion
    } catch (e) {
      Get.snackbar("Error", "Failed to delete report");
    }
  }

// Schedule Table
  pw.Widget _scheduleTable(List<dynamic>? schedule) {
    if (schedule == null) return pw.SizedBox();
    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headers: ['Stage', 'Due Date'],
      data: schedule.map((e) => [e['stage'], e['due']]).toList(),
      border: pw.TableBorder.all(color: PdfColors.grey400),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

// Time Table
  pw.Widget _timeTable(List<dynamic>? timeEstimates) {
    if (timeEstimates == null) return pw.SizedBox();
    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headers: ['Task', 'Hours'],
      data: timeEstimates.map((e) => [e['task'], e['hours']]).toList(),
      border: pw.TableBorder.all(color: PdfColors.grey400),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }


  Future<Uint8List> networkImageToBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to load image from $url");
    }
  }

  Future<void> savePdfToDownloads(Uint8List pdfBytes, String fileName) async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          Get.snackbar("Permission Denied", "Storage permission is required to save the file.",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }
      }

      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      Get.snackbar("Success", "PDF saved to $filePath",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      print("Error saving PDF: $e");
      Get.snackbar("Error", "Failed to save PDF: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
