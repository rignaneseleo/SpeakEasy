/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import 'package:flutter/material.dart';
import 'package:opentabu/handler/words_handler.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/team.dart';
import 'package:opentabu/model/word.dart';

class TeamsController {
  //Here is handled all the game data, aside the timer
  List<Team> teams = [];
  Settings settings;

  int iCurrentTeam;

  TeamsController(this.settings) {
    for (int i = 1; i <= settings.nPlayers; i++) {
      teams.add(
        Team(
            name: "Team$i",
            color: Colors.primaries.elementAt(i),
            skipsTot: settings.nSkip),
      );
    }
    iCurrentTeam = 0;
  }

  int changeTurn() {
    iCurrentTeam++;
    if (iCurrentTeam == settings.nPlayers) iCurrentTeam = 0;
    return iCurrentTeam;
  }

  int rightAnswer() {
    return teams[iCurrentTeam].addPoint();
  }

  int wrongAnswer() {
    return teams[iCurrentTeam].removePoint();
  }

  bool skip() {
    if (teams[iCurrentTeam].canSkip()) {
      teams[iCurrentTeam].skipWord();
      return true;
    }
    return false;
  }

  List<Team> getWinner() {
    //Create a duplicate
    List<Team> winners = teams.map<Team>((e) => e).toList();
    winners.sort((t1, t2) => t1.score.compareTo(t2.score));

    //Get all the first teams with same score
    return winners
        .getRange(
            0, winners.lastIndexWhere((team) => team.score == winners[0].score))
        .toList();
  }

  Team get currentTeam => teams[iCurrentTeam];
}
