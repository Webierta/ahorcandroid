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
enum GameOver { victoria, derrota }

extension GameOverExtension on GameOver {
  static const titulos = {
    GameOver.victoria: '¡Victoria!',
    GameOver.derrota: '¡Ahorcado!',
  };

  String get titulo => titulos[this];

  static const iconos = {
    GameOver.victoria: Icons.military_tech,
    GameOver.derrota: Icons.gavel,
  };

  IconData get icono => iconos[this];
}

const victoria = GameOver.victoria;
const derrota = GameOver.derrota;
