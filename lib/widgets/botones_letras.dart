import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ajustes_data.dart';
import '../models/marcador_data.dart';
import '../models/palabra_data.dart';
import '../routes.dart';
import '../utils/buscar_palabra.dart';
import '../utils/constantes.dart';
import '../utils/sonido.dart';

class BotonesLetras extends StatelessWidget {
  const BotonesLetras({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientacion = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    //final double itemWidth = size.width / 2;
    final paddingTop = MediaQuery.of(context).padding.top;
    final itemHeight = (size.height - paddingTop) / 2;
    final itemWidth = size.width / 2;
    final listaLetras = letras.split('');
    final sonido = Sound();

    void dialogoOtra(BuildContext context, GameOver gameOver) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: context.watch<PalabraData>().buscando == true
                ? const Center(child: CircularProgressIndicator())
                : AlertDialog(
                    title: Row(
                      children: [
                        Icon(gameOver.icono),
                        const SizedBox(width: 10.0),
                        Text(gameOver.titulo),
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (gameOver == GameOver.derrota)
                            Text(
                                'La palabra secreta era ${context.watch<PalabraData>().palabraSecreta}'),
                          const Text('¿Otra partida?'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('CANCELAR'),
                        onPressed: () {
                          if (context.read<AjustesData>().soundValor == true) {
                            sonido.stop();
                          }
                          Navigator.of(context)?.pushNamed(RouteGenerator.home);
                        },
                      ),
                      TextButton(
                        child: const Text('ACEPTAR'),
                        onPressed: () async {
                          context.read<MarcadorData>().resetErrores();
                          await BuscarPalabra(context).init();
                          Navigator.of(context)?.pop();
                        },
                      ),
                    ],
                  ),
          );
        },
      );
    }

    Future<void> pulsarLetra(BuildContext context, String key) async {
      context.read<PalabraData>().updateLetrasUsadas(key);
      if (context.read<PalabraData>().palabraSecreta.contains(key)) {
        /* METODO ORIGINAL: bucle for String
        for (var index = 0; index < context.read<PalabraData>().palabraSecreta.length; index++) {
          if (key == context.read<PalabraData>().palabraSecreta[index]) {
            context.read<PalabraData>().updateOculta(index, key);
          }
        } */
        context.read<PalabraData>().adivinarOculta(key);
        if (context.read<PalabraData>().palabraAdivinada()) {
          context.read<MarcadorData>().sumaVictoria();
          if (context.read<AjustesData>().soundValor == true) {
            await sonido.play(Archivo.victoria.file);
          }
          dialogoOtra(context, victoria);
        } else {
          if (context.read<AjustesData>().soundValor == true) {
            await sonido.play(Archivo.acierto.file);
          }
        }
      } else {
        context.read<MarcadorData>().sumaError();
        if (context.read<MarcadorData>().errores == 6) {
          if (context.read<AjustesData>().soundValor == true) {
            //await sonido.play(Archivo.error.file);
            //await Future.delayed(Duration(seconds: 1));
            await sonido.play(Archivo.derrota.file);
          }
          context.read<MarcadorData>().sumaDerrota();
          dialogoOtra(context, derrota);
        } else {
          if (context.read<AjustesData>().soundValor == true) {
            await sonido.play(Archivo.error.file);
          }
        }
      }
    }

    return Container(
      alignment: orientacion == Orientation.portrait ? Alignment.bottomCenter : Alignment.center,
      color: const Color(verdeOscuro),
      padding: const EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: orientacion == Orientation.portrait ? 0.0 : paddingTop),
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: orientacion == Orientation.portrait ? 9 : 3,
        childAspectRatio: orientacion == Orientation.portrait ? 1 / 1 : (itemWidth / itemHeight),
        children: List.generate(listaLetras.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed)) {
                    return Color(accent);
                  }
                  return Color(0xFFEEEEEE); //Colors.grey[200];
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.white;
                  }
                  return Colors.black;
                }),
              ),
              child: Text(listaLetras[index], textAlign: TextAlign.center),
              onPressed: context.watch<PalabraData>().letrasUsadas.contains(listaLetras[index])
                  ? null
                  : () => pulsarLetra(context, listaLetras[index]),
            ),
          );
        }),
      ),
    );
  }
}
