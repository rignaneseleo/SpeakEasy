import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  //TODO email da codificare con https://www.w3schools.com/tags/ref_urlencode.asp
  static const String emailLeo = "dev.rignaneseleo%2Btabu%40gmail.com";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: new Text(
            "Info",
            style: TextStyle(fontSize: 22),
          ),
        ),
        body: new Center(
            child: new Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //new Text("VERSIONE ${Weco.AppVersion}"),
                GestureDetector(
                  child: new Text("Made by Leonardo Rignanese with ☕️"),
                  onTap: () async =>
                  await _launchURL("https://www.linkedin.com/in/rignaneseleo/"),
                ),
                new Container(
                  height: 100.0,
                ),
                new FlatButton(
                    onPressed: () => _launchURL(
                        "mailto:$emailLeo?subject=Bug%20tabu%20"),
                    child: new Text(
                      "Report BUG",
                      style: TextStyle(color: Colors.red.shade900),
                    )),

              ],
            )));
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
