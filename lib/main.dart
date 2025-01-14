import 'dart:io';

import 'package:campestre/view/notificacion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/provider/splashProvider.dart';
import 'package:campestre/services/push_notifications_services.dart';
import 'package:campestre/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campestre/config/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controls/connection.dart';
import 'firebase_options.dart';
import 'models/preferenciasUsuario.dart';
import 'provider/carritoRestaurantProvider.dart';
import 'view/splashView.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*Stripe.publishableKey =
      "pk_test_51Jti97CudYnKG9fPgdsVEk4vwEzpEY24wJ7s72VxZDhmHVHqzjR6a8STNK2wnP6h6VhKlPG7vvg6gvrEigB0mcE800GgxoOaoB"; //usrPref.keyStripe.toString();
  */

  final result = await InternetAddress.lookup('example.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    print('connected');
  }
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotificationsService.initializeApp();

  await FirebaseAppCheck.instance.activate(webProvider: ReCaptchaV3Provider('6LdW-uYhAAAAAEvh7VhTyHD0A2CG_eZ05LIsPdJi'),
    // If you're building a web app.
  );

  SharedPreferences usuario = await PreferenciasUsuario().initPref();

  final usrPref =
      PreferenciasUsuario(); //Inicializar la clase para almacenar parémetros que se usan durante el procesp de precheckin.
  await usrPref.initPref();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //SharedPreferences _prefs = SharedPreferences.getInstance();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  late PreferenciasUsuario usuario;

  DatabaseServices databaseServices = new DatabaseServices();
  var mail;
  var pass;
  String _platformVersion = 'Unknown';
  late String ruta;

  @override
  void initState() {
    super.initState();
    _initPreference();
    _setFraccionamiento();

    _listenersMessaging();
    _restoConfiguracion();
  }

  _listenersMessaging() async {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        print(event.notification!.body);
        print(event.notification!.title);
      }
    });
  }

  _initPreference() async {
    usuario = new PreferenciasUsuario();
    await usuario.initPref();
    await Future.delayed(Duration(seconds: 1));
  }

  _setFraccionamiento() async {
    await DatabaseServices.getFraccionamiento();
    usuario.setIdFraccionamiento(_usuarioBloc.miFraccionamiento.id.toString());
  }

  _restoConfiguracion() async {
    ruta = "inicio_sesion";
    print("isLoggedIn" + usuario.isLoggedIn.toString());

    if (usuario.isLoggedIn != true) {
      ruta = "/";
      usuario.setiniciarSesion(false);
    }
    if (usuario.email.isNotEmpty && usuario.psw.isNotEmpty ||
        usuario.email != "" && usuario.psw != "") {
      usuario.setiniciarSesion(true);
      ruta = "menu_inicio";
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _restoConfiguracion();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CarritoProvider>(
            create: (_) => CarritoProvider(),
          ),
          ChangeNotifierProvider<LoadingProvider>(
            create: (_) => LoadingProvider(),
          ),
          ChangeNotifierProvider<CuentasAsociadoProvider>(
            create: (_) => CuentasAsociadoProvider(),
          ),
        ],
        child: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [Locale('es', "MX")],
              shortcuts: {
                LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
              },
              debugShowCheckedModeBanner: false,
              title: 'Commune',
              theme: ThemeData(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity),
              builder: LoadingScreen.init(),
              routes: getApplicationRoutes(),
              initialRoute: ruta,
            );
          },
        ));
  }
}

class NotificationManger {
  late BuildContext _context;

  init({required BuildContext context}) {
    _context = context;
  }

  //this method used when notification come and app is closed or in background and
  // user click on it, i will left it empty for you
  static handleDataMsg(Map<String, dynamic> data) {}

  //this our method called when notification come and app is foreground
  handleNotificationMsg(Map<String, dynamic> message) {
    debugPrint("from mangger  $message");

    final dynamic data = message['data'];
    //as ex we have some data json for every notification to know how to handle that
    //let say showDialog here so fire some action
    if (data.containsKey('showDialog')) {
      // Handle data message with dialog
      _showDialog(data: data);
    }
  }

  _showDialog({required Map<String, dynamic> data}) {
    //you can use data map also to know what must show in MyDialog
    UsuarioBloc _usuarioBloc = new UsuarioBloc();
    showDialog(
        context: _context,
        builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            // title: Container(child: Text("")), //Row(children: <Widget>[Icon(FontAwesomeIcons.checkCircle, color: Colors.green),Text("Envio éxitoso"),],),
            content: Container(
                width: w - 170,
                height: h * 0.35,
                child: Column(
                  children: [
                    Container(
                      child: Text("¿Estás seguro de "),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                            onTap: () {},
                            child: Container(
                              child: Text(
                                "Aceprtar",
                                style: TextStyle(
                                    letterSpacing: 0.8,
                                    color: Color.fromARGB(
                                        255,
                                        _usuarioBloc.miFraccionamiento.color!.r,
                                        _usuarioBloc.miFraccionamiento.color!.g,
                                        _usuarioBloc
                                            .miFraccionamiento.color!.b)),
                              ),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: Color.fromARGB(
                                        255,
                                        _usuarioBloc.miFraccionamiento.color!.r,
                                        _usuarioBloc.miFraccionamiento.color!.g,
                                        _usuarioBloc
                                            .miFraccionamiento.color!.b)),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        15.0) //                 <--- border radius here
                                    ),
                              ),
                            )),
                        InkWell(
                            onTap: () {},
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
                                borderRadius: BorderRadius.all(Radius.circular(
                                        15.0) //                 <--- border radius here
                                    ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ))));
  }
}
