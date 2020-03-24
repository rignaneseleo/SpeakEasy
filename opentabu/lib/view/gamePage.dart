/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opentabu/bloc/bloc.dart';
import 'package:opentabu/bloc/game_state.dart';
import 'package:opentabu/controller/game_controller.dart';
import 'package:opentabu/controller/teams_controller.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/team.dart';
import 'package:opentabu/model/word.dart';

import '../main.dart';

class GamePage extends StatefulWidget {
  GamePage();

  @override
  State<StatefulWidget> createState() {
    return new GamePageState();
  }
}

class GamePageState extends State<GamePage> with AfterLayoutMixin<GamePage> {
  Timer _countSecondsTimer;
  GameBloc gameBloc;

  @override
  void afterFirstLayout(BuildContext context) {
    gameBloc = BlocProvider.of<GameBloc>(context);
    /* _countSecondsTimer = new Timer.periodic(
        new Duration(seconds: 1), (timer) => BlocProvider.of<GameBloc>(context)..add(OneSecondPassed()));*/
  }

  @override
  void dispose() {
    _countSecondsTimer.cancel();
    gameBloc.close();
    super.dispose();
  }

  void initTimer() {
    _countSecondsTimer = new Timer.periodic(
        new Duration(seconds: 1), (timer) => gameBloc..add(OneSecondPassed()));
    //_turnTimer = new Timer(new Duration(seconds: _timerDuration), timeOut);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: new Material(child: BlocBuilder<GameBloc, GameState>(
      // ignore: missing_return
      builder: (context, GameState state) {
        print(state);
        if (state is InitialGameState) {
          return buildStartBody();
        } else if (state is StartedGameState) {
          return buildGameBody(state.game);
        } else if (state is UpdateGameState) {
          return buildGameBody(state.game);
        } else if (state is EndedGameState) {
          //TODO get winner info
          return buildEndBody();
        } else if (state is PausedGameState) {
          return buildPauseBody();
        } else if (state is UpdateTimeState) {
          /* setState(() {
            time = state.time;
          });*/

        } else if (state is LoadingState) {
          return Center(
            child: Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    )));
  }

  // ------ BODIES --------

  buildStartBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Ready to start?"),
          FlatButton(
            child: Text("Start"),
            onPressed: () {
              initTimer();
              gameBloc..add(new StartGame());
            },
          ),
        ],
      ),
    );
  }

  buildPauseBody() {
    return Column(
      children: <Widget>[
        Text("PAUSE"),
        FlatButton(
          child: Text("Restore"),
          onPressed: () {
            gameBloc.add(new Restore());
          },
        ),
      ],
    );
  }

  buildGameBody(game) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        buildGameInfo(game),
        Divider(height: 1.0),
        Expanded(child: buildMatchInfo(game)),
      ],
    );
  }

  buildEndBody() {
    return Column(
      children: <Widget>[
        Text("END"),
        Text("Winner: "),
        FlatButton(
          child: Text("Go home"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // ------ WIDGETS --------
  buildMatchInfo(GameController game) {
    //Prints the info related to the match that change every timeout (timer, etc..)

    Widget timer = new Center(
      child: new Text(
        game.secondsPassed.toString(),
        style: new TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: game.secondsPassed < 8 ? Colors.red : Colors.black),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        timer,
        Expanded(child: buildWordTaboo(game)),
        new Divider(height: 10.0),
        getButton(game),
      ],
    );
  }

  buildGameInfo(GameController game) {
    //Prints the info related to the game (teams, scores, turns left, skips etc..)
    List<Widget> teams = new List<Widget>();

    for (Team team in game.teams) {
      String teamName = team.name;
      int teamScore = team.score;
      int teamSkips = team.skipsLeft;
      bool isCurrentTeam = team == game.currentTeam;

      teams.add(new Expanded(
          child: Opacity(
              opacity: isCurrentTeam ? 1 : 0.5,
              child: new Column(
                children: <Widget>[
                  new Text(
                    teamName,
                    style: new TextStyle(fontSize: 13.0, color: Colors.black),
                  ),
                  new Text(
                    teamScore.toString(),
                    style: new TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                  new Text(
                    "Skips " + teamSkips.toString(),
                    style: new TextStyle(
                      fontSize: 12.0,
                    ),
                  )
                ],
              ))));
    }

    Widget turns = new Center(
      child: new Text(
        "Turn " + (game.currentTurn).toString(),
        style: new TextStyle(fontSize: 18.0, color: Colors.black54),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FlatButton(
          child: Text("Pause"),
          onPressed: () => gameBloc..add(Pause()),
        ),
        turns,
        Container(
          padding: new EdgeInsets.all(8.0),
          child: new Row(
            children: teams,
          ),
        )
      ],
    );
  }

  Widget buildWordTaboo(GameController game) {
    List<Widget> taboos = new List<Widget>();

    List<String> _taboos = game.currentWord.getTaboos(game.settings.nTaboos);

    for (int i = 0; i < _taboos.length; i++) {
      taboos.add(new Text(
        _taboos[i],
        style: new TextStyle(fontSize: 35.0, color: Colors.black54),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));
    }

    return new Expanded(
        child: new Container(
      padding: new EdgeInsets.all(15.0),
      child: new Column(
        children: <Widget>[
          new Padding(
              padding: new EdgeInsets.symmetric(vertical: 20.0),
              child: new Text(
                game.currentWord.wordToGuess,
                style: new TextStyle(fontSize: 56.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          new Column(children: taboos)
        ],
      ),
    ));
  }

  Widget getButton(GameController game) {
    return new Container(
      padding: new EdgeInsets.all(15.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new IconButton(
                  icon: new Icon(Icons.close, color: Colors.red),
                  iconSize: 70.0,
                  onPressed: () => _buttonHandler(false))),
          new FlatButton(
              child: new Text(
                game.currentTeam.skipsLeft.toString() + " SKIP",
                style: new TextStyle(fontSize: 20.0),
              ),
              onPressed: game.currentTeam.skipsLeft == 0
                  ? null
                  : () => _buttonHandler(null)),
          new Expanded(
              child: new IconButton(
                  icon: new Icon(Icons.done, color: Colors.lightGreen),
                  iconSize: 70.0,
                  onPressed: () => _buttonHandler(true)))
        ],
      ),
    );
  }

  void _buttonHandler(bool isRight) {
    setState(() {
      if (isRight == null)
        gameBloc..add(Answer(AnswerType.skip));
      else
        gameBloc
          ..add(Answer(isRight ? AnswerType.correct : AnswerType.incorrect));
    });
  }

/*
  void timeOut() {
    Text title;
    Text button;
    Text content;

    bool end = _gameController.startNewTurn();

    //Check if it's the end

    if (end) {
      title = new Text("Team " + _gameController.winner.toString() + " win!");
      button = new Text('Main menu');
    } else {
      title = new Text("TIME IS OVER");
      content = new Text("Give the phone to the next player.");
      button = new Text('Start!');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(title: title, content: content, actions: <Widget>[
        new FlatButton(
          child: button,
          onPressed: () {
            //Close the dialog
            Navigator.of(context).pop();

            //Check if it's the end
            if (end)
              Navigator.of(context).pop();
            else
              initTimer();
            setState(() {});
          },
        ),
      ]),
    );
  }*/
}
