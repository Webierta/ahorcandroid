import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/data.dart';
import '../utils/constantes.dart';

class Ajustes extends StatelessWidget {
  static const String id = 'ajustes';

  @override
  Widget build(BuildContext context) {
    Data _myProvider = Provider.of<Data>(context);
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
                    value: _myProvider.soundValor,
                    onChanged: (bool value) => _myProvider.updateSound = value,
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
                    value: _myProvider.modoValor,
                    onChanged: (bool value) => _myProvider.updateModo = value,
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
                    value: _myProvider.nivelValor ?? modoOnline[_myProvider.modoValor].first,
                    items: modoOnline[_myProvider.modoValor]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) => _myProvider.updateNivel = value,
                  ),
                ],
              ),
              Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RaisedButton.icon(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  color: Color(pizarra),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  onPressed: () {
                    _myProvider.setPrefSound = _myProvider.soundValor;
                    _myProvider.setPrefModo = _myProvider.modoValor;
                    _myProvider.setPrefNivel = _myProvider.nivelValor;
                    Navigator.pop(context);
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
