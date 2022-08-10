import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/usuario_bloc.dart';
import '../main.dart';
import '../provider/splashProvider.dart';
import '../services/push_notifications_services.dart';

class LoadingScreen {
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, LoadingCustom(child: child!));
      } else {
        return LoadingCustom(child: child!);
      }
    };
  }
}

class LoadingCustom extends StatefulWidget {
  final Widget child;
  LoadingCustom({Key? key, required this.child}) : super(key: key);

  @override
  State<LoadingCustom> createState() => _LoadingCustomState();
}

class _LoadingCustomState extends State<LoadingCustom> {
  late double w, h;
  bool alerta = false;
  String msAlerta = "";

  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*PushNotificationsService.messageStream.listen((event) {
      print("MyApp : ${event}");
      setState(() {
        alerta = true;
        msAlerta = event;
      });
      //_alerta();
    });
    Future.delayed(Duration.zero, () {
      ///init Notification Manger
      NotificationManger notificationManger = NotificationManger();
      notificationManger.init(context: context);

      ///init FCM Configure
      PushNotificationsService.initializeApp();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: ChangeNotifierProvider<LoadingProvider>(
            create: (context) => LoadingProvider(),
            builder: (context, _) {
              return Stack(children: [
                new GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: widget.child),
                Consumer<LoadingProvider>(builder: (context, provider, child) {
                  return provider.loading
                      ? Container(
                          width: w,
                          height: h,
                          color: Color.fromARGB(146, 0, 0, 0),
                          child: Center(
                              child: Image.asset(
                            "assets/icon/casita.gif",
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          )),
                        )
                      : SizedBox();
                })
              ]);
            }));
  }

  _alerta() {
    return showDialog(
        context: context,
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
                        child: Text("¿Estás seguro de "),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                setState(() {
                                  alerta = false;
                                });
                              },
                              child: Container(
                                child: Text(
                                  "Aceprtar",
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
                                alerta = false;
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
