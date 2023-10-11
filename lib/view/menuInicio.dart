import 'dart:convert';

import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/modeloRegistro.dart';
import 'package:campestre/models/preferenciasUsuario.dart';
import 'package:campestre/models/usuarioModel.dart';
import 'package:campestre/provider/splashProvider.dart';
import 'package:campestre/services/apiResidencial/registroUsuarios.dart';
import 'package:campestre/view/amenidades/menuAmenidades.dart';
import 'package:campestre/view/cuentasAsociadas.dart';
import 'package:campestre/view/infoFraccionamiento/info.dart';
import 'package:campestre/view/login.dart';
import 'package:campestre/view/misVisitas/visitasActivas.dart';
import 'package:campestre/view/pagos/pagosHome.dart';
import 'package:campestre/view/perfil.dart';
import 'package:campestre/view/preguntasView.dart';
import 'package:campestre/view/reportes/reportes.dart';
import 'package:campestre/view/tipoAcceso.dart';
import 'package:campestre/widgets/autenticacion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../controls/notificaciones.dart';
import '../models/estadoCuenta/detailEstadoCuenta.dart';
import '../services/apiResidencial/estadoCuentaProvider.dart';
import 'misAccesos/misAccesos.dart';

class MenuInicio extends StatefulWidget {
  @override
  _MenuInicioState createState() => _MenuInicioState();
}

class _MenuInicioState extends State<MenuInicio> {
  ShapeBorder _customBorder = CircleBorder();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  PreferenciasUsuario usuario = new PreferenciasUsuario();
  DatabaseServices _databaseServices = new DatabaseServices();
  double w = 0, h = 0;

