import 'package:url_launcher/url_launcher.dart';

String capitalize(String s) {
  if(s.length == 0) return s;
  return s[0].toUpperCase() + s.substring(1);
}

Future launchURL(String url) async {
  try{
    await launchUrl(Uri.parse(url));
  }
  catch(e){
    print("ERROR launchURL: $e");
  }
}
