import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/view/widget/my_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  //TODO email da codificare con https://www.w3schools.com/tags/ref_urlencode.asp
  static const String emailLeo = "dev.rignaneseleo%2Btabu%40gmail.com";

  @override
  Widget build(BuildContext context) {
    return MyScaffold(widgets: [
      //new Text("VERSIONE ${Weco.AppVersion}"),
      /*Container(
        height: 200,
        child: TextButton(
          onPressed: () => _launchURL("mailto:$emailLeo?subject=Bug%20tabu%20"),
          child: new Text(
            "Report BUG",
            style: Theme.of(context).textTheme.headline4.copyWith(color: myRed),
          ),
        ),
      ),*/
      GestureDetector(
        child: new AutoSizeText(
          "Made by\nLeonardo Rignanese",
          style: Theme.of(context).textTheme.headline1,
          maxLines: 3,
        ),
        onTap: () async =>
            await _launchURL("https://www.linkedin.com/in/rignaneseleo/"),
      ),
    ]);
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
