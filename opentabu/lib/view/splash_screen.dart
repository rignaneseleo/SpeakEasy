import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speakeasy/main.dart';
import 'package:speakeasy/view/widget/my_scaffold.dart';
import 'package:speakeasy/view/widget/my_title.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    print("Screen height: " + MediaQuery.of(context).size.height.toString());
    smallScreen = MediaQuery.of(context).size.height < 600;
    /*if (kDebugMode) {
      smallScreen = true;
    }*/

    return MyScaffold(
      widgets: <Widget>[
        MyTitle(),
        LinearProgressIndicator(),
      ],
    );
  }
}
