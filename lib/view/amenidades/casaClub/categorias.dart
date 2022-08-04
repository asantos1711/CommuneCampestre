import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../bloc/usuario_bloc.dart';
import '../../../models/restaurante/responseMenuJson.dart';
import '../../../services/serviciosAyB.dart';
import '../../../widgets/columnBuilder.dart';
import 'platillos.dart';

class OrdenarView extends StatefulWidget {
  String qr;
  OrdenarView({required this.qr});

  @override
  State<OrdenarView> createState() => _OrdenarViewState();
}

class _OrdenarViewState extends State<OrdenarView> {
  Menu? menu;
  double? w, h;
  late String qr;
  UsuarioBloc usuarioBloc = new UsuarioBloc();

  @override
  void initState() {
    qr = this.widget.qr;
    super.initState();
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
          "Ordenar",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [_menu()],
        ),
      ),
    );
  }

  _menu() {
    return FutureBuilder(
      future: AybServices.getMenuJson(qr),
      builder: (c, AsyncSnapshot<Menu> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: w,
            height: h,
            child: Center(
                child: Image.asset(
              "assets/icon/casita.gif",
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            )),
          );
        }
        menu = snapshot.data;

        if (menu?.familias == null || menu!.familias!.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              "No hay servicio disponible en este momento",
              style: TextStyle(
                  fontSize: 18,
                  color: usuarioBloc.miFraccionamiento.getColor()),
            ),
          );
        }

        return ColumnBuilder(
          mainAxisAlignment: MainAxisAlignment.start,
          itemCount: menu?.familias!.length ?? 0,
          itemBuilder: (c, i) {
            canLaunchUrlString(menu!.familias![i].imagen.toString());
            return Card(
              elevation: 0.5,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlatillosView(
                              idFamilia: menu!.familias![i],
                              qr: qr,
                            )),
                  );
                },
                title: Text(menu!.familias![i].nombre.toString()),

                /*leading:(  )?
                  Image.network(menu!.familias![i].imagen.toString()):
                  Image.network("https://elviajerofeliz.com/wp-content/uploads/2019/11/Comida-t%C3%ADpica-de-India-_-10-Platos-Imprescindibles.jpg").,*/
                trailing: InkWell(child: Icon(Icons.arrow_forward_ios)),
              ),
            );
          },
        );
      },
    );
  }
}
