import 'package:flutter/material.dart';

import '../../../bloc/carritoBloc.dart';
import '../../../bloc/usuario_bloc.dart';
import '../../../models/restaurante/platillosPedidos.dart';
import '../../../models/restaurante/responseMenuJson.dart';

class PlatilloCard extends StatefulWidget {
  Platillo platillo;
  PlatilloCard({required this.platillo});

  @override
  State<PlatilloCard> createState() => _PlatilloCardState();
}

class _PlatilloCardState extends State<PlatilloCard> {
  late Platillo platillo;
  UsuarioBloc usuarioBloc = UsuarioBloc();
  CarritoBloc carritoBloc = CarritoBloc();
  int cantidad = 0;
  double? w, h;
  TextEditingController comentarios = new TextEditingController();

  @override
  void initState() {
    platillo = this.widget.platillo;

    initDatos();
    super.initState();
  }

  initDatos() async {
    PlatillosPedidos? platillop =
        carritoBloc.getPlatillo(platillo.id.toString());
    if (platillop != null) {
      cantidad = int.parse(platillop.cantidad.toString());
      comentarios.text = platillop.extras ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Card(
      elevation: 0.5,
      child: ExpansionTile(
        title: Text(platillo.nombre.toString()),
        children: [
          Container(
            child: Image.asset(
              "assets/icon/carga.png",
            ), //height: 100,width: 100,
          ),
          Text(platillo.descripcion ?? "Sin descripción"),
          Text("\$ ${platillo.precio}"),
          Container(
            width: 120,
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: usuarioBloc.miFraccionamiento.getColor(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cantidad <= 0
                    ? SizedBox()
                    : Container(
                        width: 33,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                cantidad--;
                              });

                              if (cantidad <= 0) {
                                carritoBloc.addComentario(
                                    "", platillo.id.toString());
                              }
                              /*Provider.of<CarritoProvider>(context,
                                      listen: false)
                                  .restarPlatillo(platillo);*/
                              carritoBloc.restarPlatillo(platillo);
                            },
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 16,
                            )),
                      ),
                Container(
                  width: 33,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white),
                  child: Text(
                    '$cantidad',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                Container(
                  width: 33,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          cantidad++;
                        });
                        /*Provider.of<CarritoProvider>(context, listen: false)
                            .agregarPlatillo(platillo);*/
                        carritoBloc.agregarPlatillo(platillo);
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      )),
                ),
              ],
            ),
          ),
          _peticion(),
          SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  _peticion() {
    return cantidad <= 0
        ? SizedBox()
        : Container(
            width: w! * 0.5,
            child: TextField(
              controller: comentarios,
              keyboardType: TextInputType.text,
              minLines: 1,
              maxLines: 6,
              decoration: InputDecoration(label: Text("Comentarios")),
              onChanged: (text) {
                carritoBloc.addComentario(
                    comentarios.text, platillo.id.toString());
              },
            ),
          );
  }
}
