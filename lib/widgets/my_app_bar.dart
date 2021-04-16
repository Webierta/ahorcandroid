import 'package:ahorcado/utils/constantes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:provider/provider.dart';

import '../models/ajustes_data.dart';
import '../routes.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  const MyAppBar({Key key, this.appBar}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Ahorcado'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            context.read<AjustesData>().getValores();
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            Navigator.of(context)?.pushNamed(RouteGenerator.ajustes);
          },
        ),
        PopupMenuButton<String>(
          color: Color(verdeOscuro),
          onSelected: (String value) {
            switch (value) {
              case 'Salir':
                SystemNavigator.pop();
                break;
              case 'Marcador':
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.of(context)?.pushNamed(RouteGenerator.marcador);
                break;
              case 'Info':
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.of(context)?.pushNamed(RouteGenerator.info);
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Marcador', 'Info', 'Salir'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
