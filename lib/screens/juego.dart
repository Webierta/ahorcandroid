import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/data.dart';
import '../utils/constantes.dart';
import '../utils/aleatoria.dart';
import '../widgets/botones_letras.dart';

class Juego extends StatelessWidget {
  static const String id = 'juego';

  Future<void> buscarPalabra(BuildContext context, Data myProvider) async {
    myProvider.buscando = true;
    Aleatoria aleatoria;
    int intentos = 0;
    do {
      aleatoria = Aleatoria(myProvider.nivelPref);
      await aleatoria.init();
      if (aleatoria.palabra != null) {
        myProvider.updateSecreta = aleatoria.palabra;
        //myProvider.ocultaInicial(aleatoria.palabra);
        myProvider.resetAciertosErrores();
        myProvider.resetLetrasUsadas();
        //_myProvider.resetPartida();
        if (myProvider.nivelPref == defaultNivel) {
          myProvider.updatePista = aleatoria.pista;
        }
        myProvider.buscando = false;
        break;
      }
      intentos++;
    } while (intentos < 3);
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientacion = MediaQuery.of(context).orientation;
    Data _myProvider = Provider.of<Data>(context);

    return Scaffold(
      backgroundColor: Color(pizarra),
      floatingActionButton: _myProvider.nivelPref == defaultNivel
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
                      content: Text(_myProvider.pista),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Volver al juego'),
                          onPressed: () => Navigator.of(context).pop(),
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
      body: orientacion == Orientation.portrait
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0, bottom: 10.0),
                    child: const ImgHorca(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: const PalabraOculta(),
                ),
                const BotonesLetras(),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: ImgHorca(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                        child: const PalabraOculta(),
                      ),
                    ],
                  ),
                ),
                Expanded(child: BotonesLetras()),
              ],
            ),
    );
  }
}

class ImgHorca extends StatelessWidget {
  const ImgHorca({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Data _myProvider = Provider.of<Data>(context);
    return Stack(
      children: [
        for (int error = 0; error < 7; error++)
          AnimatedOpacity(
            opacity: _myProvider.errores >= error ? 1.0 : 0.0,
            duration: Duration(milliseconds: _myProvider.errores >= error ? 800 : 0),
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
    Data _myProvider = Provider.of<Data>(context);
    return FittedBox(
      //fit: BoxFit.contain, //fitWidth, // fill
      child: Text(
        (_myProvider.palabraOculta.isEmpty || _myProvider.palabraOculta == null)
            ? 'UNEXPECTED ERROR'
            : _myProvider.palabraOculta,
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
