import 'package:campestre/models/restaurante/responseMenuJson.dart';
import 'package:campestre/provider/carritoRestaurantProvider.dart';
import 'package:campestre/view/amenidades/casaClub/platilloCard.dart';
import 'package:campestre/widgets/columnBuilder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../bloc/carritoBloc.dart';
import '../../../bloc/usuario_bloc.dart';
import '../../../models/restaurante/platillosPedidos.dart';
import 'orden.dart';

class PlatillosView extends StatefulWidget {
  Familia idFamilia;
  String qr;
  PlatillosView({required this.idFamilia, required this.qr});

  @override
  State<PlatillosView> createState() => _PlatillosViewState();
}

class _PlatillosViewState extends State<PlatillosView> {
  double? w, h;

  UsuarioBloc usuarioBloc = UsuarioBloc();
  CarritoBloc carritoBloc = CarritoBloc();
  Menu? menu;
  late String qr;
  Familia? familiaPlatillos;
  @override
  void initState() {
    familiaPlatillos = this.widget.idFamilia;
    qr = this.widget.qr;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<CarritoProvider>(
        create: (context) => CarritoProvider(),
        builder: (context, _) {
          return Scaffold(
            floatingActionButton:
                /*Consumer<CarritoProvider>(builder: (context, provider, child) {
              return*/
                FloatingActionButton.extended(
              onPressed: () {
                List<PlatillosPedidos>? platillos = carritoBloc.platillos;
                /*Provider.of<CarritoProvider>(context, listen: false)
                        .platillos;*/
                print(platillos);
                if (platillos!.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => OrdenView(
                        platillos: platillos,
                        qr: qr,
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "Debe agregar al menos un platillo");
                }
              },
              label: Text('Ordenar'),
              icon: Icon(Icons.arrow_forward),
              backgroundColor: usuarioBloc.miFraccionamiento.getColor(),
            ),
            //}),
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
                "Platillos",
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
        });
  }

  _menu() {
    return ColumnBuilder(
      mainAxisAlignment: MainAxisAlignment.start,
      itemCount: familiaPlatillos?.platillos?.length ?? 0,
      itemBuilder: (c, i) {
        canLaunchUrlString(familiaPlatillos!.platillos![i].imagen.toString());

        return PlatilloCard(platillo: familiaPlatillos!.platillos![i]);
      },
    );
  }
}
