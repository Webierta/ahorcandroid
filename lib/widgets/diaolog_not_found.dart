import 'package:ahorcado/utils/constantes.dart';
import 'package:flutter/material.dart';

class DialogoNotFound extends StatelessWidget {
  const DialogoNotFound({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(pizarra),
      body: WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('Fallo de conexión'),
          content: const Text('No ha sido posible seleccionar ninguna palabra. '
              'Es posible que la conexión a internet haya fallado.\n'
              '¿Cambiar al modo Temas sin internet?'),
          actions: [
            TextButton(
              child: const Text('Volver'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}
