import 'package:apartmentinspection/controller/login_controller.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class ReportController extends GetxController {
  final controller = Get.put(LoginController());
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
      techSignature =
      await networkImageToBytes(report['signatures']['technician']);
      clientSignature =
      await networkImageToBytes(report['signatures']['client']);
    }

    final roomWidgets = <pw.Widget>[];
    for (var room in report['rooms']) {
      final entryWidgets = <pw.Widget>[];

      for (var entry in room['entries']) {
        Uint8List? imageBytes;
        if (entry['imageUrl'] != null) {
          try {
            imageBytes = await networkImageToBytes(entry['imageUrl']);
          } catch (_) {}
        }

        entryWidgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'Checking: ${entry['checkingName'] ?? ''}\nLevel: ${entry['interventionLevel'] ?? ''}\nComment: ${entry['comment'] ?? ''}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                if (imageBytes != null)
                  pw.Image(pw.MemoryImage(imageBytes), height: 100, width: 100),
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
              pw.Text(room['roomName'],
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...entryWidgets,
            ],
          ),
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf),
        build: (context) => [
          // Black Banner Header
          pw.Container(
            color: PdfColors.black,
            padding: const pw.EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            child: pw.Column(
              children: [
                pw.Text('Inspection report',
                    style: pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Text('Vigilo prevention program',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.white,
                    )),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Centered Logo
          pw.Center(
            child: pw.Image(pw.MemoryImage(logo.buffer.asUint8List()), height: 80),
          ),

          pw.Divider(),

          // Inspection Location
          pw.Text("Inspection location",
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                  decoration: pw.TextDecoration.underline),
              textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 5),
          pw.Text("Syndicat des copropriétaires ${report['apartmentName']} - Unit ${report['apartmentUnit']}",
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.center),

          pw.SizedBox(height: 20),

          // Prepared By Section
          pw.Text("Prepared by",
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                  decoration: pw.TextDecoration.underline),
              textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 5),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(controller.user.value.name.toString()),
              pw.Text("Montréal"),
              pw.Text("5345 Rang du Bas St-François"),
              pw.Text("Laval, Quebec"),
              pw.Text("H7E 4P2"),
              pw.Text("Tel: (514) 742-5933"),
              pw.Text("RBQ: 5761-8506-01"),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Divider(),

          // Footer
          pw.SizedBox(height: 50),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Inspection date: ${report['inspectionDate'] ?? 'N/A'}",
                  style: pw.TextStyle(fontSize: 10)),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Report generated by TrackandFix.com",
                      style: pw.TextStyle(fontSize: 8)),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          // Room Inspections
          if (roomWidgets.isNotEmpty)
            pw.Text("Room Inspections",
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ...roomWidgets,

          // Signatures
          if (techSignature != null || clientSignature != null)
            pw.SizedBox(height: 20),
          if (techSignature != null || clientSignature != null)
            pw.Text("Signatures",
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (techSignature != null)
                pw.Column(children: [
                  pw.Text("Technician:"),
                  pw.SizedBox(height: 5),
                  pw.Image(pw.MemoryImage(techSignature), height: 50),
                ]),
              pw.Spacer(),
              if (clientSignature != null)
                pw.Column(children: [
                  pw.Text("Client:"),
                  pw.SizedBox(height: 5),
                  pw.Image(pw.MemoryImage(clientSignature), height: 50),
                ]),
            ],
          ),
        ],
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
          pw.Text(title,
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800)),
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

        return apartmentName.contains(search) ||
            apartment.contains(search) ||
            unit.contains(search);
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
          Get.snackbar("Permission Denied",
              "Storage permission is required to save the file.",
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
