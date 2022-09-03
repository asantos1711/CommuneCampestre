import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/view/splashDos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controls/connection.dart';
import '../models/fraccionamientos.dart';
import '../models/preferenciasUsuario.dart';

class Splash extends StatefulWidget {
  //const Splash({ Key? key }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  double? w, h;
  late PreferenciasUsuario usuario;

  DatabaseServices databaseServices = new DatabaseServices();

  @override
  void initState() {
    // TODO: implement initState
    // _setFraccionamiento();
    // _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: FutureBuilder(
      future: DatabaseServices.getFraccionamiento(),
      builder: (c, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Stack(children: [
          SingleChildScrollView(
              //padding: EdgeInsets.only(left:44, right:44),
              child: Container(
            height: h,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(right: 44, top: 55),
                  child: Image.network(
                      _usuarioBloc.miFraccionamiento.urlLogopngColor.toString(),
                      width: w! * .5),
                  /*Image.asset(
                  'assets/images/logo.png',
                )*/
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 44, right: 44, top: 40),
                    // margin: EdgeInsets.only(top: 50),
                    child: Text("Control de acceso",
                        style: TextStyle(fontSize: 50, color: Colors.black))),
                Container(
                    padding: EdgeInsets.only(left: 44, right: 44),
                    child: Text(
                      "Administre su pagos de mantenimiento y multas en un solo lugar",
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
                  onTap: () async {
                    PreferenciasUsuario preferenciasUsuario =
                        PreferenciasUsuario();
                    preferenciasUsuario.setisFirstTime(true);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SplashDos()),
                    );
                  },
                  child: Container(
                      width: 350,
                      height: 220,
                      margin: EdgeInsets.only(top: 30, left: 170),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                            255,
                            _usuarioBloc.miFraccionamiento.color!.r,
                            _usuarioBloc.miFraccionamiento.color!.g,
                            _usuarioBloc.miFraccionamiento.color!
                                .b), //Color(0xFF5E1281),
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
        ]);
      },
    ));
  }
}
