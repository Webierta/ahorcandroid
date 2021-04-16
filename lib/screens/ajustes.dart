import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ajustes_data.dart';
import '../utils/constantes.dart';

class Ajustes extends StatelessWidget {
  const Ajustes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajustes')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sonido'),
                  Switch(
                    value: context.watch<AjustesData>().soundValor,
                    onChanged: (bool value) => context.read<AjustesData>().updateSound = value,
                    activeTrackColor: Color(pizarra),
                    activeColor: Colors.greenAccent[400],
                  ),
                ],
              ),
              Divider(color: Colors.grey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Modo online'),
                  Switch(
                    value: context.watch<AjustesData>().modoValor,
                    onChanged: (bool value) => context.read<AjustesData>().updateModo = value,
                    activeTrackColor: Color(pizarra),
                    activeColor: Colors.greenAccent[400],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nivel'),
                  DropdownButton<String>(
                    dropdownColor: Color(verdeOscuro),
                    value: context.watch<AjustesData>().nivelValor ??
                        modoOnline[context.watch<AjustesData>().modoValor].first,
                    items: modoOnline[context.watch<AjustesData>().modoValor]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) => context.read<AjustesData>().updateNivel = value,
                  ),
                ],
              ),
              Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    primary: Color(pizarra),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                  onPressed: () {
                    context.read<AjustesData>()
                      ..setPrefSound = context.read<AjustesData>().soundValor
                      ..setPrefModo = context.read<AjustesData>().modoValor
                      ..setPrefNivel = context.read<AjustesData>().nivelValor;
                    Navigator.of(context)?.pop();
                  },
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text(
                    'Guardar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
