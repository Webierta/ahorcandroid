import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ajustes_data.dart';
import '../models/marcador_data.dart';
import '../models/palabra_data.dart';
import '../utils/constantes.dart';
import '../widgets/botones_letras.dart';

class Juego extends StatelessWidget {
  const Juego();

  @override
  Widget build(BuildContext context) {
    var orientacion = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Color(pizarra),
      floatingActionButton: context.watch<AjustesData>().nivelPref == defaultNivel
          ? FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Pista'),
                      content: Text('${context.watch<PalabraData>().pista}'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Volver al juego'),
                          onPressed: () => Navigator.of(context)?.pop(),
                        )
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.help_outline),
            )
          : null,
      floatingActionButtonLocation: orientacion == Orientation.portrait
          ? FloatingActionButtonLocation.endTop
          : FloatingActionButtonLocation.centerTop,
      body: Builder(
        builder: (context) => orientacion == Orientation.portrait
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0, bottom: 10.0),
                      child: ImgHorca(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: PalabraOculta(),
                  ),
                  BotonesLetras(),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: const [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.0),
                            child: ImgHorca(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                          child: PalabraOculta(),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: BotonesLetras()),
                ],
              ),
      ),
    );
  }
}

class ImgHorca extends StatelessWidget {
  const ImgHorca({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int error = 0; error < 7; error++)
          AnimatedOpacity(
            opacity: context.watch<MarcadorData>().errores >= error ? 1.0 : 0.0,
            duration: Duration(
              milliseconds: context.watch<MarcadorData>().errores >= error ? 800 : 0,
            ),
            child: Image.asset('assets/images/img${error + 1}.png'),
          )
      ],
    );
  }
}

class PalabraOculta extends StatelessWidget {
  const PalabraOculta({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      //fit: BoxFit.contain, //fitWidth, // fill
      child: Text(
        context.watch<PalabraData>().unexpectedError()
            ? 'UNEXPECTED ERROR'
            : context.watch<PalabraData>().palabraOculta,
        style: TextStyle(
          fontFamily: 'Tiza',
          color: Colors.white,
          fontSize: 34.0,
          letterSpacing: 10.0,
        ),
      ),
    );
  }
}
