import 'package:flutter/foundation.dart';

import '../utils/constantes.dart';
import '../utils/shared_prefs.dart';

class AjustesData with ChangeNotifier {
  AjustesData() {
    _getPrefAjustes();
  }

  final SharedPrefs _sharedPrefs = SharedPrefs();
  bool _soundValor = true;
  bool _modoValor = false;
  String _nivelValor = defaultNivel;

  void _getPrefAjustes() async {
    await _sharedPrefs.init();
    _soundValor = _sharedPrefs.sound ?? true;
    _modoValor = _sharedPrefs.modo ??
        modoOnline.keys
            .firstWhere((k) => modoOnline[k].contains(_sharedPrefs.nivel), orElse: () => false);
    _nivelValor = modoOnline[_modoValor].contains(_sharedPrefs.nivel)
        ? _sharedPrefs.nivel
        : modoOnline[_modoValor].first;
    notifyListeners();
  }

  bool get soundPref => _sharedPrefs.sound ?? true;
  bool get modoPref => _sharedPrefs.modo ?? false;
  String get nivelPref => _sharedPrefs.nivel ?? modoOnline[modoPref].first;

  void getValores() => _getPrefAjustes();

  set setPrefSound(bool prefSound) {
    _sharedPrefs.sound = prefSound;
    notifyListeners();
  }

  set setPrefModo(bool prefModo) {
    _sharedPrefs.modo = prefModo;
    notifyListeners();
  }

  set setPrefNivel(String prefNivel) {
    _sharedPrefs.nivel = prefNivel;
    notifyListeners();
  }

  bool get soundValor => _soundValor;

  set updateSound(bool value) {
    _soundValor = value;
    notifyListeners();
  }

  bool get modoValor => _modoValor;

  set updateModo(bool value) {
    _modoValor = value;
    _nivelValor = modoOnline[value].first;
    notifyListeners();
  }

  String get nivelValor => _nivelValor;

  set updateNivel(String value) {
    _nivelValor = value;
    notifyListeners();
  }
}
