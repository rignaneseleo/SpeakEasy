import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Team {
  final String name;
  final Color color;
  int _score;
  int _skipsLeft;

  Team({@required this.name, @required this.color, @required int skipsTot}) {
    _skipsLeft = skipsTot;
    _score = 0;
  }

  //---- SCORE ----
  int addPoint() {
    return _score++;
  }

  int removePoint() {
    if (_score - 1 >= 0) _score--;
    return _score;
  }

  int get score => _score;

  //---- SKIPS ----
  bool canSkip() {
    return _skipsLeft - 1 >= 0;
  }

  int skipWord() {
    if (_skipsLeft - 1 >= 0) _skipsLeft--;
    return _skipsLeft;
  }

  get skipsLeft => _skipsLeft;
}
