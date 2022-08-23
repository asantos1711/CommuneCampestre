import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/usuarioModel.dart';
import 'package:campestre/view/menuInicio.dart';
import 'package:campestre/view/registroAsociados.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../widgets/columnBuilder.dart';

class CuentasAsociadas extends StatefulWidget {
  const CuentasAsociadas({Key? key}) : super(key: key);

  @override
  State<CuentasAsociadas> createState() => _CuentasAsociadasState();
}

class _CuentasAsociadasState extends State<CuentasAsociadas> {
  List<Usuario> _list = [];
  DatabaseServices _databaseServices = new DatabaseServices();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  double w = 0.0, h = 0.0;
  final FirebaseStorage storage = FirebaseStorage.instance;
  int numActivos = 0;
  int numPermitidos = 0;
  

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    numPermitidos = _usuarioBloc.miFraccionamiento.numCuentasAsoc!.toInt();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Mis cuentas asociadas",
              style: TextStyle(fontSize: 20, color: Color(0xFF06323D))),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      MenuInicio(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF0C0C0C),
            ),
          ),
        ),
        body: 
        SingleChildScrollView(
          child: Column(children: [
            numActivos < numPermitidos  ? _agregarUsuario() : SizedBox(),
           _lista()
            
          ]),
        )
        );
  }

  _agregarUsuario() {
    return Container(
      width: w,
      margin: EdgeInsets.only(right: 20, top: 10),
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistroAsociados()),
          );
        },
        child: Container(
            width: 150,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _usuarioBloc.miFraccionamiento.getColor(),
              borderRadius: BorderRadius.all(Radius.circular(
                      25.0) //                 <--- border radius here
                  ),
            ),
            child: Text(
              "Agregar usuario",
              style: TextStyle(color: Colors.white),
            )
            //Icon(FontAwesomeIcons.plus, color: Colors.white,),
            ),
      ),
    );
  }

  _lista() {
    return FutureBuilder(
      future: _databaseServices.getUsuarioByTitular(),
      builder: (BuildContext context, AsyncSnapshot sn) {
        if (sn.connectionState == ConnectionState.waiting)
          return Center(
              child: Image.asset(
            "assets/icon/casita.gif",
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ));

        if (!sn.hasData) return SizedBox();

        _list = sn.data;

        return  ColumnBuilder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              if (_list[index].estatus!.contains("1")) {
                numActivos++;
              }
              return Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Container(
                      margin: EdgeInsets.only(left: 25, right: 25),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _list[index].nombre.toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                        _list[index].estatus!.contains("1")
                                            ? "Usuario activo"
                                            : "Usuario desactivado",
                                        style: TextStyle(fontSize: 12)),
                                  ]),
                            ),
                            _list[index].estatus!.contains("1")
                                ? InkWell(
                                    onTap: () {
                                      _alertConfirmacion(_list[index], false);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: Icon(FontAwesomeIcons.user,
                                          color: Colors.green),
                                    ))
                                : InkWell(
                                    onTap: () {
                                      _alertConfirmacion(_list[index], true);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: Icon(
                                          FontAwesomeIcons.userLargeSlash,
                                          color: Colors.red),
                                    ))
                          ]),
                    ),
                    Divider()
                  ],
                ),
              );
            }
            
                      
        ) ;
      },
    );
  }

  _alertConfirmacion(Usuario _usuario, bool activar) {
    String text = activar ? "activar " : "desactivar ";
    String textToast = activar ? "activado " : "desactivado ";
    String opcion = activar ? "1" : "2";
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // title: Container(child: Text("")), //Row(children: <Widget>[Icon(FontAwesomeIcons.checkCircle, color: Colors.green),Text("Envio éxitoso"),],),
              content: Container(
                  width: w - 170,
                  height: 150,
                  child: Column(
                    children: [
                      Container(
                        child: Text("¿Estás seguro de " +
                            text +
                            "este usuario? \nEsta opción se puede revertir"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      letterSpacing: 0.8,
                                      color: Color.fromARGB(
                                          255,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.r,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.g,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.b)),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: Color.fromARGB(
                                          255,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.r,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.g,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.b)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          15.0) //                 <--- border radius here
                                      ),
                                ),
                              )),
                          InkWell(
                              onTap: () {
                                _usuario.estatus = opcion;
                                _databaseServices.desactivarUsuario(_usuario);
                                Fluttertoast.showToast(
                                  msg: 'El usuario ha sido ' + textToast,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.grey[800],
                                );
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            CuentasAsociadas(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                );
                              },
                              child: Container(
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                      255,
                                      _usuarioBloc.miFraccionamiento.color!.r,
                                      _usuarioBloc.miFraccionamiento.color!.g,
                                      _usuarioBloc.miFraccionamiento.color!.b),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          15.0) //                 <--- border radius here
                                      ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  )));
        });
  }
}
