import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../bloc/usuario_bloc.dart';
import '../controls/connection.dart';
import '../models/fraccionamientos.dart';
import '../models/preferenciasUsuario.dart';
import 'splash.dart';

class FraccionamientoView extends StatefulWidget {
  const FraccionamientoView({Key? key}) : super(key: key);

  @override
  State<FraccionamientoView> createState() => _FraccionamientoViewState();
}

class _FraccionamientoViewState extends State<FraccionamientoView> {
  DatabaseServices databaseServices = new DatabaseServices();
  Fraccionamiento fraccionamientoSeleccionado = new Fraccionamiento();

  late List<Fraccionamiento> fracconamientosLista;
  UsuarioBloc bloc = new UsuarioBloc();

  PreferenciasUsuario preferenciasUsuario = new PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _preguntar();
          },
          child: Icon(FontAwesome.arrow_circle_o_right),
        ),
        body: FutureBuilder(
            future: databaseServices.getFracionamientos(),
            builder: (s, AsyncSnapshot<List<Fraccionamiento>?> data) {
              if (data.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Image.asset(
                    "assets/icon/casita.gif",
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                );
              }

              if (bloc.miFraccionamiento.id == null) {
                fracconamientosLista = data.data ?? [];
                print(fracconamientosLista);
                fraccionamientoSeleccionado = fracconamientosLista.first;
                bloc.miFraccionamiento = fraccionamientoSeleccionado;
                preferenciasUsuario
                    .setIdFraccionamiento(bloc.miFraccionamiento.id.toString());
              }

              return Center(
                child: DirectSelectContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Card(
                            elevation: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        child: DirectSelectList<
                                                Fraccionamiento>(
                                            values: fracconamientosLista,
                                            defaultItemIndex: 0,
                                            itemBuilder:
                                                (Fraccionamiento value) =>
                                                    getDropDownMenuItem(value),
                                            focusedItemDecoration:
                                                _getDslDecoration(),
                                            onItemSelectedListener:
                                                (item, index, context) {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(item.nombre
                                                          .toString())));
                                              //setState(() {
                                              fraccionamientoSeleccionado =
                                                  item;
                                              bloc.miFraccionamiento =
                                                  fraccionamientoSeleccionado;
                                              preferenciasUsuario
                                                  .setIdFraccionamiento(
                                                      item.id.toString());
                                              //});
                                            }),
                                        padding: EdgeInsets.only(left: 12))),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.unfold_more,
                                    color: Colors.black38,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  _preguntar() async {
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('¿Este es tu residencial?'),
        content: new Text(
            'Esta operación solo se puede realizar una vez o tendrá que reinstalar la aplicación'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Splash()),
              );
            },
            child: new Text('Sí'),
          ),
        ],
      ),
    );
  }

  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  DirectSelectItem<Fraccionamiento> getDropDownMenuItem(Fraccionamiento value) {
    return DirectSelectItem<Fraccionamiento>(
        itemHeight: 70,
        value: value,
        itemBuilder: (context, value) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.nombre.toString(),
                ),
                Image.network(
                  value.urlLogopng.toString(),
                  height: 30,
                )
              ],
            ),
          );
        });
  }
}
