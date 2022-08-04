import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../bloc/usuario_bloc.dart';
import '../../../models/restaurante/responseMenuJson.dart';
import '../../../provider/splashProvider.dart';
import '../../../services/serviciosAyB.dart';
import 'categorias.dart';

class RestauranteView extends StatefulWidget {
  String qr;
  bool alerta = false;
  RestauranteView({required this.qr, required this.alerta});

  @override
  State<RestauranteView> createState() => _RestauranteViewState();
}

class _RestauranteViewState extends State<RestauranteView> {
  UsuarioBloc usuarioBloc = UsuarioBloc();
  double? w, h;
  bool loadiing = true, alert = false;

  late String qr;

  @override
  void initState() {
    qr = this.widget.qr;
    alert = this.widget.alerta;

    if (alert) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => _alert());
    }

    _validarMenu();
    super.initState();
  }

  _alert() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // title: Container(child: Text("")), //Row(children: <Widget>[Icon(FontAwesomeIcons.checkCircle, color: Colors.green),Text("Envio éxitoso"),],),
              content: Container(
                width: w! - 170,
                height: h! * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Image.asset("assets/images/mesero.png"),
                    ),
                    Text(
                      "¡Su orden ha sido enviada con éxito!",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF0C0C0C),
            )),
        title: Text(
          "Menú",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: loadiing
              ? Image.asset(
                  "assets/icon/casita.gif",
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _opcionOrdenar(),
                    qr.contains("TO-HOME") ? SizedBox() : _opcionLlamarMesero(),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _opcionOrdenar() {
    return _opcion("Ordenar", Icons.coffee_outlined, () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrdenarView(
                  qr: qr,
                )),
      );
    });
  }

  _opcionLlamarMesero() {
    return _opcion("Llamar a mesero", FontAwesome.hand_stop_o, () async {
      bool salida = await AybServices.callMesero(qr);

      print(salida);

      if (salida == true) {
        Fluttertoast.showToast(
          msg: 'El mesero ha sido llamado',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Ocurrio un error, intentelo de nuevo',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );
      }
    });
  }

  _opcion(String text, IconData icon, Function() funcion) {
    return InkWell(
      onTap: funcion,
      child: Container(
          margin: EdgeInsets.all(15),
          height: w! * 0.5,
          width: w! * 0.5,
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                color: usuarioBloc.miFraccionamiento.getColor(),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              )
            ],
          )),
    );
  }

  _menu() {
    return FutureBuilder(
      future: AybServices.getMenuJson(qr),
      builder: (c, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
                child: Image.asset(
              "assets/icon/casita.gif",
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            )),
          );
        }
        return SizedBox();
      },
    );
  }

  Future<void> _validarMenu() async {
    try {
      Menu menu = await AybServices.getMenuJson(qr);

      if (menu.familias == null && menu.familias!.isEmpty) {
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "No hay menú disponible");
      } else {
        setState(() {
          loadiing = false;
        });
      }
    } catch (e) {
      Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "No hay menú disponible");
    }
  }
}
