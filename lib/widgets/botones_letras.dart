import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/data.dart';
import '../utils/constantes.dart';
import '../utils/sonido.dart';
import '../widgets/dialogo_otra.dart';

class BotonesLetras extends StatelessWidget {
  const BotonesLetras({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orientacion = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    //final double itemWidth = size.width / 2;
    final double paddingTop = MediaQuery.of(context).padding.top;
    final double itemHeight = (size.height - paddingTop) / 2;
    final double itemWidth = size.width / 2;

    Data _myProvider = Provider.of<Data>(context);
    Sound sonido = Sound();

    List<String> listaLetras = letras.split('');
    List<Widget> teclas = [];
    listaLetras.forEach((key) {
      teclas.add(
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: RaisedButton(
            disabledColor: Colors.grey,
            disabledTextColor: Colors.white,
            splashColor: Color(accent),
            onPressed: _myProvider.letrasUsadas.contains(key)
                ? null
                : () async {
                    _myProvider.updateLetrasUsadas(key);
                    if (_myProvider.palabraSecreta.contains(key)) {
                      for (int index = 0; index < _myProvider.palabraSecreta.length; index++) {
                        if (key == _myProvider.palabraSecreta[index]) {
                          _myProvider.updateOculta(index, key);
                        }
                      }

                      if (_myProvider.palabraOculta == _myProvider.palabraSecreta) {
                        _myProvider.sumaVictoria();
                        if (_myProvider.soundValor == true) {
                          sonido.play(Archivo.victoria.file);
                        }
                        showDialog(
                          context: context,
                          builder: (context) => DialogoOtra(victoria, sonido),
                        );
                      } else {
                        if (_myProvider.soundValor == true) {
                          sonido.play(Archivo.acierto.file);
                        }
                      }
                    } else {
                      _myProvider.sumaError();
                      if (_myProvider.errores == 6) {
                        if (_myProvider.soundValor == true) {
                          await sonido.play(Archivo.error.file);
                          await Future.delayed(Duration(seconds: 1));
                          await sonido.play(Archivo.derrota.file);
                        }
                        await Future.delayed(Duration(milliseconds: 900)); //????
                        _myProvider.sumaDerrota();
                        showDialog(
                          context: context,
                          builder: (context) => DialogoOtra(derrota, sonido),
                        );
                      } else {
                        if (_myProvider.soundValor == true) {
                          sonido.play(Archivo.error.file);
                        }
                      }
                    }
                  },
            child: Text(
              key,
              textAlign: TextAlign.center,
            ),
            color: Colors.grey[200],
          ),
        ),
      );
    });
    return Container(
      alignment: orientacion == Orientation.portrait ? Alignment.bottomCenter : Alignment.center,
      color: Color(verdeOscuro),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: orientacion == Orientation.portrait ? 0.0 : paddingTop),
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: orientacion == Orientation.portrait ? 9 : 3,
        childAspectRatio: orientacion == Orientation.portrait ? 1 / 1 : (itemWidth / itemHeight),
        children: teclas,
      ),
    );
  }
}
