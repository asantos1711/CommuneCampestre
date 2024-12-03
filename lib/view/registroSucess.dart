import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/view/menuInicio.dart';
import 'package:campestre/view/registroAsociados.dart';
import 'package:flutter/material.dart';

class RegistroSucess extends StatefulWidget {
  const RegistroSucess({Key? key}) : super(key: key);

  @override
  State<RegistroSucess> createState() => _RegistroSucessState();
}

class _RegistroSucessState extends State<RegistroSucess> {
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Registro cuentas asociadas",
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
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 40),
              child: Text(
                "Información recibida",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 50, right: 50, top: 10),
            child: Text("Se ha creado el registro con éxito",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 20, right: 40, left: 40),
            child: InkWell(
              //minWidth: 100,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistroAsociados()),
                );
              },
              child: Text(
                "Ingresar otro registro",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20, top: 0, right: 30, left: 30),
            padding: EdgeInsets.all(10),
            child: InkWell(
              //minWidth: 100,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuInicio()),
                );
              },             
              child: Text(
                "Mi cuenta",
                style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(
                        255,
                        _usuarioBloc.miFraccionamiento.color!.r,
                        _usuarioBloc.miFraccionamiento.color!.g,
                        _usuarioBloc.miFraccionamiento.color!.b)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
