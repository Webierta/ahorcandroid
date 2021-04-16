import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

class Info extends StatelessWidget {
  const Info();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
        actions: const [BotonCafe()],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Text(
          textoInfo,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class BotonCafe extends StatelessWidget {
  const BotonCafe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.free_breakfast),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: Builder(
              builder: (context) => const DialogoInfo(),
            ),
          ),
        );
      },
    );
  }
}

class DialogoInfo extends StatelessWidget {
  const DialogoInfo({Key key}) : super(key: key);

  static const String bitcoinAdress = '15ZpNzqbYFx9P7wg4U438JMwZr2q3W6fkS';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Apoya esta aplicación'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pulsa el botón para copiar la dirección Bitcoin:'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    padding: EdgeInsets.all(10.0),
                    primary: Colors.green[900],
                  ),
                  child: const Text(
                    bitcoinAdress,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: bitcoinAdress)).then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bitcoin Address copied to Clipboard')),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text('El Ahorcado es Software libre sin publicidad. '
                'Puedes colaborar con el desarrollo de ésta y otras aplicaciones '
                'con una pequeña aportación a mi monedero de Bitcoins.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cerrar'),
          onPressed: () => Navigator.of(context)?.pop(),
        )
      ],
    );
  }
}

const String textoInfo = '''
EL JUEGO DEL AHORCADO

Esta aplicación revive el clásico juego de lápiz y papel "El Ahorcado" cuyo objetivo es descubrir una palabra secreta.

Para ello, el programa propone una palabra al azar obtenida de la web o de su propio almacén de palabras, dependiendo del modo o nivel de juego seleccionado.

OPCIONES

Desde el menú «Ajustes» se pueden cambiar algunas opciones del juego.

La aplicación dispone de 4 niveles organizados en 2 modos de juego:
- Offline: Temas y Experto.
- Online: Júnior y Avanzado.

En los niveles «Júnior» y «Avanzado» se genera una palabra aleatoria online. El nivel «Avanzado» utiliza una base de unas 4.000 palabras mientras que el modo «Júnior» utiliza un listado reducido de unas 500 palabras más fáciles para niños.

Los niveles «Temas» y «Experto» extraen la palabra al azar desde sus respectivas bases de palabras, por lo que no requieren conexión a internet.

En el nivel «Temas» las palabras (unas 600) están clasificadas en diversas temáticas o categorías (animales, colores, flores, elementos químicos, alimentos, profesiones, ciudades, películas, etc.) y se ofrece la posibilidad de solicitar una pista sobre la palabra secreta. Cuando alguno de los otros niveles falla (por ejemplo por caída del servidor o por desconexión a internet) se activa automáticamente el nivel «Temas».

El nivel «Experto» contiene una extensa base de palabras (en torno a 640.000 palabras), incluidas numerosas formas verbales, lo que aumenta considerablemente la dificultad.

También se pueden activar o desactivar los efectos sonoros de la aplicación.

Estas opciones (Sonido, Modo y Nivel) quedan grabadas en la aplicación y se aplicarán a las nuevas partidas hasta que sean modificadas.

ACERCA DE

Copyleft 2019-2021 - Jesús Cuerda (Webierta)- Todos los errores reservados.

Web del proyecto: https://github.com/Webierta/ahorcandroid

Aplicación gratuita y sin publicidad. Colabora con un donativo para un café en mi monedero de Bitcoin ¡gracias!

Software libre de código abierto sujeto a la GNU General Public License v.3, distribuido con la esperanza de que sea entretenido, pero SIN NINGUNA GARANTÍA. Todos los errores reservados.

REQUISITOS Y PERMISOS

- Android 5.0 o superior.  
- Permiso de conexión a internet (para buscar palabras). Es posible jugar sin conexión a internet en los niveles «Temas» y «Experto».

RECONOCIMIENTOS Y DEPENDENCIAS

- Banco de imágenes y sonidos del Instituto de Tecnologías Educativas (CC BY-NC-SA 3.0). Ministerio de Educación.
- Generador de palabras aleatorias online: palabrasaleatorias.com. 
- Packages de Flutter y Dart: assets_audio_player (Copyright 2019 Florent37), diacritic (Copyright 2016, Agilord), shared_preferences (Copyright 2017 The Chromium Authors), provider (Copyright 2019 Remi Rousselet), package_info (Copyright 2017 The Chromium Authors), html (Copyright 2006-2012 The Authors), http (Copyright 2014, the Dart project authors), list_spanish_words (Copyright 2020 Alessandro Maclaine).

LICENCIA

Copyleft 2019-2021, Jesús Cuerda Villanueva. All Wrongs Reserved.

Software libre de código abierto sujeto a la GNU General Public License v.3. EL AHORCADO es software libre distribuido con la esperanza de que sea útil, pero SIN NINGUNA GARANTÍA.

This file is part of EL AHORCADO. EL AHORCADO is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation either version 3 of the License.

EL AHORCADO is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. https://www.gnu.org/licenses/gpl-3.0.txt
''';
