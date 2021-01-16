import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/data.dart';
import '../utils/constantes.dart';

class Marcador extends StatelessWidget {
  static const String id = 'marcador';

  @override
  Widget build(BuildContext context) {
    Data _myProvider = Provider.of<Data>(context);
    return Scaffold(
      backgroundColor: Color(pizarra),
      appBar: AppBar(
        title: Text('Marcador'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => _myProvider.resetMarcador(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: FractionallySizedBox(heightFactor: 0.6),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'MARCADOR',
                  style: TextStyle(
                    fontFamily: 'Tiza',
                    fontSize: 28.0,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tarjeta(
                  Icon(
                    Icons.emoji_events,
                    color: Colors.grey[200],
                    size: 60.0,
                  ),
                  '${_myProvider.victorias}',
                ),
                Tarjeta(
                  ImageIcon(
                    AssetImage('assets/images/derrotas.png'),
                    color: Colors.grey[200],
                    size: 60.0,
                  ),
                  '${_myProvider.derrotas}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Tarjeta extends StatelessWidget {
  final Widget imagen;
  final String texto;

  Tarjeta(this.imagen, this.texto);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        elevation: 10.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(verdeOscuro),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: imagen,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                texto,
                style: TextStyle(
                  fontFamily: 'Tiza',
                  fontSize: 20.0,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
