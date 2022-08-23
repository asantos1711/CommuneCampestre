import 'package:campestre/view/menuInicio.dart';
import 'package:campestre/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:campestre/view/login.dart';

import '../view/seleccionFraccionamiento.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (context) => LoginPage(), // Splash(),
    'inicio_sesion': (context) => LoginPage(),
    'menu_inicio': (context) => MenuInicio(),
  };
}

List<BottomNavigationBarItem> navButtons() {
  return [
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.house),
      label: 'Inicio',
      activeIcon: FaIcon(FontAwesomeIcons.house),
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.users),
      label: "Perfil",
      activeIcon: FaIcon(FontAwesomeIcons.users),
    ),
    /* BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.signOutAlt),
            title: Text('Logout'),
            activeIcon: FaIcon(FontAwesomeIcons.signOutAlt),
            )*/
  ];
}

void action(int index, context) {
  switch (index) {
    case 0:
      {
        Navigator.pushReplacementNamed(context, '/viewPerfil');
      }
      break;
    case 1:
      {
        Navigator.pushReplacementNamed(context, '/home');
      }
      break;
    /*case 2:{
          AuthenticationServices.getInstance().signOut();
          Navigator.pushReplacementNamed(context, '/landing');
          print(index);}break;*/
  }
}
