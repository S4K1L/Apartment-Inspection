import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

class InspectionFormController extends GetxController {
  final commentController = TextEditingController();
  final dateController = TextEditingController();
  final interventionLevelController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      selectedImages.addAll(pickedFiles.map((e) => File(e.path)));
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<String?> uploadImage(File? imageFile) async {
    if (imageFile == null) return null;
    final ref = _storage.ref('reports/${DateTime.now().millisecondsSinceEpoch}.png');
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> addRoomEntry(
      String roomName, {
        required String? apartmentNumber,
        required String? apartmentUnit,
        required String? apartmentName,
      }) async {
    if (commentController.text.isEmpty) {
      Get.snackbar("Error", "Comment is required for the room");
      return;
    }

    try {
      isLoading.value = true;

      final imageToUpload = selectedImages.isNotEmpty ? selectedImages.first : null;
      final imageUrl = await uploadImage(imageToUpload);

      final entry = {
        'comment': commentController.text,
        'interventionLevel': selectedInterventionLevel.value,
        'imageUrl': imageUrl ?? '',
        'date': dateController.text,
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

        final roomIndex = rooms.indexWhere((room) => room['roomName'] == roomName);
        if (roomIndex != -1) {
          List<Map<String, dynamic>> entries =
          List<Map<String, dynamic>>.from(rooms[roomIndex]['entries'] ?? []);
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

    try {
      isLoading.value = true;

      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final query = await _firestore
          .collection('reports')
          .where('apartmentNumber', isEqualTo: apartmentNumber)
          .where('apartmentUnit', isEqualTo: apartmentUnit)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
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

      final techRef = _storage.ref('signatures/${apartmentNumber}_${apartmentUnit}_technician.png');
      final clientRef = _storage.ref('signatures/${apartmentNumber}_${apartmentUnit}_client.png');

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
        'updatedAt': Timestamp.now(),
      });

      Get.snackbar("Success", "Signatures submitted successfully.");
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Signature upload failed: $e");
    } finally {
      isLoading.value = false;
    }
  }


}
