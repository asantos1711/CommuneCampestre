import 'package:campestre/view/menuInicio.dart';
import 'package:campestre/view/registroAsociados.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AjustesView extends StatefulWidget {
  const AjustesView({ Key? key }) : super(key: key);

  @override
  State<AjustesView> createState() => _AjustesViewState();
}

class _AjustesViewState extends State<AjustesView> {
  ShapeBorder _customBorder = CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistroAsociados()),
                );
              },
              child: _opcion(FontAwesomeIcons.squarePlus, "Añadir cuentas asociadas"),
            ),
           
          ],
        ),
      ),
    );
  }

  _opcion(IconData icono, String titulo) {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              icono,
              color: Color(0xff5E1281),
              size: 28,
            ),
            title: Text(
              titulo,
              style: TextStyle(fontSize: 18, color: Color(0xff1A1C3D)),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Color(0xff8F8F8F),
              size: 28,
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "Ajustes",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      leading: Container(
        child: Ink(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: InkWell(
            //child: Icon(FontAwesome.power_off, color: Colors.black, ),
            child: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black,
              size: 23,
            ),
            customBorder: _customBorder,
            splashColor: Color(0xff5E1281),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuInicio()),
              );
            },
          ),
        ),
      ),
    );
  }

}