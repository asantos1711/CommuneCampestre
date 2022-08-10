import 'package:campestre/models/restaurante/crearCuentaMovil.dart';
import 'package:campestre/services/serviciosAyB.dart';
import 'package:campestre/view/amenidades/casaClub/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../bloc/carritoBloc.dart';
import '../../../bloc/usuario_bloc.dart';
import '../../../models/EstadoCuentaDireccion.dart';
import '../../../models/restaurante/responseMenuJson.dart';
import '../../../provider/splashProvider.dart';
import '../../../widgets/textfielborder.dart';

class DireccionCotacto extends StatefulWidget {
  OrdenCompletaModel orden;
  DireccionCotacto({required this.orden});

  @override
  State<DireccionCotacto> createState() => _DireccionCotactoState();
}

class _DireccionCotactoState extends State<DireccionCotacto> {
  late OrdenCompletaModel orden;
  bool loadiing = true, alert = false;
  TextEditingController direccion = TextEditingController();
  TextEditingController telefono = TextEditingController();

  CarritoBloc carritoBloc = CarritoBloc();
  double? w, h;

  UsuarioBloc usuarioBloc = UsuarioBloc();
  @override
  void initState() {
    orden = this.widget.orden;
    _validarMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Stack(children: [
      Scaffold(
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
            "Contacto",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: _datos(), // loadiing ? CircularProgressIndicator() :
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        child: _botones(),
      ),
    ]);
  }

  _datos() {
    return FutureBuilder(
        future: EstadoCuentaDireccion.getEstadoDireccion(
            usuarioBloc.perfil.lote.toString()),
        builder: (context, AsyncSnapshot<EstadoCuentaDireccion> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                "assets/icon/casita.gif",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            );
          }
          EstadoCuentaDireccion? modelo = snapshot.data;
          print(modelo?.data?.direccion?.direccion);
          telefono.text = usuarioBloc.perfil.telefono!;

          direccion.text = modelo?.data?.direccion?.direccion.toString() ?? "";
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _texto(),
              _numeroField(),
              SizedBox(
                height: 20,
              ),
              _direccionField(),
              SizedBox(
                height: 50,
              ),
            ],
          );
        });
  }

  _botones() {
    return Container(
        //color: Color.fromARGB(100, 0, 0, 0),
        height: 80,
        width: w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Regresar",
                    style: TextStyle(
                        color: usuarioBloc.miFraccionamiento.getColor(),
                        fontSize: 17))),
            TextButton(
              onPressed: () async {
                Provider.of<LoadingProvider>(context, listen: false)
                    .setLoad(true);

                orden.direccion = direccion.text;
                orden.telefono = telefono.text;

                Map<String, dynamic>? map =
                    await AybServices.sendPedidoDomicilio(orden);

                if (map.containsKey("idcuenta")) {
                  print("Antes");
                  carritoBloc.clean();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => RestauranteView(
                          qr: orden.clavePosicion.toString(), alerta: true),
                    ),
                  );
                } else if (map.containsKey("ERROR")) {
                  print("No se guardo");
                  print(map["es"]);
                  Fluttertoast.showToast(
                      msg: map["es"] + " - " + map["en"],
                      toastLength: Toast.LENGTH_LONG);
                }

                Provider.of<LoadingProvider>(context, listen: false)
                    .setLoad(false);
              },
              child: Text("Continuar",
                  style: TextStyle(color: Colors.white, fontSize: 17)),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      usuarioBloc.miFraccionamiento.getColor())),
            )
          ],
        ));
  }

  _texto() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Text("Verifica que tu información sea correcta"),
    );
  }

  _direccionField() {
    return Container(
        padding: EdgeInsets.only(left: 25, right: 20),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {},

          keyboardType: TextInputType.name,
          maxLines: 3,

          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hoverColor: Colors.purple,
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: "Dirección",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: direccion,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  _numeroField() {
    return Container(
        padding: EdgeInsets.only(left: 25, right: 20),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {},

          keyboardType: TextInputType.name,

          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hoverColor: Colors.purple,
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: "Número",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: telefono,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  Future<void> _validarMenu() async {
    try {
      Menu menu = await AybServices.getMenuJson(orden.clavePosicion.toString());

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
