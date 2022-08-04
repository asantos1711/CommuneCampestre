/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_reader_core_full/flutter_document_reader_core_full.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/usuario_bloc.dart';
import 'config/routes.dart';
import 'firebase_options.dart';
import 'models/preferenciasUsuario.dart';
import 'provider/carritoRestaurantProvider.dart';
import 'provider/splashProvider.dart';
import 'services/push_notifications_services.dart';
import 'view/login.dart';
import 'view/menuInicio.dart';
import 'view/splash.dart';
import 'view/splashView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  //  "pk_test_51Jti97CudYnKG9fPgdsVEk4vwEzpEY24wJ7s72VxZDhmHVHqzjR6a8STNK2wnP6h6VhKlPG7vvg6gvrEigB0mcE800GgxoOaoB"; //usrPref.keyStripe.toString();
  await PushNotificationsService.initializeApp();
  // set the publishable key for Stripe - this is mandatory
  //Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  //Stripe.urlScheme = 'flutterstripe';
  SharedPreferences usuario = await PreferenciasUsuario().initPref();
  //Stripe.instance.applySettings();
  final usrPref =
      PreferenciasUsuario(); //Inicializar la clase para almacenar parémetros que se usan durante el procesp de precheckin.
  await usrPref.initPref();
  //await usuario.initPref();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  var mail;
  var pass;
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    _initPreference();
    initPlatformState();

    PushNotificationsService.messageStream.listen((event) {
      print("MyApp : ${event}");
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterDocumentReaderCore.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  _initPreference() async {
    usuario = new PreferenciasUsuario();
    await usuario.initPref();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    String ruta = "inicio_sesion"; //"/";
    //usuario.setiniciarSesion(false);
    print("IDFRACCIONAMIENTO" + usuario.idFraccionamiento);
    print("isLoggedIn" + usuario.isLoggedIn.toString());

    if (usuario.isLoggedIn != true && !usuario.isiniciarSesion) {
      ruta = "/";
      usuario.setiniciarSesion(false);
    }
    if (usuario.email.isNotEmpty && usuario.psw.isNotEmpty ||
        usuario.email != "" && usuario.psw != "") {
      usuario.setiniciarSesion(true);
      //_iniciarSesion(usuario.email, usuario.psw);
      ruta = "menu_inicio";
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CarritoProvider>(
            create: (_) => CarritoProvider(),
          ),
          ChangeNotifierProvider<LoadingProvider>(
            create: (_) => LoadingProvider(),
          ),
        ],
        child: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              localizationsDelegates: [GlobalMaterialLocalizations.delegate],
              supportedLocales: [Locale('es', "MX")],
              debugShowCheckedModeBanner: false,
              title: 'Commune',
              theme: ThemeData(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity),
              //routes: getApplicationRoutes(),
              builder: LoadingScreen.init(),
              //home:
              routes: getApplicationRoutes(),
              initialRoute: ruta,
            );
          },
        ));
  }

  _selectView() async {
    print("en el main****");
    /*SharedPreferences usuario = await _prefs;

    PreferenciasUsuario usuario = PreferenciasUsuario();
    print("usuario.isFirstTime: " + usuario.getString('isFirstTime').toString());
    print(usuario.getString('email'));
    bool? prim = usuario.getBool('isFirstTime');
    bool? isLog =  usuario.getBool('isLoggedIn');

    if (usuario.getString('email')!.isNotEmpty &&
        usuario.getString('psw')!.isNotEmpty &&
        !prim! &&  isLog!) */
    //SharedPreferences usuario = await _prefs;

    PreferenciasUsuario usuario = PreferenciasUsuario();
    print("usuario.isFirstTime: " + usuario.isFirstTime.toString());
    print(usuario.email);
    bool? prim = usuario.isFirstTime;
    bool? isLog = usuario.isLoggedIn;

    if (usuario.email.isNotEmpty && usuario.psw.isNotEmpty && !prim && isLog) {
      print("no son nulos");
      var snap = FirebaseFirestore.instance
          .collection('usuarios')
          .where("email", isEqualTo: usuario.email) //registro.perfil?.email)
          .snapshots();

      snap.forEach((element) {
        element.docs.forEach((element) {
          //_usuarioBloc.perfil = Usuario.fromFirestore(element);
          print("nombre***" + _usuarioBloc.perfil.nombre.toString());
        });
      });

      return MaterialPageRoute(builder: (BuildContext context) => MenuInicio());
      /*if (_usuarioBloc.perfil.tipo != "admin" &&
          _usuarioBloc.perfil.estatus == "1") {*/
      /*Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => MenuInicio(),
            transitionDuration: Duration(seconds: 0),
          ));*/
      /* );
      } else {
        return MaterialPageRoute(builder: (BuildContext context) => Splash());
      }*/
    } else if (!isLog) {
      return MaterialPageRoute(builder: (BuildContext context) => LoginPage());
    } else {
      return MaterialPageRoute(builder: (BuildContext context) => Splash());
    }
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'view/login.dart';
import 'view/seleccionFraccionamiento.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [Locale('es', "MX")],
      debugShowCheckedModeBanner: false,
      title: 'Commune',
      theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