  @override
  initState() {
    _inicio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(_usuarioBloc.miFraccionamiento.color?.r);
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: _usuarioBloc.miFraccionamiento.color?.r != null
          ? SingleChildScrollView(
              child: Column(
              children: [
                _tarjetaUsuario(),
                _opciones(),
              ],
            ))
          : Center(
              child: Image.asset(
                "assets/icon/casita.gif",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
    );
  }

  _opciones() {
    if (_usuarioBloc.perfil.tipo != null && _usuarioBloc.perfil.tipo != "") {
      //_usuarioBloc.perfil.tipo != null
      if (_usuarioBloc.perfil.tipo?.contains("Titular") ?? false) {
        return _opcionesTitular();
      } else {
        return _opcionesHab();
      }
    } else {
      return Image.asset(
        "assets/icon/casita.gif",
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      );
      //return CircularProgressIndicator();
    }
  }

  _inicio() async {
    if (usuario.idFraccionamiento != "" &&
        _usuarioBloc.miFraccionamiento != null) {
      await DatabaseServices.getFraccionamiento();
      //_usuarioBloc.miFraccionamiento = snap
    }
    if (usuario.isiniciarSesion) {
      await _iniciarSesion(usuario.email, usuario.psw);
      usuario.setiniciarSesion(true);
    }
  }

  _iniciarSesion(String email, String pwd) async {
    try {
      //Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      bool plazoVencidoMantenimientos =
          false; //Si hay alguna mantenimiento mayor a 62 días
      bool plazoVencidoSancion = false; //Si hay alguna sancion mayor a 15 días

      Usuario _usuario = await db.getUsuario(email);
      _usuarioBloc.perfil = _usuario;

      /**Proceso para revisar mantenimientos y sanciones */
      EstadoCuentaProvider estadoCuentaProvider = EstadoCuentaProvider();
      DetailEstadoCuenta details =
          await estadoCuentaProvider.getDetailPorPagar();
      if (details.data.toString() == "[]" ||
          details.data.toString() == "null") {
        /**No hay detalles por pagar. 
         * El usuario puede accesar
         */
      } else {
        List<Datum>? sanciones = details.data!
            .where((element) => (element.tipo!.contains("sancion") &&
                element.estado!.contains("vigente")))
            .toList();

        List<Datum>? matenimientos = details.data!
            .where((element) => (element.tipo!.contains("mantenimiento") &&
                element.estado!.contains("vigente")))
            .toList();

        /**VALIDACION Matenimientos*/
        int dias = 0, maxDia = 0;
        int diasMatto = 0;
        for (var item in matenimientos) {
          print(item.fechaCreado);
          dias = DateTime.now().difference(item.fechaCreado!).inDays;
          maxDia = maxDia > dias ? maxDia : dias;
          print(dias);
          diasMatto =
              int.parse(_usuarioBloc.miFraccionamiento.diasMantto.toString());
          plazoVencidoMantenimientos =
              dias <= diasMatto ? plazoVencidoMantenimientos : true;
        }
        print(maxDia);

        if ((maxDia == diasMatto + 1 || maxDia == diasMatto + 2) &&
            (DateTime.now().weekday == DateTime.saturday ||
                DateTime.now().weekday == DateTime.sunday)) {
          plazoVencidoMantenimientos = false;
        }

        /**VALIDACION SANCIONES */
        int diasS = 0, maxDiaS = 0;
        int diasSancciones = 0;
        for (var item in sanciones) {
          print(item.fechaCreado);
          diasS = DateTime.now().difference(item.fechaCreado!).inDays;
          maxDiaS = maxDiaS > diasS ? maxDiaS : diasS;
          print(dias);
          diasSancciones = int.parse(
              _usuarioBloc.miFraccionamiento.diasSanciones.toString());
          plazoVencidoSancion =
              diasS <= diasSancciones ? plazoVencidoSancion : true;
        }
        print(maxDiaS);

        if ((maxDiaS == diasSancciones + 1 || maxDiaS == diasSancciones + 2) &&
            (DateTime.now().weekday == DateTime.saturday ||
                DateTime.now().weekday == DateTime.sunday)) {
          plazoVencidoSancion = false;
        }
      }

      /*if (plazoVencidoMantenimientos || plazoVencidoSancion) {
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        AuthenticationServices.getInstance().signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        Fluttertoast.showToast(
          msg:
              'Tu acceso ha sido bloqueado, favor de pasar a administración a pagar adeudos restantes',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );
        return;
      }*/

      /**Fin Proceso para revisar mantenimientos y sanciones */

      if ("Habitante".contains(_usuario.tipo.toString()) &&
          _usuario.estatus!.contains("1")) {
        setState(() {
          usuario.setisLoggedIn(true);
          usuario.setiniciarSesion(true);
          usuario.setemail(email);
          usuario.setpsw(pwd);
        });
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        /*Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => MenuInicio(),
            transitionDuration: Duration(seconds: 0),
          ),
        );*/
      } else if ("Habitante".contains(_usuario.tipo.toString()) &&
          !_usuario.estatus!.contains("1")) {
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        AuthenticationServices.getInstance().signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        /*Fluttertoast.showToast(
          msg:
              'Tu acceso ha sido bloqueado, favor de comunicarse con el titular de la cuenta',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );*/
        Alert(
          context: context,
          desc:
              'Tu acceso ha sido bloqueado, favor de comunicarse con el titular de la cuenta',
          buttons: [
            DialogButton(
              radius: BorderRadius.all(Radius.circular(25)),
              color: _usuarioBloc.miFraccionamiento.getColor(),
              child: Text(
                "Aceptar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
        return;
      }

      RegistroUsuarioConnect connect = RegistroUsuarioConnect();
      String response =
          await connect.getRegistroStatus(_usuarioBloc.perfil.idRegistro ?? 0);

      if ("pendiente".contains(response.toLowerCase())) {
        //usuarioBloc.perfil.estatus == "0" &&
        //Provider.of<LoadingProvider>(context, listen: false).setLoad(false);

        bool pasar = await _revisionValidacion();

        if (_usuarioBloc.perfil.tipo != "admin" &&
            _usuarioBloc.perfil.estatus == "1") {
          setState(() {
            usuario.setisLoggedIn(true);
          });
          return;
        }
      } else if ("bloqueada".contains(response.toLowerCase())) {
        //usuarioBloc.perfil.estatus == "2" ||
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        AuthenticationServices.getInstance().signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        /*Fluttertoast.showToast(
          msg:
              'Tu acceso ha sido bloqueado, favor de comunicarse con administración',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );*/
        Alert(
          context: context,
          desc:
              'Tu acceso ha sido bloqueado, favor de comunicarse con administración',
          buttons: [
            DialogButton(
              radius: BorderRadius.all(Radius.circular(25)),
              color: _usuarioBloc.miFraccionamiento.getColor(),
              child: Text(
                "Aceptar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      } else if ("verificada".contains(response.toLowerCase())) {
        //(usuarioBloc.perfil.tipo != "admin" &&
        // usuarioBloc.perfil.estatus == "1") &&

        setState(() {
          usuario.setisLoggedIn(true);
        });
        print(usuario.isLoggedIn);
      }
    } catch (error) {
      //  removeCredenciales();
      //_bloquearPantalla();
      print(error);
      print("EROROR**" + error.toString());
      /*Toast.show("Correo y/o contraseña incorrectos", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/
      //context.read()<LoadingProvider>().setLoad(false);
    }
  }

  Future<bool> _revisionValidacion() async {
    RegistroUsuarioConnect connect = RegistroUsuarioConnect();

    try {
      ResponseRegistro response =
          await connect.getRegistro(_usuarioBloc.perfil.idRegistro!);

      if (response.data?.lote != null) {
        _usuarioBloc.perfil.lote = response.data?.lote?.id;
        _usuarioBloc.perfil.estatus = "1";

        await db.guardarDatosRegistro(_usuarioBloc.perfil);
        _usuarioBloc.perfil =
            await db.guardarDatosRegistro(_usuarioBloc.perfil);
        return true;
      }
    } catch (e) {
      print("Error en guardado vista ${e}");
      return false;
    }
    return false;
  }

  _opcionesTitular() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Perfil()),
            );
          },
          child: _opcion(Icons.pin_drop_outlined, "Mi información"),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TipoAcceso()),
            );
          },
          child: _opcion(Icons.person_outlined, "Acceso a visitas"),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VisitasActivas()),
            );
          },
          child: _opcion(Icons.qr_code, "Mis visitas"),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PagosHome()),
            );
          },
          child: _opcion(Icons.credit_card, "Pagos"),
        ),
        _usuarioBloc.miFraccionamiento.amenidades as bool
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuAmenidades()),
                  );
                },
                child: _opcion(FontAwesomeIcons.treeCity, "Amenidades"),
              )
            : SizedBox(),
        _usuarioBloc.miFraccionamiento.preguntasFrec as bool
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PreguntasView()),
                  );
                },
                child: _opcion(
                    FontAwesomeIcons.circleQuestion, "Preguntas frecuentes"),
              )
            : SizedBox(),
        _usuarioBloc.miFraccionamiento.infoFracc as bool
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InfoFraccionamiento()),
                  );
                },
                child: _opcion(FontAwesomeIcons.newspaper,
                    "Información del fraccionamiento"),
              )
            : SizedBox(),
        _usuarioBloc.miFraccionamiento.reportes as bool
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportesView()),
                  );
                },
                child: _opcion(Icons.flag, "Generar reportes a administración"),
              )
            : SizedBox(),
        // InkWell(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => MisAccesosView()),
        //       );
        //     },
        //     child: _opcion(Icons.car_rental, "Mis accesos")),
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CuentasAsociadas()),
              );
            },
            child: _opcion(
                Icons.supervised_user_circle_sharp, "Cuentas asociadas")),
      ],
    );
  }

  _opcionesHab() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Perfil()),
            );
          },
          child: _opcion(Icons.pin_drop_outlined, "Mi información"),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TipoAcceso()),
            );
          },
          child: _opcion(Icons.person_outlined, "Acceso a visitas"),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VisitasActivas()),
            );
          },
          child: _opcion(Icons.qr_code, "Mis visitas"),
        ),
        _usuarioBloc.miFraccionamiento.preguntasFrec as bool
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PreguntasView()),
                  );
                },
                child: _opcion(
                    FontAwesomeIcons.circleQuestion, "Preguntas frecuentes"),
              )
            : SizedBox(),
        _usuarioBloc.miFraccionamiento.infoFracc as bool
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InfoFraccionamiento()),
                  );
                },
                child: _opcion(FontAwesomeIcons.newspaper,
                    "Información del fraccionamiento"),
              )
            : SizedBox(),
        _usuarioBloc.miFraccionamiento.reportes as bool
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportesView()),
                  );
                },
                child: _opcion(Icons.flag, "Generar reportes a administración"),
              )
            : SizedBox(),
      ],
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

  _tarjetaUsuario() {
    /*Boton para cambio de contraseña en tarjeta de usuario*/
    /*_botonCambContra() {
      return Container(
        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
        child: FlatButton(
          minWidth: 240,
          onPressed: () {},
          color: Color(0xff5E1281),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            "CAMBIAR CONTRASEÑA",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      );
    }*/

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 31, vertical: 40),
      width: w,
      child: Card(
        //margin: EdgeInsets.all(10),
        child: Container(
          //padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(20),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/commune-cf48f.appspot.com/o/descarga.jpeg?alt=media&token=9f44c41f-4824-4389-9a92-22474bc340fb"),
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    ],
                  ),*/
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: w / 3,
                          child: Text(
                            _usuarioBloc.perfil.nombre ?? "",
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                            style: TextStyle(
                                color: Color.fromARGB(
                                    255,
                                    _usuarioBloc.miFraccionamiento.color!.r,
                                    _usuarioBloc.miFraccionamiento.color!.g,
                                    _usuarioBloc.miFraccionamiento.color!.b),
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          width: w / 2,
                          //margin: EdgeInsets.only(top:30),
                          child: Text(
                            _usuarioBloc.perfil.email ?? "",
                            style: TextStyle(
                              color: Color(0xff303370).withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          width: w / 2,
                          //margin: EdgeInsets.only(top:30),
                          child: Text(
                            _usuarioBloc.perfil.direccion ?? "",
                            style: TextStyle(
                              color: Color(0xff303370).withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //_botonCambContra(),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "Bienvenido",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      actions: [
        Container(
            width: w / 5,
            height: 2,
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(
                      50.0) //                 <--- border radius here
                  ),
            ),
            child: InkWell(
              onTap: () async {
                _sendNotificacionSOS();
              },
              child: Text(
                "SOS",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )),
      ],
      leading: Container(
        child: Ink(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: InkWell(
            //child: Icon(FontAwesome.power_off, color: Colors.black, ),
            child: Icon(
              Icons.power_settings_new,
              color: Colors.black,
              size: 23,
            ),
            customBorder: _customBorder,
            splashColor: Color(0xff5E1281),
            onTap: () {
              usuario.setisLoggedIn(false);
              usuario.setemail("");
              usuario.setpsw("");
              //usuario.setpsw(null);
              AuthenticationServices.getInstance().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              /*Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);*/
            },
          ),
        ),
      ),
    );
  }

  Future<void> _sendNotificacionSOS() async {
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('SOS'),
        content: new Text('¿Desea con seguridad enviar la alerta SOS?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Provider.of<LoadingProvider>(context, listen: false)
                  .setLoad(true);
              try {
                Notificaciones notificaciones = Notificaciones();
                await notificaciones.sendNotiToSeguridad(
                    titulo: "¡Alerta SOS!",
                    bodyText:
                        "Se han recibido una señal SOS de ${_usuarioBloc.perfil.nombre}");

                /*Fluttertoast.showToast(
                  msg: "La alerta ha sido enviada ",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey[800],
                );*/
                Alert(
                  context: context,
                  desc: "La alerta ha sido enviada ",
                  buttons: [
                    DialogButton(
                      radius: BorderRadius.all(Radius.circular(25)),
                      color: _usuarioBloc.miFraccionamiento.getColor(),
                      child: Text(
                        "Aceptar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: 120,
                    )
                  ],
                ).show();
              } catch (e) {
                print("No se pudo enviar la alerta: " + e.toString());
                /*Fluttertoast.showToast(
                  msg: "No se pudo enviar la alerta ",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey[800],
                );*/
                Alert(
                  context: context,
                  desc: "No se pudo enviar la alerta ",
                  buttons: [
                    DialogButton(
                      radius: BorderRadius.all(Radius.circular(25)),
                      color: _usuarioBloc.miFraccionamiento.getColor(),
                      child: Text(
                        "Aceptar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: 120,
                    )
                  ],
                ).show();
              }

              Provider.of<LoadingProvider>(context, listen: false)
                  .setLoad(false);
              Navigator.of(context).pop(false);
            },
            child: new Text('Sí'),
          ),
        ],
      ),
    );
  }
}
