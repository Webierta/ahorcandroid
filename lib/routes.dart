import 'package:flutter/material.dart';

import 'screens/ajustes.dart';
import 'screens/home.dart';
import 'screens/info.dart';
import 'screens/juego.dart';
import 'screens/marcador.dart';

class RouteGenerator {
  static const String home = '/';
  static const String juego = '/juego';
  static const String ajustes = '/ajustes';
  static const String marcador = '/marcador';
  static const String info = '/info';

  RouteGenerator();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case juego:
        return MaterialPageRoute(builder: (_) => const Juego());
      case ajustes:
        return MaterialPageRoute(builder: (_) => const Ajustes());
      case marcador:
        return MaterialPageRoute(builder: (_) => const Marcador());
      case info:
        return MaterialPageRoute(builder: (_) => const Info());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Route not found'),
        ),
      );
    });
  }
}
