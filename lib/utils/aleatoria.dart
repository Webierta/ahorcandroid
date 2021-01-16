import 'dart:async';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math' show Random;
import 'package:diacritic/diacritic.dart';
import 'package:list_spanish_words/list_spanish_words.dart';

class Aleatoria {
  final String nivel;
  Aleatoria(this.nivel);

  String _url;
  String _palabra;
  String _pista;
  final random = Random();

  init() async {
    switch (nivel) {
      case 'Temas':
        await palabraLocal();
        break;
      case 'Avanzado':
        _url = 'https://www.palabrasaleatorias.com/?fs=1&fs2=0&Submit=Nueva+palabra';
        //_url = 'https://www.aleatorios.com/?fs=1&fs2=0&Submit=Nueva+palabra';
        await palabraWeb(_url);
        break;
      case 'Junior':
        _url = 'https://www.palabrasaleatorias.com/?fs=1&fs2=1&Submit=Nueva+palabra';
        //_url = 'https://www.aleatorios.com/?fs=1&fs2=1&Submit=Nueva+palabra';
        await palabraWeb(_url);
        break;
      case 'Experto':
        await listSpanishWords();
        //listSpanishWords().then((word) => _palabra = word);
        break;
      default:
        await palabraLocal();
    }
  }

  /*<table border="1" align="center" style="border: #001 2px dotted; text-align:center;" >
    <tr>
    <td align="center" style="margin:15px;padding:15px; margin-top:5px">
    <br /><div style="font-size:3em; color:#6200C5;">
    Elegante</div>*/

  Future<void> palabraWeb(String url) async {
    try {
      var response = await http.Client().get(Uri.parse(url));
      //var response = await http.Client().get(url);
      if (response.statusCode == 200) {
        // var html = parse(response.body);
        var html = parse(utf8.decode(response.bodyBytes));
        //List<Element> divs = html.querySelectorAll('div');
        Element elemento = html.getElementsByTagName('div').last;
        String palabra = _validar(elemento.text);
        if (palabra == null) {
          throw Exception();
        }
        _palabra = palabra;
      } else {
        throw Exception();
      }
    } catch (e) {
      _palabra = null;
    }
  }

  String _validar(String palabra) {
    String valida = palabra.trim();
    if (valida.contains(' ')) {
      return null;
    }
    valida = removeDiacritics(valida);
    valida = valida.toUpperCase();
    valida = valida.replaceAll(RegExp('[0-9]'), '');
    valida = valida.replaceAll(RegExp('[^A-ZÑ]'), '');
    if (valida.length < 3 || valida.length > 12) {
      return null;
    }
    return valida;
  }

  Future _waitLista() => Future(() {
        final completer = Completer();
        int indexRandom = random.nextInt(630000);
        completer.complete(list_spanish_words.sublist(indexRandom, indexRandom + 1).join('\n'));
        return completer.future;
      });

  listSpanishWords() async {
    /* try {
      int indexRandom = random.nextInt(630000);
      String word = _validar(list_spanish_words.sublist(indexRandom, indexRandom + 1).join('\n'));
      if (word == null) {
        throw Exception();
      }
      _palabra = word;
    } catch (e) {
      _palabra = null;
    } */
    var wordLista = await _waitLista();
    var word = _validar(wordLista);
    _palabra = word;
  }

  Future<void> palabraLocal() async {
    String jsonString;
    try {
      jsonString = await rootBundle.loadString('assets/files/vocabulario.json');
      final jsonResponse = await json.decode(jsonString);
      var vocabulario = jsonResponse[jsonResponse.keys.toList().join()];
      //List<String> keys = vocabulario[0].keys.toList();
      int objetoRandom = random.nextInt(vocabulario.length);
      //String categoria = vocabulario[objetoRandom]['CATEGORIA'];
      /* var categorias = [];
              for (int i = 0; i < vocabulario.length; i++) {
              categorias.add(vocabulario[i]['CATEGORIA']);
              }
              String categoriaRandom = categorias[random.nextInt(categorias.length)];*/
      _pista = vocabulario[objetoRandom]['PISTA'];
      List<String> palabras = [];
      for (var palabra in vocabulario[objetoRandom]['PALABRAS']) {
        palabras.add(palabra);
      }
      String palabra = palabras[random.nextInt(palabras.length)];
      _palabra = palabra ?? 'UNEXPECTED ERROR';
    } catch (e) {
      _palabra = 'UNEXPECTED ERROR';
    }
  }

  String get palabra => _palabra;

  String get pista => _pista;
}
