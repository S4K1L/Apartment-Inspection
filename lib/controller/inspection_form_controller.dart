import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

class InspectionFormController extends GetxController {
  final commentController = ''.obs;
  final dateController = ''.obs;
  final pickedImage = Rx<File?>(null);

  final isLoading = false.obs;

  final Map<String, List<Map<String, dynamic>>> roomEntries = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      selectedImages.addAll(pickedFiles.map((e) => File(e.path)));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<String> uploadImage(File imageFile) async {
    final ref = FirebaseStorage.instance
        .ref('reports/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> addRoomEntry(String roomName) async {
    if (commentController.value.isEmpty || pickedImage.value == null) {
      Get.snackbar("Error", "Comment and image are required for the room");
      return;
    }

    final imageUrl = await uploadImage(pickedImage.value!);

    final entry = {
      'comment': commentController.value,
      'imageUrl': imageUrl,
    };

    if (roomEntries.containsKey(roomName)) {
      roomEntries[roomName]!.add(entry);
    } else {
      roomEntries[roomName] = [entry];
    }

    commentController.value = '';
    pickedImage.value = null;

    Get.snackbar("Room Saved", "Added entry to $roomName");
  }

  Future<void> submitReport({
    required String apartmentNumber,
    required String apartmentUnit,
    required String apartmentName,
    Map<String, String>? signatureUrls,
  }) async {
    if (dateController.value.isEmpty || roomEntries.isEmpty) {
      Get.snackbar("Error", "Please select a date and add at least one room");
      return;
    }

    try {
      isLoading.value = true;

      final List<Map<String, dynamic>> newRoomList = roomEntries.entries.map((entry) {
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
        final existingRooms = List<Map<String, dynamic>>.from(doc['rooms'] ?? []);

        for (var newRoom in newRoomList) {
          final index = existingRooms.indexWhere((room) => room['roomName'] == newRoom['roomName']);
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
          'inspectionDate': dateController.value,
          'createdAt': Timestamp.now(),
          'rooms': newRoomList,
          if (signatureUrls != null) ...{
            'signatures': signatureUrls,
            'inspectionStatus': 'Done',
          }
        });
      }

      roomEntries.clear();
      selectedImages.clear();
      commentController.value = '';
      dateController.value = '';

      Get.snackbar("Success", "Inspection report submitted");
    } catch (e) {
      Get.snackbar("Error", "Submit failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadSignaturesAndSubmit({
    required SignatureController technicianController,
    required SignatureController clientController,
    required String apartmentNumber,
    required String apartmentUnit,
    required String apartmentName,
  }) async {
    if (!technicianController.isNotEmpty || !clientController.isNotEmpty) {
      Get.snackbar("Error", "Please complete both signatures.");
      return;
    }

    try {
      isLoading.value = true;

      // Restrict: Only 1 report per apartment per month
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final existingQuery = await _firestore
          .collection('reports')
          .where('apartmentNumber', isEqualTo: apartmentNumber)
          .where('apartmentUnit', isEqualTo: apartmentUnit)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .limit(1)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        Get.snackbar("Notice", "This apartment has already been inspected this month.");
        return;
      }

      Uint8List? techData = await technicianController.toPngBytes();
      Uint8List? clientData = await clientController.toPngBytes();

      if (techData == null || clientData == null) throw "Signature conversion failed";

      final techRef = FirebaseStorage.instance
          .ref('signatures/${apartmentNumber}_${apartmentUnit}_technician.png');
      final clientRef = FirebaseStorage.instance
          .ref('signatures/${apartmentNumber}_${apartmentUnit}_client.png');

      await techRef.putData(techData);
      await clientRef.putData(clientData);

      final techUrl = await techRef.getDownloadURL();
      final clientUrl = await clientRef.getDownloadURL();

      await submitReport(
        apartmentNumber: apartmentNumber,
        apartmentUnit: apartmentUnit,
        apartmentName: apartmentName,
        signatureUrls: {
          'technician': techUrl,
          'client': clientUrl,
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Signature upload failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
