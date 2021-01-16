import 'package:ahorcado/utils/constantes.dart';
import 'package:flutter/material.dart';

class DialogoNotFound extends StatelessWidget {
  const DialogoNotFound({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(pizarra),
      body: WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Fallo de conexión'),
          content: Text('No ha sido posible seleccionar ninguna palabra. '
              'Es posible que la conexión a internet haya fallado.\n'
              '¿Cambiar al modo Temas sin internet?'),
          actions: [
            FlatButton(
              child: const Text('VOLVER'),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: const Text('ACEPTAR'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}
