import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> checkAndSendEmailForOutdatedSensors() async {
  final now = DateTime.now();
  final threshold = now.subtract(const Duration(days: 30));
  final apartments = await FirebaseFirestore.instance.collection('apartments').get();

  for (var apartmentDoc in apartments.docs) {
    final sensorsRef = apartmentDoc.reference.collection('sensor');
    final outdatedSensorsQuery = await sensorsRef
        .where('lastUpdate', isLessThanOrEqualTo: Timestamp.fromDate(threshold))
        .get();

    if (outdatedSensorsQuery.docs.isNotEmpty) {
      print("Found outdated sensors in apartment: ${apartmentDoc.id}");

      // Send email
      await sendEmailNotification(apartmentDoc.id, outdatedSensorsQuery.docs.length);
    }
  }
}

Future<void> sendEmailNotification(String apartmentId, int outdatedCount) async {
  String username = Const.smtpUsername;
  String password = Const.smtpPassword;

  final smtpServer = gmail(username, password);

  // Get the current logged-in user's email
  final user = FirebaseAuth.instance.currentUser;
  final userEmail = user?.email;

  if (userEmail == null) {
    print('No logged-in user found. Cannot send email.');
    return;
  }

  final message = Message()
    ..from = Address(username, 'Apartment Sensor Alert')
    ..recipients.add(userEmail)
    ..subject = 'Alert: Outdated Sensor(s) in Apartment $apartmentId'
    ..text = 'There are $outdatedCount sensor(s) batteries in apartment $apartmentId that haven\'t been changed in 30+ days. Please check the system.'
    ..html = '''
      <h2>Apartment Sensor Alert</h2>
      <p><strong>$outdatedCount</strong> sensor(s) in apartment <strong>$apartmentId</strong> have not been updated in over 30 days.</p>
      <p>Please take necessary action.</p>
    ''';

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Email not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
