import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ajustes_data.dart';
import '../models/marcador_data.dart';
import '../models/palabra_data.dart';
import 'aleatoria.dart';
import 'constantes.dart';

class BuscarPalabra {
  final BuildContext context;

  const BuscarPalabra(this.context);

  Future<void> init() async {
    context.read<PalabraData>().buscando = true;
    Aleatoria aleatoria;
    var intentos = 0;
    do {
      aleatoria = Aleatoria(context.read<AjustesData>().nivelPref);
      await aleatoria.init();
      if (aleatoria.palabra != null) {
        context.read<PalabraData>()
          ..updateSecreta = aleatoria.palabra
          ..resetLetrasUsadas();
        context.read<MarcadorData>().resetErrores();
        if (context.read<AjustesData>().nivelPref == defaultNivel) {
          context.read<PalabraData>().updatePista = aleatoria.pista;
        }
        context.read<PalabraData>().buscando = false;
        break;
      }
      intentos++;
    } while (intentos < 3);
  }
}
