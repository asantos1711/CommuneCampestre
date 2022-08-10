import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/fraccionamientos.dart';
import 'package:campestre/models/preferenciasUsuario.dart';
import 'package:campestre/models/responseLote.dart';
import 'package:campestre/models/usuarioModel.dart';
import 'package:campestre/provider/splashProvider.dart';
import 'package:campestre/services/apiResidencial/registroUsuarios.dart';
import 'package:campestre/services/jwt.dart';
import 'package:campestre/services/push_notifications_services.dart';
import 'package:campestre/view/recuperarContra.dart';
import 'package:campestre/view/registroOpciones.dart';
import 'package:campestre/widgets/textfielborder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controls/notificaciones.dart';
import '../firebase_options.dart';
import '../models/modeloRegistro.dart';
import '../widgets/cuadroLoginShape.dart';
import 'menuInicio.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

double w = 0, h = 0;
final _formKey = GlobalKey<FormState>();
TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
DatabaseServices db = new DatabaseServices();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
PreferenciasUsuario usuario = new PreferenciasUsuario();
Fraccionamiento _fraccionamiento = new Fraccionamiento();
final FirebaseFirestore datab = FirebaseFirestore.instance;

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  UsuarioBloc usuarioBloc = new UsuarioBloc();

  @override
  void initState() {
    getFraccionamientoId(usuario.idFraccionamiento);
    if (usuario.idFraccionamiento != "" &&
        usuarioBloc.miFraccionamiento != null) {
      //_usuarioBloc.miFraccionamiento = snap
    }
    _init();
    super.initState();
    //_checkJWT();
  }

  _init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /*if (usuarioBloc.miFraccionamiento.id == null) {
      _databaseServices.getFraccionamientoId(usuario.idFraccionamiento);
    } else {
      //_fraccionamiento = usuarioBloc.miFraccionamiento;
      //_databaseServices.getFraccionamientoId(usuario.idFraccionamiento);
    }*/
  }

  _checkJWT() async {
    JWTProvider jw = new JWTProvider();
    String s = await jw.getJWT();
    print(s);
  }

  bool validateLogin() {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    _charge(false);
    return false;
  }

  _charge(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  _bloquearPantalla() {
    this.setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    // ScreenUtil.init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: OKToast(
            child: usuarioBloc.miFraccionamiento.color?.r != null
                ? Stack(
                    children: [
                      _form(),
                      Positioned(
                        top: 40,
                        //bottom: 0,
                        left: 5,
                        right: 0,
                        //left: 30,
                        //height:250,
                        //width: 250,
                        child: Image.network(
                          usuarioBloc.miFraccionamiento.urlLogopng.toString(),
                          height: h * 0.1,
                          alignment: Alignment.topLeft,
                        ),

                        /* Image.asset(
                    "assets/images/logoBlanco.png",
                    alignment: Alignment.topLeft,
                  )*/
                      ),
                      Positioned(
                        top: 40,
                        //bottom: 0,
                        //left: 130,
                        right: 0,
                        //left: 30,
                        //height:250,
                        //width: 250,
                        child: InkWell(
                            onTap: () async {
                              _sendNotificacionSOS();
                            },
                            child: Container(
                                width: w / 5,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  "SOS",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          50.0) //                 <--- border radius here
                                      ),
                                ))),
                      )
                    ],
                  )
                : Center(
                    child: Image.asset(
                      "assets/icon/casita.gif",
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  )));
  }

  Widget _form() {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.zero,
          child: Center(
            child: CustomPaint(
              size: Size(w, 300),
              painter: CurvedPainter(),
            ),
          ),
        ),
        //Image.asset("assets/images/Rectangle2.png", fit: BoxFit.fill),
        Container(
            margin: EdgeInsets.only(top: 15, left: 50, right: 20),
            child: Text("Inicio de sesión",
                style: TextStyle(color: Colors.black, fontSize: 20))),
        Container(
            width: w - 50,
            // height: 800,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormFieldBorder("CORREO", _email,
                      TextInputType.emailAddress, false, Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormFieldBorder(
                        "CONTRASEÑA", //Translations.of(context).text("password"),
                        _password,
                        TextInputType.visiblePassword,
                        true,
                        Colors.white)),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            RecuperarContra(),
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  },
                  child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 17),
                      alignment: Alignment.topRight,
                      child: Text(
                        "¿Olvidó su contraseña?",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(41, 45, 48, 0.3)),
                      )),
                ),
                SizedBox(height: 30),
                _button(),
                /*SizedBox(
                  height: 30,
                )*/
              ],
            )),
        _opciones(),
      ],
    );
  }

  Widget _button() {
    return InkWell(
      onTap: () async {
        try {
          final SharedPreferences prefs = await _prefs;
          // # show loading
          Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
          //context.read<LoadingProvider>().setLoad(true);

          UserCredential user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _email.text, password: _password.text);

          //print("additionalUserInfo " + user.user.toString());

          Usuario _usuario = await db.getUsuario(_email.text);
          usuarioBloc.perfil = _usuario;
          PushNotificationsService a = new PushNotificationsService();
          //a.getToken();
          print(_usuario.tokenNoti);
          print(a.getToken());
          String tokenNew = a.getToken();

          if (!_usuario.idFraccionamiento!
              .contains(usuarioBloc.miFraccionamiento.id.toString())) {
            print("si son diferentes*****");
            setState(() {
              _usuario.idFraccionamiento =
                  usuarioBloc.miFraccionamiento.id.toString();
            });
            db.updateUsuario(_usuario);
          }

          RegistroUsuarioConnect connect = RegistroUsuarioConnect();

          /**Validar si es habitante */
          if ("Habitante".contains(_usuario.tipo.toString()) &&
              _usuario.estatus!.contains("1")) {
            setState(() {
              usuario.setisLoggedIn(true);
              usuario.setiniciarSesion(true);
              usuario.setemail(_email.text);
              usuario.setpsw(_password.text);
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
            Fluttertoast.showToast(
              msg:
                  'Tu acceso ha sido bloqueado, favor de comunicarse con el titular de la cuenta',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey[800],
            );
            return;
          }

          String response = await connect
              .getRegistroStatus(usuarioBloc.perfil.idRegistro ?? 0);

          print("ESTATUS del servicio de Javi : $response");

          /*if (!_usuario.tokenNoti!.contains(tokenNew)) {
            print("si son diferentes*****");
            setState(() {
              _usuario.tokenNoti = tokenNew;
            });
            db.updateUsuario(_usuario);

            await connect.actualizarToken(_usuario, response);
          }*/
          await connect.actualizarToken(_usuario, response);

          if ("pendiente".contains(response.toLowerCase())) {
            //usuarioBloc.perfil.estatus == "0" &&
            Provider.of<LoadingProvider>(context, listen: false).setLoad(false);

            Fluttertoast.showToast(
              msg: 'Tus datos no han sido validados',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey[800],
            );
          } else if ("bloqueada".contains(response.toLowerCase())) {
            //usuarioBloc.perfil.estatus == "2" ||
            Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
            Fluttertoast.showToast(
              msg:
                  'Tu acceso ha sido bloqueado, favor de comunicarse con administración',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey[800],
            );
          } else if ("verificada".contains(response.toLowerCase())) {
            //(usuarioBloc.perfil.tipo != "admin" &&
            // usuarioBloc.perfil.estatus == "1") &&

            await _revisionValidacion();
            setState(() {
              usuario.setisLoggedIn(true);
              usuario.setiniciarSesion(true);
              usuario.setemail(_email.text);
              usuario.setpsw(_password.text);
            });
            //print(usuario.isLoggedIn);
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => MenuInicio(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
          }

          /*final datosUser = user;
          //print("usuario***" + user?.email);
          //registro.perfil.email = user?.email;
          //addCredenciales(_email.text,_password.text );
          final SharedPreferences prefs = await _prefs;

          final mail = prefs.getString('email');
          final pass = prefs.getString('pass');

          if (mail == null && pass == null) {
            prefs.setString('email', _email.text);
            prefs.setString('pass', _password.text);
          }
          print("despues***");
          print(prefs.getString('email'));*/

          /*var snap =  FirebaseFirestore.instance
              .collection('usuarios')
              .where("email", isEqualTo: _email.text) //registro.perfil?.email)
              .snapshots();

          snap.forEach((element) {
            element.docs.forEach((element) {
              usuarioBloc.perfil = Usuario.fromFirestore(element);
              print("nombre***" + usuarioBloc.perfil.nombre.toString());
            });
          });*/

        } catch (error) {
          //  removeCredenciales();
          _charge(false);
          //_bloquearPantalla();
          print(error);
          print("EROROR**" + error.toString());

          showToast(
            "Correo y/o contraseña incorrectos",
            duration: Duration(seconds: 2),
          );
          /*Toast.show("Correo y/o contraseña incorrectos", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/
          //context.read()<LoadingProvider>().setLoad(false);
        }

        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
      },
      child: Container(
        width: w - 100,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          /*color: Color.fromARGB(255, _fraccionamiento.color?.r ?? 0,
              _fraccionamiento.color?.g ?? 0, _fraccionamiento.color?.b ?? 0),*/
          color: Color.fromARGB(
              255,
              usuarioBloc.miFraccionamiento.color!.r,
              usuarioBloc.miFraccionamiento.color!.g,
              usuarioBloc.miFraccionamiento.color!.b),
          borderRadius: BorderRadius.all(
              Radius.circular(30.0) //         <--- border radius here
              ),
        ),
        child: Text(
          "INGRESAR",
          style: TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  getFraccionamientoId(String id) async {
    //var snap = _databaseServices.getFracionamientosById(usuario.idFraccionamiento);

    Fraccionamiento _fracc = new Fraccionamiento();

    DocumentSnapshot snaps =
        await datab.collection('fraccionamientos').doc(id).get();
    print(snaps.data());

    if (snaps.exists) {
      print("dentro");
      Map<String, dynamic> mapa = snaps.data() as Map<String, dynamic>;
      _fracc = Fraccionamiento.fromJson(mapa);
      setState(() {
        usuarioBloc.miFraccionamiento = _fracc;
      });
    }

    print(usuarioBloc.miFraccionamiento.color?.r);
  }

  Widget _opciones() {
    return Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          children: [
            Container(
              child: RichText(
                text: TextSpan(
                  text: "¿No tienes cuenta?  ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF959494),
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Registrate aquí",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF959494),
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistroOpciones()),
                            );
                          }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ));
  }

  Future _revisionValidacion() async {
    RegistroUsuarioConnect connect = RegistroUsuarioConnect();
    //print("En verificacion de Lote");
    try {
      if (usuarioBloc.perfil.lote != null && usuarioBloc.perfil.lote != 0) {
        print("Hay Lote");
      } else {
        print("NO Hay Lote");
        ResponseRegistro response =
            await connect.getRegistro(usuarioBloc.perfil.idRegistro ?? 0);

        if (response.data?.lote != null) {
          usuarioBloc.perfil.lote = response.data?.lote?.id;
          usuarioBloc.perfil.estatus = "1";

          usuarioBloc.perfil =
              await db.guardarDatosRegistro(usuarioBloc.perfil);
          print("Hay Lote1");
        }
      }

      if (usuarioBloc.perfil.lotePadre != null &&
          usuarioBloc.perfil.lotePadre != 0) {
        print("Hay LoteLotePadre");
      } else {
        ResponseRegistro response =
            await connect.getRegistro(usuarioBloc.perfil.idRegistro ?? 0);
        print("get*******"); //2081
        ResponseGetLote _lotePadre =
            await connect.getLotePadre(response.data!.lote?.id ?? 0);
        print(_lotePadre.data?.parentLote?.id);
        usuarioBloc.perfil.lotePadre = _lotePadre.data?.parentLote?.id ?? 0;
        usuarioBloc.perfil = await db.guardarDatosRegistro(usuarioBloc.perfil);
        print("NO Hay LotePadre");
      }
    } catch (e) {
      print("Error en guardado vista ${e}");
      return;
    }
    return;
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
                    bodyText: "Se han recibido una señal SOS ");

                Fluttertoast.showToast(
                  msg: "La alerta ha sido enviada ",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey[800],
                );
              } catch (e) {
                print("No se pudo enviar la alerta: " + e.toString());
                Fluttertoast.showToast(
                  msg: "No se pudo enviar la alerta ",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey[800],
                );
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