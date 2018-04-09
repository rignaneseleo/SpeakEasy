/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/word.dart';
import 'package:opentabu/view/gamePage.dart';
import 'package:opentabu/view/homePage.dart';

void main() => runApp(new OpenTabu());

class OpenTabu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new OpenTabuState();
  }
}

class OpenTabuState extends State<OpenTabu> {
  Widget _body;

  OpenTabuState() {
    _body = new HomePage(newGame);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'OpenTabu',
      home: new Scaffold(
        appBar: new AppBar(title: new Text('OpenTabu'), centerTitle: true, backgroundColor: (Colors.deepOrange)),
        body: _body,
      ),
    );
  }

  void newGame(Settings settings, List<Word> words) {
    setState(() {
      _body = new WillPopScope(child: new GamePage(settings, words, backToTheHome), onWillPop: _willPopCallback);
    });
  }

  Future<bool> _willPopCallback() async {
    //TODO maybe this is not the best way to do it
    backToTheHome();
    return false; // return true if the route to be popped
  }

  void backToTheHome() {
    setState(() {
      _body = new HomePage(newGame);
    });
  }
}
