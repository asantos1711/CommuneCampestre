import 'package:campestre/models/restaurante/crearCuentaMovil.dart';
import 'package:campestre/models/restaurante/platillosPedidos.dart';
import 'package:campestre/services/serviciosAyB.dart';
import 'package:campestre/view/amenidades/casaClub/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../bloc/carritoBloc.dart';
import '../../../bloc/usuario_bloc.dart';
import '../../../models/restaurante/responseMenuJson.dart';
import '../../../provider/splashProvider.dart';
import '../../../widgets/columnBuilder.dart';
import 'direccionContacto.dart';

class OrdenView extends StatefulWidget {
  List<PlatillosPedidos> platillos;
  String qr;
  OrdenView({required this.platillos, required this.qr});

  @override
  State<OrdenView> createState() => _OrdenViewState();
}

class _OrdenViewState extends State<OrdenView> {
  double? w, h;

  late List<PlatillosPedidos> platillos;
  CarritoBloc carritoBloc = CarritoBloc();
  UsuarioBloc usuarioBloc = UsuarioBloc();
  Menu? menu;
  String? qr;
  Familia? familiaPlatillos;

  @override
  void initState() {
    platillos = this.widget.platillos;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    int total = 0;
    qr = this.widget.qr;

    platillos.forEach((element) {
      total += (element.precio! * int.parse(element.cantidad.toString()));
    });

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
            "Orden",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: SingleChildScrollView(
              child: Column(
            children: [
              _menu(),
            ],
          )),
        ),
      ),
      Positioned(
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 50),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Total \$" + total.toString(),
                        style: TextStyle(
                            color: usuarioBloc.miFraccionamiento.getColor(),
                            fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  color: Color.fromARGB(100, 0, 0, 0),
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
                                  color:
                                      usuarioBloc.miFraccionamiento.getColor(),
                                  fontSize: 17))),
                      TextButton(
                        onPressed: () async {
                          Provider.of<LoadingProvider>(context, listen: false)
                              .setLoad(true);
                          OrdenCompletaModel orden;

                          if (qr!.contains("TO-HOME")) {
                            orden = OrdenCompletaModel(
                                tipoMovil: "MOVIL_IOS",
                                articulos: platillos,
                                nombreHuesped: usuarioBloc.perfil.nombre,
                                menores: "0",
                                adultos: "1",
                                planAlimentos: "EP",
                                idioma: "es",
                                hotel: "100",
                                clavePosicion: qr,
                                tipoHuesped: "NULO");

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    DireccionCotacto(orden: orden),
                              ),
                            );
                          } else {
                            orden = OrdenCompletaModel(
                                tipoMovil: "MOVIL_IOS",
                                articulos: platillos,
                                nombreHuesped: usuarioBloc.perfil.nombre,
                                menores: "0",
                                adultos: "1",
                                planAlimentos: "EP",
                                idioma: "es",
                                hotel: "100",
                                clavePosicion: qr,
                                tipoHuesped: "NULO");

                            Map<String, dynamic>? map =
                                await AybServices.sendPedido(orden);

                            if (map.containsKey("idcuenta")) {
                              print("Antes");
                              carritoBloc.clean();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      RestauranteView(
                                          qr: qr.toString(), alerta: true),
                                ),
                              );
                              print("Despues");

                              print(map["idcuenta"]);
                            } else if (map.containsKey("ERROR")) {
                              print("No se guardo");
                              print(map["es"]);
                              Fluttertoast.showToast(
                                  msg: map["es"] + " - " + map["en"],
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          }

                          Provider.of<LoadingProvider>(context, listen: false)
                              .setLoad(false);
                        },
                        child: Text("Ordenar",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                usuarioBloc.miFraccionamiento.getColor())),
                      )
                    ],
                  )),
            ],
          )),
    ]);
  }

  _menu() {
    print(platillos);
    return ColumnBuilder(
      mainAxisAlignment: MainAxisAlignment.start,
      itemCount: carritoBloc.platillos?.length ?? 0,
      finalWidget: SizedBox(
        height: 100,
      ),
      itemBuilder: (c, i) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Card(
            child: Container(
              //height: 100,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                          width: w! * 0.5,
                          child: Text(
                            carritoBloc.platillos![i].nombre.toString(),
                            style: TextStyle(fontSize: 17),
                          )),
                      Container(
                          width: w! * 0.5,
                          child: Text(
                            "Cantidad: " +
                                carritoBloc.platillos![i].cantidad.toString(),
                            style: TextStyle(fontSize: 17),
                          )),
                    ],
                  ),
                  Text("Precio: " + carritoBloc.platillos![i].precio.toString(),
                      style: TextStyle(fontSize: 17)),
                ],
              ),
            ),
          ),
        );
      },
    );
    // });
  }
}
