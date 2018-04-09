/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

class Settings {
  int _nPlayers;
  int _turnDurationInSeconds;
  int _nSkip;
  int _nTurns;

  Settings([this._nPlayers = 2, this._turnDurationInSeconds = 90, this._nSkip = 3, this._nTurns = 10]);

  int get nSkip => _nSkip;

  int get turnDurationInSeconds => _turnDurationInSeconds;

  int get nPlayers => _nPlayers;

  int get nTurns => _nTurns;
  set nSkip(int value) {
    _nSkip = value;
  }

  set turnDurationInSeconds(int value) {
    _turnDurationInSeconds = value;
  }

  set nPlayers(int value) {
    _nPlayers = value;
  }

  set nTurns(int value) {
    _nTurns = value;
  }
}
