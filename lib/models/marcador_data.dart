import 'package:flutter/foundation.dart';

import '../utils/shared_prefs.dart';

class MarcadorData with ChangeNotifier {
  MarcadorData() {
    _getPrefMarcador();
  }

  final SharedPrefs _sharedPrefs = SharedPrefs();
  int _errores = 0;
  int _victorias = 0;
  int _derrotas = 0;

  void _getPrefMarcador() async {
    await _sharedPrefs.init();
    _victorias = _sharedPrefs.victorias ?? 0;
    _derrotas = _sharedPrefs.derrotas ?? 0;
    notifyListeners();
  }

  // void getValores() => _getPrefMarcador();

  int get errores => _errores;

  void sumaError() {
    _errores++;
    notifyListeners();
  }

  void resetErrores() {
    _errores = 0;
    notifyListeners();
  }

  int get victorias => _victorias;
  int get derrotas => _derrotas;

  void sumaVictoria() {
    _victorias++;
    _sharedPrefs.victorias = _victorias;
    notifyListeners();
  }

  void sumaDerrota() {
    _derrotas++;
    _sharedPrefs.derrotas = _derrotas;
    notifyListeners();
  }

  void resetMarcador() {
    _victorias = 0;
    _derrotas = 0;
    _sharedPrefs
      ..victorias = _victorias
      ..derrotas = _derrotas;
    notifyListeners();
  }
}
