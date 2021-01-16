import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home.dart';
import '../screens/juego.dart';
import '../provider/data.dart';
import '../utils/constantes.dart';
import '../utils/sonido.dart';

class DialogoOtra extends StatelessWidget {
  final GameOver gameOver;
  final Sound sonido;
  const DialogoOtra(this.gameOver, this.sonido);

  @override
  Widget build(BuildContext context) {
    Data _myProvider = Provider.of<Data>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _myProvider.buscando == true
          ? Center(child: CircularProgressIndicator())
          : WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Row(
                  children: [
                    Icon(gameOver.icono),
                    SizedBox(width: 10.0),
                    Text(gameOver.titulo),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (gameOver == GameOver.DERROTA)
                        Text('La palabra secreta era ${_myProvider.palabraSecreta}'),
                      Text('¿Otra partida?'),
                    ],
                  ),
                ),
                actions: [
                  FlatButton(
                    child: const Text('CANCELAR'),
                    onPressed: () {
                      if (_myProvider.soundValor == true) {
                        sonido.stop();
                      }
                      Navigator.pushNamed(context, Home.id);
                    },
                  ),
                  FlatButton(
                    child: const Text('ACEPTAR'),
                    onPressed: () async {
                      _myProvider.resetAciertosErrores();
                      await Juego().buscarPalabra(context, _myProvider);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
