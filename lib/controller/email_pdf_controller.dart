import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../utils/constant/const.dart';
import '../views/bottom_navbar/user_bottom_nav_bar.dart';

class EmailPdfController extends GetxController {
  var isLoading = false.obs;

  final recipientEmail = ''.obs;

  Future<void> sendPdfLinkByEmail({
    required String subject,
    required String messageBody,
    required String pdfUrl,
  }) async {
    isLoading(true);

    final smtpServer = gmail(Const.smtpUsername, Const.smtpPassword);
    final message = Message()
      ..from = Address(Const.smtpUsername, 'Apartment Inspection')
      ..recipients.add(recipientEmail.value)
      ..recipients.add("ciechelski@gmail.com")
      ..subject = subject
      ..text = messageBody
      ..html = '''
        <h2>$subject</h2>
        <p>$messageBody</p>
        <p><a href="$pdfUrl">Download PDF</a></p>
      ''';

    try {
      await send(message, smtpServer);
      Get.snackbar("Success", "Email sent to ${recipientEmail.value}");
      Get.offAll(() => const UserCustomBottomBar());
    } catch (e) {
      Get.snackbar("Error", "Failed to send email: $e");
    } finally {
      isLoading(false);
    }
  }
}
