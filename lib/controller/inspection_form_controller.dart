import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../utils/constant/const.dart' show Const;
import '../views/user/pdf/send_pdf.dart';
import 'login_controller.dart';

class InspectionFormController extends GetxController {
  final LoginController controller = Get.put(LoginController());
  final commentController = TextEditingController();
  final dateController = TextEditingController();
  final interventionLevelController = TextEditingController();
  var selectedInterventionLevel = 'Observation'.obs;
  final selectedImages = <File>[].obs;

  final isLoading = false.obs;

  final Map<String, List<Map<String, dynamic>>> roomEntries = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  void setInterventionLevel(String level) {
    selectedInterventionLevel.value = level;
  }

  Future<void> pickImageSource(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    selectedImages.add(File(pickedFile.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Pick from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFiles = await _picker.pickMultiImage();
                  if (pickedFiles.isNotEmpty) {
                    selectedImages.addAll(pickedFiles.map((e) => File(e.path)));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<String?> uploadImage(File? imageFile) async {
    if (imageFile == null) return null;
    final ref =
        _storage.ref('reports/${DateTime.now().millisecondsSinceEpoch}.png');
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> addRoomEntry(
    String roomName, {
    required String? apartmentNumber,
    required String? apartmentUnit,
    required String? apartmentName,
    required String? checkingName,
  }) async {
    if (commentController.text.isEmpty) {
      Get.snackbar("Error", "Comment is required for the room");
      return;
    }

    try {
      isLoading.value = true;

      final imageToUpload =
          selectedImages.isNotEmpty ? selectedImages.first : null;
      final imageUrl = await uploadImage(imageToUpload);

      final entry = {
        'checkingName': checkingName,
        'comment': commentController.text,
        'interventionLevel': selectedInterventionLevel.value,
        'imageUrl': imageUrl ?? '',
      };

      final query = await _firestore
          .collection('reports')
          .where('apartmentNumber', isEqualTo: apartmentNumber)
          .where('apartmentUnit', isEqualTo: apartmentUnit)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        // Create a new report
        await _firestore.collection('reports').add({
          'apartmentNumber': apartmentNumber,
          'apartmentUnit': apartmentUnit,
          'apartmentName': apartmentName,
          'inspectionDate': dateController.text,
          'createdAt': Timestamp.now(),
          'rooms': [
            {
              'roomName': roomName,
              'entries': [entry],
            }
          ],
          'inspectionStatus': 'Pending',
        });
      } else {
        // Update existing report
        final doc = query.docs.first;
        final docRef = _firestore.collection('reports').doc(doc.id);
        final rooms = List<Map<String, dynamic>>.from(doc['rooms'] ?? []);

        final roomIndex =
            rooms.indexWhere((room) => room['roomName'] == roomName);
        if (roomIndex != -1) {
          List<Map<String, dynamic>> entries = List<Map<String, dynamic>>.from(
              rooms[roomIndex]['entries'] ?? []);
          entries.add(entry);
          rooms[roomIndex]['entries'] = entries;
        } else {
          rooms.add({
            'roomName': roomName,
            'entries': [entry],
          });
        }

        await docRef.update({
          'rooms': rooms,
          'updatedAt': Timestamp.now(),
        });
      }

      // Track local state
      roomEntries.putIfAbsent(roomName, () => []).add(entry);
      Get.back();
      // Reset fields
      commentController.clear();
      dateController.clear();
      selectedImages.clear();

      Get.snackbar("Room Saved", "Added entry to $roomName");
    } catch (e) {
      Get.snackbar("Error", "Failed to add room entry: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitReport({
    required String? apartmentNumber,
    required String? apartmentUnit,
    required String? apartmentName,
    Map<String, String>? signatureUrls,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (dateController.text.isEmpty || roomEntries.isEmpty) {
      Get.snackbar("Error", "Please select a date and add at least one room");
      return;
    }

    try {
      isLoading.value = true;

      final newRoomList = roomEntries.entries.map((entry) {
        return {
          'roomName': entry.key,
          'entries': entry.value,
        };
      }).toList();

      final query = await _firestore
          .collection('reports')
          .where('apartmentNumber', isEqualTo: apartmentNumber)
          .where('apartmentUnit', isEqualTo: apartmentUnit)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        final existingRooms =
            List<Map<String, dynamic>>.from(doc['rooms'] ?? []);

        for (var newRoom in newRoomList) {
          final index = existingRooms
              .indexWhere((room) => room['roomName'] == newRoom['roomName']);
          if (index != -1) {
            existingRooms[index] = newRoom;
          } else {
            existingRooms.add(newRoom);
          }
        }

        await _firestore.collection('reports').doc(doc.id).update({
          'rooms': existingRooms,
          'updatedAt': Timestamp.now(),
          if (signatureUrls != null) ...{
            'signatures': signatureUrls,
            'inspectionStatus': 'Done',
          }
        });
      } else {
        await _firestore.collection('reports').add({
          'apartmentNumber': apartmentNumber,
          'apartmentUnit': apartmentUnit,
          'apartmentName': apartmentName,
          'inspectedBy': user?.uid,
          'inspectionDate': dateController.text,
          'createdAt': Timestamp.now(),
          'rooms': newRoomList,
          if (signatureUrls != null) ...{
            'signatures': signatureUrls,
            'inspectionStatus': 'Done',
          }
        });
      }

      // Reset local state
      roomEntries.clear();
      selectedImages.clear();
      commentController.clear();
      dateController.clear();

      Get.snackbar("Success", "Inspection report submitted");
    } catch (e) {
      Get.snackbar("Error", "Submit failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadSignaturesAndSubmit({
    required SignatureController? technicianController,
    required SignatureController? clientController,
    required String? apartmentNumber,
    required String? apartmentUnit,
    required String? apartmentName,
  }) async {
    if (!(technicianController?.isNotEmpty ?? false) ||
        !(clientController?.isNotEmpty ?? false)) {
      Get.snackbar("Error", "Please complete both signatures.");
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;
    try {
      isLoading.value = true;

      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final query = await _firestore
          .collection('reports')
          .where('apartmentNumber', isEqualTo: apartmentNumber)
          .where('apartmentUnit', isEqualTo: apartmentUnit)
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        Get.snackbar("Error", "No report found for this apartment this month.");
        return;
      }

      final reportDoc = query.docs.first.reference;

      final techData = await technicianController?.toPngBytes();
      final clientData = await clientController?.toPngBytes();

      if (techData == null || clientData == null) {
        throw "Signature conversion failed";
      }

      final techRef = _storage
          .ref('signatures/${apartmentNumber}_${apartmentUnit}_technician.png');
      final clientRef = _storage
          .ref('signatures/${apartmentNumber}_${apartmentUnit}_client.png');

      await techRef.putData(techData);
      await clientRef.putData(clientData);

      final techUrl = await techRef.getDownloadURL();
      final clientUrl = await clientRef.getDownloadURL();

      await reportDoc.update({
        'signatures': {
          'technician': techUrl,
          'client': clientUrl,
        },
        'inspectionStatus': 'Done',
        'inspectedBy': user?.uid,
        'updatedAt': Timestamp.now(),
      });

      final reportSnapshot = await reportDoc.get();
      await generateAndUploadPdf(
        reportId: reportDoc.id,
        report: reportSnapshot.data() as Map<String, dynamic>,
      );

      // Fetch updated PDF URL
      final updatedSnapshot = await reportDoc.get();
      final updatedData = updatedSnapshot.data() as Map<String, dynamic>;
      final pdfUrl = updatedData['pdfUrl'];

      // Navigate to SendPdfPage
      Get.snackbar("Success", "PDF report generated");
      Get.to(() => SendPdfPage(pdfUrl: pdfUrl));
    } catch (e) {
      Get.snackbar("Error", "Signature upload failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Uint8List> networkImageToBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to load image from $url");
    }
  }


  Future<void> generateAndUploadPdf({
    required String reportId,
    required Map<String, dynamic> report,
  }) async {
    try {
      final pdf = pw.Document();
      final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);

      // Example simple content (replace with your detailed layout)
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
            pw.Text(
              "Inspection location",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
                decoration: pw.TextDecoration.underline,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              "Syndicat des copropriétaires ${report['apartmentName']} - Unit ${report['apartmentUnit']}",
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 20),

            // Prepared By Section
            pw.Text(
              "Prepared by",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
                decoration: pw.TextDecoration.underline,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 5),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  controller.user.value.name.toString(),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "Montréal",
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "5345 Rang du Bas St-François",
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "Laval, Quebec",
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "H7E 4P2",
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "Tel: (514) 742-5933",
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "RBQ: 5761-8506-01",
                  textAlign: pw.TextAlign.center,
                ),
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
                    pw.Text("Report generated by Apartment Inspection",
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

      // Save and upload PDF
      final output = await getTemporaryDirectory();
      final filePath = "${output.path}/inspection_$reportId.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      final pdfRef = _storage.ref("pdf_reports/$reportId.pdf");
      await pdfRef.putFile(file);

      final pdfUrl = await pdfRef.getDownloadURL();

      await _firestore.collection('reports').doc(reportId).update({
        'pdfUrl': pdfUrl,
      });

      print("✅ PDF uploaded and URL saved");
    } catch (e) {
      print("❌ PDF generation failed: $e");
    }
  }


}
