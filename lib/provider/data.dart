import 'package:flutter/foundation.dart';
import '../utils/shared_prefs.dart';
import '../utils/package_info.dart';
import '../utils/constantes.dart';

class Data extends ChangeNotifier {
  // preferencias
  final SharedPrefs _sharedPrefs = SharedPrefs();

  // screen settings
  bool _soundValor = true;
  bool _modoValor = false;
  String _nivelValor = defaultNivel;

  // aleatoria
  String _palabraSecreta; // mejor null
  bool _buscando = false;
  String _pista = '';
  List<String> _palabraOculta = [];
  List<String> _letrasUsadas = [];

  bool get buscando => _buscando;

  set buscando(bool value) {
    _buscando = value;
    notifyListeners();
  }

  // marcador
  int _errores = 0;
  int _victorias = 0;
  int _derrotas = 0;

  // pack info
  String _version = 'No disponible';
  var _packInfo = PackInfo();

  Data() {
    _readVersion();
    _getPrefs();
  }

  void _readVersion() async {
    await _packInfo.init();
    String versionInfo = _packInfo.version;
    _version = versionInfo;
    notifyListeners();
  }

  String get version => _version;

  void _getPrefs() async {
    await _sharedPrefs.init();
    _soundValor = _sharedPrefs.sound ?? true;
    //_modoValor = _sharedPrefs.modo ?? false;
    _modoValor = _sharedPrefs.modo ??
        modoOnline.keys
            .firstWhere((k) => modoOnline[k].contains(_sharedPrefs.nivel), orElse: () => false);
    //_nivelValor = _sharedPrefs.nivel ?? modoOnline[_modoValor].first;
    _nivelValor = modoOnline[_modoValor].contains(_sharedPrefs.nivel)
        ? _sharedPrefs.nivel
        : modoOnline[_modoValor].first;
    _victorias = _sharedPrefs.victorias ?? 0;
    _derrotas = _sharedPrefs.derrotas ?? 0;
    notifyListeners();
  }

  bool get soundPref => _sharedPrefs.sound ?? true;
  bool get modoPref => _sharedPrefs.modo ?? false;
  String get nivelPref => _sharedPrefs.nivel ?? modoOnline[modoPref].first;

  void resetValores() => _getPrefs();

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

  String get palabraSecreta => _palabraSecreta;

  set updateSecreta(String value) {
    _palabraSecreta = value;
    _palabraOculta = List<String>.generate(value.length, (i) => '_');
    notifyListeners();
  }

  String get pista => _pista;

  set updatePista(String value) {
    _pista = value;
    notifyListeners();
  }

  String get palabraOculta => _palabraOculta.join();

  void updateOculta(int index, String letra) {
    _palabraOculta[index] = letra;
    notifyListeners();
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

  int get errores => _errores;

  void sumaError() {
    _errores++;
    notifyListeners();
  }

  void resetAciertosErrores() {
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
    notifyListeners();
  }

  void resetPartida() {
    //_controlPalabra = true;
    //_aciertos = 0;
    _errores = 0;
    //_imagenHorca = horca;
    _palabraSecreta = null; //'';
    _pista = '';
    _palabraOculta = [];
    _letrasUsadas = [];
    _letrasUsadas.clear();
    notifyListeners();
  }
}
