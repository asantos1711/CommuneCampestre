import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:campestre/widgets/ui_helper.dart';
import 'dart:math' as math;
import 'package:campestre/widgets/autenticacion.dart';

class ConfigView extends StatefulWidget {
  @override
  _ConfigViewState createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  double? w, h;
  bool? da, isIpad = false;

  UIHelper u = new UIHelper();
  TextEditingController mail = TextEditingController();
  UIHelper _uIHelper = new UIHelper();
  @override  

  

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;    

    return Scaffold(
      bottomNavigationBar: u.bottomBar(h, w!, 2, context),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
            Container(
              width: w! - 50,
              // height: 800,
              margin: EdgeInsets.only(top: h! / 40, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500]!,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 10.0,
                    ),
                  ],
                border: Border.all(width: 1, style: BorderStyle.none),
                borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    width: w! - 70,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  _legal(),
                  SizedBox(
                    height: 10,
                  ),                  
                  
                  _reportar(),
                  SizedBox(
                    height: 10,
                  ),
                  _agregarEmpleados(),
                  SizedBox(
                    height: 10,
                  ),
                  _cerrarsesion(),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  

  _cerrarsesion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        tileColor: Colors.white,
        title: Text("Cerrar Sesión",         
          style: TextStyle(fontSize: 16, color: Color(0xFF292929)),
        ),
        leading: Transform.rotate(
          angle: 180 * math.pi / 180,
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.rightFromBracket,
              color: Colors.black,
            ),
            onPressed: null,
          ),
        ),
        onTap: () {
          AuthenticationServices.getInstance().signOut();   
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false); //(context, '/login')      
         /* registro.perfil = null;
          _pref.email = "";
          _pref.psw = "";
          AuthenticationServices.getInstance().signOut();
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Inicio(),
                transitionDuration: Duration(seconds: 0),
              ),
              (route) => false);
          /*Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false); //(context, '/login');*/*/
        },
      ),
    );
  }

  /*_idioma() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: DropIdioma(
          fontSize: 16,
        ));
  }*/
  

  _reportar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        tileColor: Colors.white,
        title: Text("Reportar problema",
          //Translations.of(context).text("reportar"),
          style: TextStyle(fontSize: 16, color: Color(0xFF292929)),
        ),
        leading: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.black,
        ),
        onTap: () async {
         /* if (await canLaunch("https://wa.link/vlw4ig")) {
            await launch("https://wa.link/vlw4ig");
          } else {
            print("no se puede");
          }*/

          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportarProblema()),
          );*/
        },
      ),
    );
  }

  _agregarEmpleados() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        tileColor: Colors.white,
        title: Text("Agregar empleados",
         // Translations.of(context).text("escribenos"),
          style: TextStyle(fontSize: 16, color: Color(0xFF292929)),
        ),
        leading: Icon(
          FontAwesome5Solid.users,
          color: Colors.black,
        ),
        onTap: () async {
         /* if (await canLaunch("https://wa.link/iwi8x3")) {
            await launch("https://wa.link/iwi8x3");
          } else {
            print("no se puede");
          }*/
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Escribenos()),
          );*/
        },
      ),
    );
  }

  _legal() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(
          "Legal",
          //Translations.of(context).text("aviso_privacidad"),
          style: TextStyle(fontSize: 16, color: Color(0xFF292929)),
        ),
        leading: Icon(
          FontAwesomeIcons.shieldHalved,
          color: Colors.black,
        ),
        onTap: () async {
          /*url = _configBloc.configuracion
              .urlPoliticas; //"https://www.linkcards.mx/politica-de-privacidad/";
          if (await canLaunch(url)) {
            await launch(url);
          }*/
        },
      ),
    );
  }  
}
