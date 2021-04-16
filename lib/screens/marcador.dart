import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/marcador_data.dart';
import '../utils/constantes.dart';

class Marcador extends StatelessWidget {
  const Marcador();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => context.read<MarcadorData>().resetMarcador(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Flexible(child: FractionallySizedBox(heightFactor: 0.6)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'MARCADOR',
                  style: TextStyle(
                    fontFamily: 'Tiza',
                    fontSize: 28.0,
                    color: Color(0xFFE0E0E0), // Colors.grey[300],
                  ),
                ),
              ),
            ),
            const Flexible(child: FractionallySizedBox(heightFactor: 0.2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tarjeta(
                  const Icon(
                    Icons.emoji_events,
                    color: Color(0xFFEEEEEE), //Colors.grey[200],
                    size: 60.0,
                  ),
                  '${context.watch<MarcadorData>().victorias}',
                ),
                Tarjeta(
                  const ImageIcon(
                    AssetImage('assets/images/derrotas.png'),
                    color: Color(0xFFEEEEEE), //Colors.grey[200],
                    size: 60.0,
                  ),
                  '${context.watch<MarcadorData>().derrotas}',
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

  const Tarjeta(this.imagen, this.texto);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        elevation: 10.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color(verdeOscuro),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
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
              padding: const EdgeInsets.all(20.0),
              child: Text(
                texto,
                style: const TextStyle(
                  fontFamily: 'Tiza',
                  fontSize: 20.0,
                  color: Color(0xFFE0E0E0), //Colors.grey[300],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
