import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:campestre/provider/splashProvider.dart';
import 'package:campestre/view/amenidades/casaClub/restaurante.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../../../bloc/carritoBloc.dart';
import '../../../bloc/usuario_bloc.dart';

class QrRestaurant extends StatefulWidget {
  const QrRestaurant({Key? key}) : super(key: key);

  @override
  State<QrRestaurant> createState() => _QrRestaurantState();
}

class _QrRestaurantState extends State<QrRestaurant> {
  UsuarioBloc usuarioBloc = UsuarioBloc();
  CarritoBloc carritoBloc = CarritoBloc();
  double? w, h;

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
          height: h,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              _opcionQR(),
              SizedBox(
                height: 20,
              ),
              _opcionDelivery(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _opcionDelivery() {
    return _opcion("Ordenar a domicilio", FontAwesome.motorcycle, () async {     
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RestauranteView(qr: "TO-HOME", alerta: false)),
        );
        carritoBloc.clean();
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
      } catch (e) {}
    });
  }

  _opcionQR() {
    return _opcion("Escanear código de mesa", FontAwesome.qrcode, () async {
      var result;
      try {
        result = await BarcodeScanner.scan();
        Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
        if (result.type.name.contains("Cancelled") ||
            result.type.name.contains("Failed")) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          return;
        }
        print(result.type);
        print(result.format);
        print(result.rawContent);

        print(result.rawContent);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RestauranteView(qr: result.rawContent, alerta: false)),
        );
        carritoBloc.clean();
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
      } catch (e) {}
    });
  }

  _opcionLlamarMesero() {
    return _opcion("Llamar a mesero", FontAwesome.hand_stop_o, () {});
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
}
