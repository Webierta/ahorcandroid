import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/data.dart';
import 'screens/home.dart';
import 'screens/info.dart';
import 'screens/ajustes.dart';
import 'screens/juego.dart';
import 'screens/marcador.dart';
import './utils/constantes.dart';
import 'package:ahorcado/utils/constantes.dart';

void main() => runApp(Ahorcado());

class Ahorcado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Data(),
      child: Consumer<Data>(builder: (context, data, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(verdeOscuro),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Home(),
          routes: {
            Home.id: (context) => Home(),
            Juego.id: (context) => Juego(),
            Ajustes.id: (context) => Ajustes(),
            Marcador.id: (context) => Marcador(),
            Info.id: (context) => Info(),
          },
        );
      }),
    );
  }
}
