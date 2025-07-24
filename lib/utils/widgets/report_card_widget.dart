import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCardWidget extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportCardWidget({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final String apartmentName = report['apartmentName'] ?? 'Unknown';
    final String apartmentNumber = report['apartmentNumber'] ?? 'N/A';
    final String apartmentUnit = report['apartmentUnit'] ?? 'N/A';
    final Timestamp? createdAt = report['createdAt'];
    final DateTime date = createdAt?.toDate() ?? DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: Text(
            apartmentName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Apt No: $apartmentNumber"),
                Text("Unit: $apartmentUnit"),
                Text("Date: $formattedDate"),
              ],
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Optional: Navigate to report details
          },
        ),
      ),
    );
  }
}
