import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhone(String phone) async {
  final Uri uri = Uri.parse("tel:$phone");
  await launchUrl(uri);
}

Future<void> launchWhatsApp(String phone) async {
  final formatted = phone.replaceAll("+", "");
  final Uri uri = Uri.parse("https://wa.me/$formatted");
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}