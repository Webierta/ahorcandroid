import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;
  static const String _prefsSound = 'sound';
  static const String _prefsModo = 'modo';
  static const String _prefsNivel = 'nivel';
  static const String _prefsVictorias = 'victorias';
  static const String _prefsDerrotas = 'derrotas';

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  bool get sound => _sharedPrefs?.getBool(_prefsSound);

  set sound(bool value) => _sharedPrefs.setBool(_prefsSound, value);

  bool get modo => _sharedPrefs?.getBool(_prefsModo);

  set modo(bool value) => _sharedPrefs.setBool(_prefsModo, value);

  String get nivel => _sharedPrefs?.getString(_prefsNivel);

  set nivel(String value) => _sharedPrefs.setString(_prefsNivel, value);

  int get victorias => _sharedPrefs?.getInt(_prefsVictorias);

  set victorias(int value) => _sharedPrefs?.setInt(_prefsVictorias, value);

  int get derrotas => _sharedPrefs?.getInt(_prefsDerrotas);

  set derrotas(int value) => _sharedPrefs?.setInt(_prefsDerrotas, value);
}
