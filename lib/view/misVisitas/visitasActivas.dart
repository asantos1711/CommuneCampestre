import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/invitadoModel.dart';
import 'package:campestre/view/menuInicio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class VisitasActivas extends StatefulWidget {
  const VisitasActivas({Key? key}) : super(key: key);

  @override
  State<VisitasActivas> createState() => _VisitasActivasState();
}

class _VisitasActivasState extends State<VisitasActivas> {
  List<Invitado> _list = [];
  DatabaseServices _databaseServices = new DatabaseServices();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  double w = 0.0, h = 0.0;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Mis visitas",
              style: TextStyle(fontSize: 20, color: Color(0xFF06323D))),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      MenuInicio(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF0C0C0C),
            ),
          ),
        ),
        body: FutureBuilder(
          future: _databaseServices.getVisitasActivas(),
          builder: (BuildContext context, AsyncSnapshot sn) {
            if (!sn.hasData)
              return Center(
                child: Image.asset(
                  "assets/icon/casita.gif",
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              );

            _list = sn.data;

            return ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                //return _contenido(DateFormat('dd/MM/yyyy').format(_mantenimientos.data!.mantenimientoList![index].payDate as DateTime), _mantenimientos.data!.mantenimientoList![index].status.toString().toCapitalized() , _mantenimientos.data!.mantenimientoList![index].amount.toString());

                return Container(
                  margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        title: _list[index].activo as bool == false
                            ? Text(
                                _list[index].nombre.toString(),
                                style: TextStyle(color: Color(0xFFA09FA1)),
                              )
                            : Text(
                                _list[index].nombre.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                        subtitle: textTipoVisita(
                            _list[index].tipoVisita.toString(),
                            _list[index].activo as bool == false
                                ? Color(0xFFA09FA1)
                                : Colors.black), //fefeff
                        children: <Widget>[
                          //_list[index].tiempos?.fechaEntrada != null ? ListTile(title: Text("Fecha de entrada permitada: "+formatter.format(_list[index].tiempos?.fechaEntrada as DateTime))) : SizedBox(),
                          //_list[index].tiempos?.fechaSalida != null ? ListTile(title: Text("Fecha de salida permitada: "+formatter.format(_list[index].tiempos?.fechaSalida as DateTime))) : SizedBox(),
                          _list[index].activo as bool
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _compartir(_list[index]),
                                    InkWell(
                                      onTap: () {
                                        _alertConfirmacion(_list[index]);
                                      },
                                      child: Icon(FontAwesomeIcons.trash,
                                          color: Colors.red),
                                    )
                                  ],
                                )
                              : SizedBox()
                        ],
                        trailing: _list[index].activo as bool
                            ? Text(
                                "Activo",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(
                                        255,
                                        _usuarioBloc.miFraccionamiento.color!.r,
                                        _usuarioBloc.miFraccionamiento.color!.g,
                                        _usuarioBloc
                                            .miFraccionamiento.color!.b)),
                              )
                            : Text(
                                "Caducado",
                                style: TextStyle(color: Color(0xFFA09FA1)),
                              ),
                      ),
                      /*Container(
                      child: Text(_list[index].nombre.toString()),
                    )*/
                    ],
                  ),
                );
              },
            );
          },
        ));
  }

  _compartir(Invitado _invitado) {
    return Container(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () async {
          /*String response;
          Reference reference = storage.ref().child("${_invitado.id}/qr");
          response = await reference.getDownloadURL();

          print(response);

          final shortener = BitLyShortener(
              accessToken: "784ce10cf099581554f2c50169308aa659f7ed35");
          final linkData = await shortener.generateShortLink(longUrl: response);
          String? urfinal = linkData.link;
          print(linkData.link);*/

          String urlPadre = "https://commune-cf48f.web.app/#/commune/qr/";
          String url = urlPadre + _invitado.id!;
          await Share.share("¡Hola!,este es el link para tu acceso ${url}");
        },
        icon: Icon(
          FontAwesomeIcons.shareFromSquare,
          color: Colors.grey[850],
          size: 20,
        ),
      ),
    );
  }

  _alertConfirmacion(Invitado _invitado) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // title: Container(child: Text("")), //Row(children: <Widget>[Icon(FontAwesomeIcons.checkCircle, color: Colors.green),Text("Envio éxitoso"),],),
              content: Container(
                  width: w - 170,
                  height: 120,
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                            "¿Estás seguro de que deseas eliminar esa visita?"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: Text(
                                  "Cancelar",
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
                                _invitado.activo = false;
                                _databaseServices.desactivarQRs(_invitado);
                                Fluttertoast.showToast(
                                  msg: 'Tu visita ha sido eliminada',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.grey[800],
                                );
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            VisitasActivas(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                );
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

  textTipoVisita(String visita, Color color) {
    switch (visita) {
      case "regularindefinido":
        return Text(
          "Regular Indefinido",
          style: TextStyle(color: color),
        );

      case "regulardefinido":
        // do something else
        return Text("Regular Definido", style: TextStyle(color: color));
      case "Trabajador":
        return Text("Trabajador", style: TextStyle(color: color));
      case "Mudanza":
        return Text("Mudanza", style: TextStyle(color: color));
      case "Paqueteria":
        return Text("Paquetería", style: TextStyle(color: color));
      default:
        return Text("Evento", style: TextStyle(color: color));
    }
  }
}
