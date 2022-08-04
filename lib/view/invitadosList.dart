import 'package:flutter/material.dart';

import '../bloc/usuario_bloc.dart';
import '../controls/connection.dart';
import '../models/invitadoModel.dart';
import '../widgets/ui_helper.dart';
import 'invitados.dart';

class InvitadosList extends StatefulWidget {
  @override
  _InvitadosListState createState() => _InvitadosListState();
}

class _InvitadosListState extends State<InvitadosList> {
  bool isLoading = false, recurrente = false;
  UsuarioBloc usuarioBloc = new UsuarioBloc();
  UIHelper u = new UIHelper();
  double? w, h;

  DatabaseServices db = new DatabaseServices();

  _bloquearPantalla() {
    this.setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    isLoading = false;
    // TODO: implement initState
    //bloquearPantalla();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    //if (isLoading) _bloquearPantalla(false);
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: u.bottomBar(h, w!, 1, context),
        body: Stack(children: <Widget>[
          ListView(children: [
            Container(
              width: w! - 50,
              margin: EdgeInsets.only(top: h! / 40, left: 20, right: 20),
              child: Column(children: [
                SizedBox(
                  height: 25,
                ),
                Container(
                    child: Text("Invitados",
                        style:
                            TextStyle(color: Color(0xFF434343), fontSize: 22))),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: w! - 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500]!,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      border: Border.all(width: 1, style: BorderStyle.none),
                      borderRadius: BorderRadius.all(Radius.circular(
                              15.0) //         <--- border radius here
                          )),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Text(
                        "Lista de invitados recurrentes",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF434343),
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      FutureBuilder(
                        future:
                            db.getRecurrentes(usuarioBloc.perfil.idResidente!),
                        builder: (c, v) {
                          if (!v.hasData) {
                            usuarioBloc.listRecurrentes =
                                v.data as List<Invitado>?;
                            return _listaRecurrentes();
                          }
                          usuarioBloc.listRecurrentes =
                              v.data as List<Invitado>?;
                          return _listaRecurrentes();
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ]),
            )
          ])
        ]));
  }

  Widget _listaRecurrentes() {
    final lista = <Widget>[];
    print(usuarioBloc.listRecurrentes);
    if (usuarioBloc.listRecurrentes == null) {
      return _vacio();
    }
    usuarioBloc.listRecurrentes!.forEach((element) {
      lista.add(
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      InvitadosView(
                    invitado: element,
                  ),
                  transitionDuration: Duration(seconds: 0),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(element.nombre!),
                //subtitle: Text(""),
                trailing: Icon(Icons.more_vert),
              ),
            )),
      );
    });

    lista.add(SizedBox(height: 15));
    lista.add(
      InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    InvitadosView(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
          },
          child: Container(
            width: w! - 100,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF5562A1),
              borderRadius: BorderRadius.all(
                  Radius.circular(30.0) //         <--- border radius here
                  ),
            ),
            child: Text(
              "Crear invitado",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          )),
    );
    return Column(children: lista);
  }

  Widget _vacio() {
    return Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Image.asset("assets/images/to_do.png"),
            SizedBox(height: 15),
            Text(
              "Aún no has añadidido invitados a tu lista de recurrentes",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          InvitadosView(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
                child: Container(
                  width: w! - 100,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF5562A1),
                    borderRadius: BorderRadius.all(
                        Radius.circular(30.0) //         <--- border radius here
                        ),
                  ),
                  child: Text(
                    "Crear invitado",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )),
            SizedBox(height: 15),
          ],
        ));
  }
}
