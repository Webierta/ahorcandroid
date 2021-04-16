import 'package:flutter/material.dart';

class PalabraData with ChangeNotifier {
  String _palabraSecreta;
  bool _buscando = false;
  String _pista = '';
  List<String> _palabraOculta = [];
  List<String> _letrasUsadas = [];

  bool get buscando => _buscando;

  set buscando(bool value) {
    _buscando = value;
    notifyListeners();
  }

  String get palabraSecreta => _palabraSecreta;

  set updateSecreta(String value) {
    _palabraSecreta = value;
    _palabraOculta = List<String>.generate(value.length, (i) => '_');
    notifyListeners();
  }

  bool palabraNotFound() {
    return (_palabraSecreta == null ||
        _palabraSecreta == '' ||
        _palabraOculta == null ||
        (_palabraOculta?.isEmpty ?? true));
  }

  bool unexpectedError() {
    return _palabraOculta == null || _palabraOculta.isEmpty;
  }

  String get pista => _pista;

  set updatePista(String value) {
    _pista = value;
    notifyListeners();
  }

  String get palabraOculta => _palabraOculta.join();

  /* void updateOculta(int index, String letra) {
    _palabraOculta[index] = letra;
    notifyListeners();
  } */

  void adivinarOculta(String letra) {
    final listSecreta = _palabraSecreta.split('');
    _palabraOculta = listSecreta.map((letraSecreta) {
      if (letra == letraSecreta) return letra;
      return _palabraOculta[listSecreta.indexOf(letraSecreta)];
    }).toList();
    notifyListeners();
  }

  bool palabraAdivinada() {
    return _palabraOculta.join() == palabraSecreta;
  }

  List<String> get letrasUsadas => _letrasUsadas;

  void updateLetrasUsadas(String key) {
    _letrasUsadas.add(key);
    notifyListeners();
  }

  void resetLetrasUsadas() {
    _letrasUsadas.clear();
    notifyListeners();
  }

  void resetPartida() {
    _palabraSecreta = null; //'';
    _pista = '';
    _palabraOculta = [];
    _letrasUsadas = [];
    _letrasUsadas.clear();
    notifyListeners();
  }
}
