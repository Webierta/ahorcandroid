import 'package:flutter/material.dart';

const String letras = 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';

const Map<bool, List<String>> modoOnline = {
  false: ['Temas', 'Experto'],
  true: ['Junior', 'Avanzado'],
};

const String defaultNivel = 'Temas';

//colores
const int verdeOscuro = 0xff013220;
const int pizarra = 0xff004D00;
const int accent = 0xffD81B60;
/*
<color name="colorPrimary">#008577</color>
<color name="colorPrimaryDark">#00574B</color>
<color name="colorAccent">#D81B60</color>
<color name="pizarra">#004D00</color>
*/

// GameOver
enum GameOver { VITORIA, DERROTA }

extension GameOverExtension on GameOver {
  static const titulos = {
    GameOver.VITORIA: '¡Victoria!',
    GameOver.DERROTA: '¡Ahorcado!',
  };

  String get titulo => titulos[this];

  static const iconos = {
    GameOver.VITORIA: Icons.military_tech,
    GameOver.DERROTA: Icons.gavel,
  };

  IconData get icono => iconos[this];
}

const victoria = GameOver.VITORIA;
const derrota = GameOver.DERROTA;
