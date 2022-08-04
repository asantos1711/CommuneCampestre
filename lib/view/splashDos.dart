import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/usuario_bloc.dart';
import 'login.dart';

class SplashDos extends StatefulWidget {
  //const SplashDos({ Key? key }) : super(key: key);

  @override
  State<SplashDos> createState() => _SplashDosState();
}

class _SplashDosState extends State<SplashDos> {
  double? w, h;

  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      SingleChildScrollView(
          //padding: EdgeInsets.only(left:44, right:44),
          child: Container(
        height: h,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: 44, top: 55),
              child: Image.network(
                  _usuarioBloc.miFraccionamiento.urlLogopng.toString(),
                  width: w! * .5),
              /*Image.asset(
                  'assets/images/logo.png',
                )*/
            ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 44, right: 44, top: h! / 10),
                margin: EdgeInsets.only(top: 50),
                child: Text("Administre sus visitas",
                    style: TextStyle(fontSize: 50, color: Colors.black))),
            Container(
                padding: EdgeInsets.only(left: 44, right: 44),
                child: Text(
                  "Acceso y organización de visitas y eventos en pocos pasos",
                  style: TextStyle(
                      fontSize: 22, color: Color.fromRGBO(65, 63, 67, 0.5)),
                )),
          ],
        ),
      )),
      Positioned(
          //top: 30,
          bottom: 0,
          left: 0,
          right: 0,
          //left: 30,
          //height:250,
          //width: 250,
          child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Container(
                  width: 350,
                  height: 220,
                  margin: EdgeInsets.only(left: 170),
                  //alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                        255,
                        _usuarioBloc.miFraccionamiento.color!.r,
                        _usuarioBloc.miFraccionamiento.color!.g,
                        _usuarioBloc.miFraccionamiento.color!.b),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(120),
                      topRight: Radius.circular(120),
                      bottomLeft: Radius.circular(120),
                      //bottomRight: Radius.circular(150),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SIGUIENTE",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Icon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.white,
                      )
                    ],
                  ))))
    ]));
  }
}
