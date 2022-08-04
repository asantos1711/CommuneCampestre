import 'package:flutter/material.dart';

import '../bloc/usuario_bloc.dart';
import 'mudanza/visitasMudanzaPage..dart';
import 'paqueteria/visitasPaqueteriaPage.dart';
import 'regular/visitasRegularPage.dart';
import 'rentaVacacional/rentaVacacional.dart';
import 'trabajadores/visitasTrabajadoresPage.dart';

class TipoAcceso extends StatefulWidget {
  //const TipoAcceso({ Key? key }) : super(key: key);

  @override
  State<TipoAcceso> createState() => _TipoAccesoState();
}

class _TipoAccesoState extends State<TipoAcceso> {
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Acceso a visitas",
          style: TextStyle(
              fontSize: 20,
              color: Color(0xFF06323D),
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(0xFF0C0C0C),
          ),
        ),
      ),
      body: ListView(
        children: [
          _title(),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VisitasRegularPage()),
              );
            },
            child: _opcion(null, "Regular"),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VisitasTrabajadoresPage()),
              );
            },
            child: _opcion(null, "Trabajador"),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VisitasPaquteriaPage()),
              );
            },
            child: _opcion(null, "Paquetería / Uber"),
          ),
          _usuarioBloc.perfil.tipo!.contains("Titular")
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisitasMudanzaPage()),
                    );
                  },
                  child: _opcion(null, "Mudanza"),
                )
              : SizedBox(),
          /*InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VisitasEventosPage()),
              );
            },
            child: _opcion(null, "Fiestas y eventos"),
          ),*/
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RentaVacacionalView()),
              );
            },
            child: _opcion(null, "Renta Vacional y Airbnb"),
          ),
        ],
      ),
    );
  }

  _title() {
    return Container(
        margin: EdgeInsets.only(left: 35, top: 20),
        child: Text(
          "Tipo de visita",
          style: TextStyle(
              color: Color.fromARGB(
                  255,
                  _usuarioBloc.miFraccionamiento.color!.r,
                  _usuarioBloc.miFraccionamiento.color!.g,
                  _usuarioBloc.miFraccionamiento.color!.b),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ));
  }

  _opcion(IconData? icono, String titulo) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 40),
      child: Column(
        children: [
          ListTile(
            leading: icono == null
                ? null
                : Icon(
                    icono,
                    color: Color.fromARGB(
                        255,
                        _usuarioBloc.miFraccionamiento.color!.r,
                        _usuarioBloc.miFraccionamiento.color!.g,
                        _usuarioBloc.miFraccionamiento.color!.b),
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
}
