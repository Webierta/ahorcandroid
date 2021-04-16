import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ajustes_data.dart';
import '../models/package_info_provider.dart';
import '../models/palabra_data.dart';
import '../routes.dart';
import '../utils/buscar_palabra.dart';
import '../utils/constantes.dart';
import '../widgets/diaolog_not_found.dart';
import '../widgets/my_app_bar.dart';

class Home extends StatelessWidget {
  const Home();

  @override
  Widget build(BuildContext context) {
    void _errorPalabra(BuildContext context) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('UNEXPECTED ERROR'),
          content: Text('Error al seleccionar la palabra secreta.\n'
              'Si se repite, elimina los datos almacenados, desinstala e instala la última versión.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context)?.pop(),
            )
          ],
        ),
      );
    }

    _onPlay(BuildContext context) async {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      context.read<PalabraData>()
        ..resetPartida()
        ..buscando = true;
      var control = true;
      await BuscarPalabra(context).init();
      if (context.read<PalabraData>().palabraNotFound()) {
        control = false;
        var respuesta = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => DialogoNotFound()));
        if (respuesta == false) {
          context.read<PalabraData>()
            ..buscando = false
            ..resetPartida();
        } else {
          context.read<AjustesData>()
            ..setPrefModo = false
            ..setPrefNivel = defaultNivel;
          await BuscarPalabra(context).init();
          control = true;
        }
      }
      if (context.read<PalabraData>().palabraSecreta == 'UNEXPECTED ERROR') {
        control = false;
        context.read<PalabraData>().resetPartida();
        _errorPalabra(context);
      }
      if (control) {
        await Navigator.of(context)
            ?.pushNamed(RouteGenerator.juego)
            ?.then((value) => context.read<PalabraData>().buscando = false);
      }
    }

    return Scaffold(
      appBar: MyAppBar(appBar: AppBar()),
      body: Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: context.watch<PalabraData>().buscando == true
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'EL AHORCADO',
                              style: TextStyle(
                                fontFamily: 'Tiza',
                                fontSize: 28.0,
                                color: Colors.white, //Color(0xFF616161),
                              ),
                            ),
                          ),
                        ),
                        LayoutBuilder(builder: (BuildContext context, BoxConstraints sizes) {
                          return Wrap(
                            direction: sizes.maxWidth > 600 ? Axis.horizontal : Axis.vertical,
                            spacing: 10.0,
                            children: [
                              Image.asset(
                                'assets/images/icon128.png',
                                scale: sizes.maxWidth > 600 ? 1.5 : 1,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: sizes.maxWidth > 600 ? 20 : 0),
                                  Consumer<PackageInfoProvider>(
                                    builder: (_, value, __) => Text(
                                        'Version: ${value.version}\nCopyleft 2019-2021\nJesús Cuerda',
                                        textAlign: sizes.maxWidth > 600
                                            ? TextAlign.left
                                            : TextAlign.center),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                        ElevatedButton.icon(
                          onPressed: () => _onPlay(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            primary: Color(pizarra),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
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
                                  fontSize: 24.0,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              Consumer<AjustesData>(
                                builder: (_, value, __) => Text(
                                  'Nivel: ${value.nivelPref}',
                                  style: TextStyle(
                                    //fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
