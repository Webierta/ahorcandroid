import 'dart:ui';

import 'package:ahorcado/utils/constantes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './utils/constantes.dart';
import 'models/ajustes_data.dart';
import 'models/marcador_data.dart';
import 'models/package_info_provider.dart';
import 'models/palabra_data.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final packageInfoProvider = PackageInfoProvider()..initPackageInfo();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => packageInfoProvider),
      ChangeNotifierProvider(create: (BuildContext context) => PalabraData()),
      ChangeNotifierProvider(create: (BuildContext context) => MarcadorData()),
      ChangeNotifierProvider(create: (BuildContext context) => AjustesData()),
    ],
    child: const Ahorcado(),
  ));
}

class Ahorcado extends StatelessWidget {
  const Ahorcado({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(verdeOscuro),
        scaffoldBackgroundColor: const Color(0xFF4D6B53),
        dialogBackgroundColor: const Color(0xFF4D6B53),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: const Color(0xFFCDDBCF)),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: RouteGenerator.home,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
