import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:provider/provider.dart';

import '../provider/data.dart';
import '../screens/ajustes.dart';
import '../screens/marcador.dart';
import '../screens/info.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  const MyAppBar({Key key, this.appBar}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    Data _myProvider = Provider.of<Data>(context);

    return AppBar(
      title: Text('Ahorcado'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            _myProvider.resetValores();
            Scaffold.of(context).removeCurrentSnackBar();
            Navigator.pushNamed(context, Ajustes.id);
          },
        ),
        PopupMenuButton<String>(
          onSelected: (String value) {
            switch (value) {
              case 'Salir':
                SystemNavigator.pop();
                break;
              case 'Marcador':
                Scaffold.of(context).removeCurrentSnackBar();
                Navigator.pushNamed(context, Marcador.id);
                break;
              case 'Info':
                Scaffold.of(context).removeCurrentSnackBar();
                Navigator.pushNamed(context, Info.id);
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
