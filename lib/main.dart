import 'core/my_app.dart';
import 'firebase_options.dart';
import 'services/smtp_server.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //smtp server
  await checkAndSendEmailForOutdatedSensors();
  runApp(const MyApp());
}