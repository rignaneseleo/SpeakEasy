import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
