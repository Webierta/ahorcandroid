import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/data.dart';
import 'juego.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/diaolog_not_found.dart';
import '../utils/constantes.dart';

class Home extends StatelessWidget {
  static const String id = 'home';

  @override
  Widget build(BuildContext context) {
    Orientation orientacion = MediaQuery.of(context).orientation;
    Data _myProvider = Provider.of<Data>(context);

    List<Widget> _listaWidgets() {
      return [
        Image.asset(
          'assets/images/icon128.png',
          scale: orientacion == Orientation.portrait ? 1 : 1.5,
        ),
        Padding(
          padding: orientacion == Orientation.portrait
              ? EdgeInsets.only(top: 10.0)
              : EdgeInsets.only(left: 10.0),
          child: Text(
            'Version: ${_myProvider.version}\nCopyleft 2019-2021\nJesús Cuerda',
            textAlign: orientacion == Orientation.portrait ? TextAlign.center : TextAlign.left,
          ),
        ),
      ];
    }

    void _errorPalabra(context) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('UNEXPECTED ERROR'),
          content: Text('Error al seleccionar la palabra secreta.\n'
              'Si se repite, elimina los datos almacenados, desinstala e instala la última versión.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: MyAppBar(appBar: AppBar()),
      body: Builder(
        builder: (context) => Center(
          child: _myProvider.buscando == true
              ? WillPopScope(
                  onWillPop: () async => false,
                  child: Center(
                    child: CircularProgressIndicator(),
                    /*child: Text(
                      'Generando una palabra,\nespera un momento por favor...',
                      textAlign: TextAlign.center,
                    ),*/
                  ),
                )
              : Container(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'EL AHORCADO',
                                style: TextStyle(
                                  fontFamily: 'Tiza',
                                  fontSize: 28.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: orientacion == Orientation.portrait
                                ? Column(children: _listaWidgets())
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: _listaWidgets(),
                                  ),
                          ),
                          RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            color: Color(pizarra),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            onPressed: () async {
                              Scaffold.of(context).removeCurrentSnackBar();
                              _myProvider.resetPartida();
                              _myProvider.buscando = true;
                              bool control = true;
                              await Juego().buscarPalabra(context, _myProvider);
                              if (_myProvider.palabraSecreta == null ||
                                  _myProvider.palabraSecreta == '' ||
                                  _myProvider.palabraOculta == null ||
                                  (_myProvider.palabraOculta?.isEmpty ?? true)) {
                                control = false;
                                var respuesta = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DialogoNotFound()),
                                );
                                if (respuesta == false) {
                                  _myProvider.buscando = false;
                                  _myProvider.resetPartida();
                                } else {
                                  _myProvider.setPrefModo = false;
                                  _myProvider.setPrefNivel = defaultNivel;
                                  await Juego().buscarPalabra(context, _myProvider);
                                  control = true;
                                }
                              }

                              if (_myProvider.palabraSecreta == 'UNEXPECTED ERROR') {
                                control = false;
                                _myProvider.resetPartida();
                                _errorPalabra(context);
                              }

                              if (control) {
                                Navigator.pushNamed(context, Juego.id)
                                    .then((value) => _myProvider.buscando = false);
                              }
                            },
                            icon: Icon(
                              Icons.check_box,
                              color: Colors.white,
                              size: 60.0,
                            ),
                            label: Column(
                              children: [
                                Text(
                                  'JUGAR',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                Text(
                                  'Modo de Juego: ${_myProvider.nivelPref}',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
