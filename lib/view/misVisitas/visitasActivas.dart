import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../bloc/usuario_bloc.dart';
import '../../controls/connection.dart';
import '../../models/invitadoModel.dart';
import '../../provider/splashProvider.dart';
import '../../widgets/textfielborder.dart';
import '../menuInicio.dart';
import 'reactivaTrabajador.dart';

class VisitasActivas extends StatefulWidget {
  const VisitasActivas({Key? key}) : super(key: key);

  @override
  State<VisitasActivas> createState() => _VisitasActivasState();
}

class _VisitasActivasState extends State<VisitasActivas> {
  List<Invitado> _list = [];
  List<Invitado> _listCopy = [];
  DatabaseServices _databaseServices = new DatabaseServices();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  double w = 0.0, h = 0.0;
  static GlobalKey previewContainer = new GlobalKey();
  bool daySalected = false;

  TimeOfDay _fromTime = new TimeOfDay.now();
  TimeOfDay _fromTime2 = new TimeOfDay.now();
  DateTime fechaDia = DateTime.now();
  DateTime selectedDate = new DateTime.now().add(Duration(days: 1));
  DateTime fechaLlegada = DateTime.now();
  DateTime fechaSalida = DateTime.now().add(Duration(days: 3));
  TextEditingController _fecha = new TextEditingController();
  TextEditingController _fechaLlegada = new TextEditingController();
  TextEditingController _fechaSalida = new TextEditingController();

  TextEditingController editingController = TextEditingController();

  TextEditingController _hora = new TextEditingController();
  TextEditingController _hora2 = new TextEditingController();
  TextEditingController _placas = new TextEditingController();

  bool cargando = true;
  List<bool> values = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  final _formKeyDos = GlobalKey<FormState>();
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLista();
  }

  _getLista() async {
    _list = (await _databaseServices.getVisitasActivas())!;

    setState(() {
      // _list = (await _databaseServices.getVisitasActivas())!;
      _listCopy.addAll(_list);
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mis QRs",
            style: TextStyle(fontSize: 20, color: Color(0xFF06323D))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => MenuInicio(),
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
      body: (_list.isEmpty && _listCopy.isEmpty && cargando)
          ? Center(
              child: Image.asset(
                "assets/icon/casita.gif",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            )
          : ((_list.isEmpty && _listCopy.isEmpty))
              ? Center(
                  child: Container(
                    child: Text(
                      "No hay QRs registrados",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              : Container(
                  child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Buscar",
                          hintText: "Buscar",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            //return _contenido(DateFormat('dd/MM/yyyy').format(_mantenimientos.data!.mantenimientoList![index].payDate as DateTime), _mantenimientos.data!.mantenimientoList![index].status.toString().toCapitalized() , _mantenimientos.data!.mantenimientoList![index].amount.toString());

                            return Container(
                                margin: EdgeInsets.only(
                                    left: 30, right: 30, top: 15),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ExpansionTile(
                                        title: _list[index].activo as bool ==
                                                false
                                            ? Text(
                                                _list[index].nombre.toString(),
                                                style: TextStyle(
                                                    color: Color(0xFFA09FA1)),
                                              )
                                            : Text(
                                                _list[index].nombre.toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                        subtitle: textTipoVisita(
                                            _list[index].tipoVisita.toString(),
                                            _list[index].activo as bool == false
                                                ? Color(0xFFA09FA1)
                                                : Colors.black), //fefeff
                                        children: <Widget>[
                                          _tiemposDetalle(_list[index]),
                                          _verQR(_list[index].id.toString()),
                                          _list[index].fotoIdUrl != null
                                              ? _foto(
                                                  _list[index]
                                                      .fotoIdUrl
                                                      .toString(),
                                                  "Foto de identificación")
                                              : SizedBox(),
                                          _list[index].fotoPlacaUrl != null
                                              ? _foto(
                                                  _list[index]
                                                      .fotoPlacaUrl
                                                      .toString(),
                                                  "Foto de placa")
                                              : SizedBox(),
                                          //_list[index].tiempos?.fechaEntrada != null ? ListTile(title: Text("Fecha de entrada permitada: "+formatter.format(_list[index].tiempos?.fechaEntrada as DateTime))) : SizedBox(),
                                          //_list[index].tiempos?.fechaSalida != null ? ListTile(title: Text("Fecha de salida permitada: "+formatter.format(_list[index].tiempos?.fechaSalida as DateTime))) : SizedBox(),
                                          _list[index].activo as bool
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    _compartir(_list[index]),
                                                    InkWell(
                                                      onTap: () {
                                                        _alertConfirmacion(
                                                            _list[index]);
                                                      },
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .circleXmark,
                                                          color: Colors.orange),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _alertConfirmacionBorrado(
                                                            _list[index]);
                                                        //_alertConfirmacion(_list[index]);
                                                      },
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .trash,
                                                          color: Colors.red),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  margin: EdgeInsets.only(
                                                      bottom: 10, right: 25),
                                                  child: InkWell(
                                                    onTap: () {
                                                      _alertConfirmacionBorrado(
                                                          _list[index]);
                                                      //_alertConfirmacion(_list[index]);
                                                    },
                                                    child: Icon(
                                                        FontAwesomeIcons.trash,
                                                        color: Colors.red),
                                                  ),
                                                )
                                        ],
                                        trailing: _list[index].activo as bool
                                            ? Text(
                                                "Activo",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        255,
                                                        _usuarioBloc
                                                            .miFraccionamiento
                                                            .color!
                                                            .r,
                                                        _usuarioBloc
                                                            .miFraccionamiento
                                                            .color!
                                                            .g,
                                                        _usuarioBloc
                                                            .miFraccionamiento
                                                            .color!
                                                            .b)),
                                              )
                                            : Container(
                                                width: 100,
                                                child: esReactivable(
                                                        _list[index]
                                                            .tipoVisita!)
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  switch (_list[
                                                                          index]
                                                                      .tipoVisita) {
                                                                    case "Trabajador":
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        PageRouteBuilder(
                                                                          pageBuilder: (context, animation1, animation2) =>
                                                                              ReactivaTrabajador(invitado: _list[index]),
                                                                          transitionDuration:
                                                                              Duration(seconds: 0),
                                                                        ),
                                                                      );
                                                                      break;

                                                                    default:
                                                                      _modal(
                                                                          index);
                                                                      break;
                                                                  }
                                                                },
                                                                child: Text(
                                                                    "Reactivar"))
                                                          ])
                                                    : Text(
                                                        "Desactivado",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFA09FA1)),
                                                      ),
                                              ),
                                      ),
                                      /*Container(
                      child: Text(_list[index].nombre.toString()),
                    )*/
                                    ]));
                          }))
                ])),
    );
  }

  _alertConfirmacionBorrado(Invitado _invitado) {
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
                  height: h * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text(
                            "¿Estás seguro de que deseas eliminar este acceso?",
                            textAlign: TextAlign.center),
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
                                      color: _usuarioBloc.miFraccionamiento
                                          .getColor()),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: _usuarioBloc.miFraccionamiento
                                          .getColor()),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          15.0) //                 <--- border radius here
                                      ),
                                ),
                              )),
                          InkWell(
                              onTap: () {
                                _invitado.borrado = true;
                                _invitado.activo = false;
                                _databaseServices.desactivarQRs(_invitado);
                                Fluttertoast.showToast(
                                  msg: 'El QR ha sido eliminado',
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
                                  color:
                                      _usuarioBloc.miFraccionamiento.getColor(),
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

  void filterSearchResults(String query) {
    List<Invitado> dummySearchList = [];
    dummySearchList.addAll(_listCopy);
    if (query.isNotEmpty) {
      List<Invitado> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nombre!.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _list.clear();
        _list.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _list.clear();
        _list.addAll(_listCopy);
      });
    }
  }

  esReactivable(String tipo) {
    switch (tipo) {
      case "unicoDia":
        return true;
        break;
      case "regulardefinido":
        return true;
        break;
      case "Trabajador":
        return true;
        break;
      case "TrabajadorPermanente":
        return true;
        break;
      case "Mudanza":
        return true;
        break;
      default:
        return false;
    }
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

          String urlPadre = "https://commune-360.web.app/#/commune/qr/";
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
                  height: h * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: const Text(
                            "¿Estás seguro de que deseas desactivar este acceso?",
                            textAlign: TextAlign.center),
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
                                child: Text("Cancelar",
                                    style: TextStyle(
                                        letterSpacing: 0.8,
                                        color: _usuarioBloc.miFraccionamiento
                                            .getColor())),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: _usuarioBloc.miFraccionamiento
                                        .getColor(),
                                  ),
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
                                  msg: 'El QR ha sido desactivado',
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
                                child: const Text(
                                  "Aceptar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      _usuarioBloc.miFraccionamiento.getColor(),
                                  borderRadius: const BorderRadius.all(
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

  _fechaw(TextEditingController fecha, String text) {
    return Container(
        //width: 150,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {
            _showRangoFechas(context);
            //_selectDate();
          },
          readOnly: true,
          decoration: InputDecoration(
            hoverColor: _usuarioBloc.miFraccionamiento.getColor(),
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: text,
            hintText: "dd/MM/yyyy",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: fecha,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  _modal(int index) {
    Widget _widgetHorario() {
      switch (_list[index].tipoVisita) {
        case "regularindefinido":
          return Text(
            "Encargado de obra",
          );

        case "regulardefinido":
          // do something else
          return Column(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.spaceAround,
                children: [
                  _fechaw(_fechaLlegada, "Dia de inicio"),
                  _fechaw(_fechaSalida, "Día final"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _cancelatBtn(),
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () async {
                      Provider.of<LoadingProvider>(context, listen: false)
                          .setLoad(true);

                      if (!_formKeyDos.currentState!.validate()) {
                        Provider.of<LoadingProvider>(context, listen: false)
                            .setLoad(false);
                        Fluttertoast.showToast(
                            msg: "Revise todos los campos",
                            toastLength: Toast.LENGTH_LONG);
                        return;
                      }

                      Tiempos tiempos = new Tiempos();

                      tiempos.fechaEntrada = fechaLlegada;
                      tiempos.fechaSalida = fechaSalida;

                      _list[index].tiempos = tiempos;
                      _list[index].activo = true;

                      await _databaseServices.desactivarQRs(_list[index]);
                      Fluttertoast.showToast(
                        msg: 'El QR ha sido reactivada',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[800],
                      );
                      Navigator.pop(context, 'Reactivar');
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              VisitasActivas(),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );

                      Provider.of<LoadingProvider>(context, listen: false)
                          .setLoad(false);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: const Text(
                      'Reactivar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          );
        case "Trabajador":
          return Text("Trabajador");
        case "TrabajadorPermanente":
          return Text("Trabajador");

        case "Mudanza":
          return Column(
            children: [
              _fechaM(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _cancelatBtn(),
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () async {
                      Provider.of<LoadingProvider>(context, listen: false)
                          .setLoad(true);

                      if (!_formKeyDos.currentState!.validate()) {
                        Provider.of<LoadingProvider>(context, listen: false)
                            .setLoad(false);
                        Fluttertoast.showToast(
                            msg: "Revise todos los campos",
                            toastLength: Toast.LENGTH_LONG);
                        return;
                      }

                      _list[index].activo = true;
                      _list[index]..tiempos = new Tiempos();
                      _list[index].tiempos?.fechaEntrada = selectedDate;
                      _list[index].tiempos?.fechaSalida =
                          selectedDate.add(Duration(hours: 17, minutes: 59));

                      //_list[index].tiempos = tiempos;

                      await _databaseServices.desactivarQRs(_list[index]);
                      Fluttertoast.showToast(
                        msg: 'El QR ha sido reactivada',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[800],
                      );
                      Navigator.pop(context, 'Reactivar');
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              VisitasActivas(),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );

                      Provider.of<LoadingProvider>(context, listen: false)
                          .setLoad(false);

                      //  Alert(
                      //       context: context,
                      //       desc:
                      //           "Se genero la nota de entrega : ${ofertaVenta?.payload?.nota.toString()}",
                      //       buttons: [
                      //         DialogButton(
                      //           radius: BorderRadius.all(Radius.circular(25)),
                      //           color: Colors.blue,
                      //           child: Text(
                      //             "Aceptar",
                      //             style: TextStyle(
                      //                 color: Colors.white, fontSize: 20),
                      //           ),
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //           },
                      //           width: 120,
                      //         )
                      //       ],
                      //     ).show();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: const Text(
                      'Reactivar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          );
        case "unicoDia":
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fechaUnDia(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _cancelatBtn(),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        Provider.of<LoadingProvider>(context, listen: false)
                            .setLoad(true);

                        if (!_formKeyDos.currentState!.validate()) {
                          Provider.of<LoadingProvider>(context, listen: false)
                              .setLoad(false);
                          Fluttertoast.showToast(
                              msg: "Revise todos los campos",
                              toastLength: Toast.LENGTH_LONG);
                          return;
                        }

                        Tiempos tiempos = new Tiempos();
                        _list[index].activo = true;

                        DateTime seleccion = DateTime(selectedDate.year,
                            selectedDate.month, selectedDate.day);

                        tiempos.fechaEntrada = seleccion;
                        tiempos.fechaSalida =
                            seleccion.add(Duration(hours: 23, minutes: 59));
                        _list[index].tiempos = tiempos;

                        await _databaseServices.desactivarQRs(_list[index]);
                        Fluttertoast.showToast(
                          msg: 'El QR ha sido reactivada',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey[800],
                        );
                        Navigator.pop(context, 'Reactivar');
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                VisitasActivas(),
                            transitionDuration: Duration(seconds: 0),
                          ),
                        );

                        Provider.of<LoadingProvider>(context, listen: false)
                            .setLoad(false);

                        //  Alert(
                        //       context: context,
                        //       desc:
                        //           "Se genero la nota de entrega : ${ofertaVenta?.payload?.nota.toString()}",
                        //       buttons: [
                        //         DialogButton(
                        //           radius: BorderRadius.all(Radius.circular(25)),
                        //           color: Colors.blue,
                        //           child: Text(
                        //             "Aceptar",
                        //             style: TextStyle(
                        //                 color: Colors.white, fontSize: 20),
                        //           ),
                        //           onPressed: () {
                        //             Navigator.pop(context);
                        //           },
                        //           width: 120,
                        //         )
                        //       ],
                        //     ).show();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: const Text(
                        'Reactivar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ]);
        default:
          return Text(
            "Regular",
          );
      }
    }

    Widget horario = _widgetHorario();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (c, setState) {
        return Form(
            key: _formKeyDos,
            child: AlertDialog(
              title: const Text('Reactivar QR'),
              content: Container(
                width: w * 0.9,
                child: SingleChildScrollView(child: horario),
              ),
            ));
      }),
    );
  }

  _tiempos() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 20,
            ),
            child: _fechaw1(_fechaLlegada, "Dia de inicio"),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 0),
            alignment: Alignment.center,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: _usuarioBloc.miFraccionamiento.getColor(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: w - w / 3,
                    child: Text(
                      "Este acceso será válido por 180 días a partir de la fecha de inicio.",
                      style: TextStyle(
                          color: _usuarioBloc.miFraccionamiento.getColor()),
                    ),
                  )
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          !(_usuarioBloc.perfil.tipo?.contains("encargadoObra") ?? false)
              ? _subtitle("Días de trabajo")
              : SizedBox(),
          !(_usuarioBloc.perfil.tipo?.contains("encargadoObra") ?? false)
              ? _dias()
              : SizedBox(),

          !(_usuarioBloc.perfil.tipo?.contains("encargadoObra") ?? false)
              ? _subtitle("Hora")
              : SizedBox(),
          !(_usuarioBloc.perfil.tipo?.contains("encargadoObra") ?? false)
              ? Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _horaw1(),
                      _horaw2(),
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Los horarios de entrada de lunes a viernes son a las 7:30am y los sábados a las  9:00am. \nLa salida es a las 5:30 pm con tolerancia hasta las 6pm y los sabados a la 1:00pm.",
                    style: TextStyle(
                        color: _usuarioBloc.miFraccionamiento.getColor()),
                  ))
          //_rangoHoras()
        ],
      ),
    );
  }

  _horaw1() {
    return Container(
      width: (w - 80) / 2,
      // margin: EdgeInsets.only(left: 20, right: 15),
      child: TextFormField(
        //enableInteractiveSelection: false,
        onTap: () {
          _showTimePicker();
        },
        readOnly: true,
        decoration: InputDecoration(
          //prefixIcon: prefixIcon,
          filled: true,
          fillColor: Colors.white,
          labelText: "Desde",
          hintText: "hh:mm",
          enabledBorder: border(false),
          focusedBorder: border(true),
          border: border(false),
          errorText: null,
        ),
        controller: _hora,

        validator: (value) {
          if (value!.isEmpty) {
            return "Campo requerido";
          }
          return null;
        },
      ),
    );
  }

  _horaw2() {
    return Container(
      width: (w - 80) / 2,
      child: TextFormField(
        //enableInteractiveSelection: false,
        onTap: () {
          _showTimePicker2();
        },
        readOnly: true,
        decoration: InputDecoration(
          //prefixIcon: prefixIcon,
          filled: true,
          fillColor: Colors.white,
          labelText: "Hasta",
          hintText: "hh:mm",
          enabledBorder: border(false),
          focusedBorder: border(true),
          border: border(false),
          errorText: null,
        ),
        controller: _hora2,

        validator: (value) {
          if (value!.isEmpty) {
            return "Campo requerido";
          }
          return null;
        },
      ),
    );
  }

  _subtitle(String text) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(
                  255,
                  _usuarioBloc.miFraccionamiento.color!.r,
                  _usuarioBloc.miFraccionamiento.color!.g,
                  _usuarioBloc.miFraccionamiento.color!.b)),
        ));
  }

  _fechaw1(TextEditingController fecha, String text) {
    return Container(
        alignment: Alignment.centerLeft,
        width: (w - 80),
        //padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {
            //_showRangoFechas(context);
            _selectDate();
          },

          readOnly: true,
          decoration: InputDecoration(
            label: Text(text),
            //prefixIcon: prefixIcon,
            //filled: true,
            //fillColor: Color(0xFF5E1281),
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
          ),
          controller: fecha,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  Future<void> _showTimePicker2() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime2,
    );
    if (picked != null && picked != _fromTime2) {
      setState(() {
        _fromTime2 = picked;
        String minute = _fromTime2.minute < 10
            ? "0${_fromTime2.minute}"
            : _fromTime2.minute.toString();
        _hora2.text = _fromTime2.hour.toString() + ":" + minute;
      });
    }
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime,
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;

        _hora.text =
            _fromTime.hour.toString() + ":" + _fromTime.minute.toString();
      });
    }
  }

  _dias() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: WeekdaySelector(
        splashColor: Color.fromARGB(
            255,
            _usuarioBloc.miFraccionamiento.color!.r,
            _usuarioBloc.miFraccionamiento.color!.g,
            _usuarioBloc.miFraccionamiento.color!.b),
        selectedFillColor: Color.fromARGB(
            255,
            _usuarioBloc.miFraccionamiento.color!.r,
            _usuarioBloc.miFraccionamiento.color!.g,
            _usuarioBloc.miFraccionamiento.color!.b),
        shortWeekdays: ["D", "L", "M", "M", "J", "V", "S"],
        onChanged: (int day) {
          setState(() {
            // Use module % 7 as Sunday's index in the array is 0 and
            // DateTime.sunday constant integer value is 7.
            final index = day % 7;
            print(index);
            values[index] = !values[index];
          });
          print(values);

          daySalected = values.contains(true);
        },
        values: values,
      ),
    );
  }

  _fechaM() {
    return Container(
        //width: 150,
        padding: EdgeInsets.only(left: 10, right: 10),
        //padding: EdgeInsets.only(left: 80, right: 80),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {
            _selectDateM();
          },
          readOnly: true,
          decoration: InputDecoration(
            hoverColor: _usuarioBloc.miFraccionamiento.getColor(),
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: "Día",
            hintText: "dd/MM/yyyy",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: _fecha,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  Future<void> _selectDateM() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(
          DateTime.now().year,
          DateTime.now().month +
              int.parse(
                  _usuarioBloc.miFraccionamiento.rangoMesesMud.toString()),
          DateTime.now().day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  _usuarioBloc.miFraccionamiento.getColor(), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: _usuarioBloc.miFraccionamiento
                    .getColor(), // button text color
                foregroundColor:Colors.white
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) if (picked.weekday == 7) {
      Alert(
        context: context,
        title: "",
        desc: "No puede elegir el día domingo",
        buttons: [
          DialogButton(
            radius: BorderRadius.all(Radius.circular(25)),
            color: _usuarioBloc.miFraccionamiento.getColor(),
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      setState(() {
        selectedDate = picked as DateTime;

        //print("dia****");

        //print(selectedDate.weekday);

        _fecha.text = selectedDate.day.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.year.toString();
      });
    }
  }

  _cancelatBtn() {
    return TextButton(
      onPressed: () => Navigator.pop(context, 'Cancel'),
      child: const Text('Cancel'),
    );
  }

  _fechaUnDia() {
    return Container(
        //width: 270,
        margin: EdgeInsets.only(left: 10, right: 10),
        //padding: EdgeInsets.only(left: 80, right: 80),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {
            _selectDate();
          },
          readOnly: true,
          decoration: InputDecoration(
            hoverColor: _usuarioBloc.miFraccionamiento.getColor(),
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: "Día",
            hintText: "dd/MM/yyyy",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: _fecha,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  _usuarioBloc.miFraccionamiento.getColor(), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: _usuarioBloc.miFraccionamiento
                    .getColor(), // button text color
                foregroundColor:Colors.white
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        fechaDia = picked;
        //_fechaLlegada.text = DateFormat('dd-MM-yyyy').format(fechaLlegada);
        _fecha.text = selectedDate.day.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.year.toString();
      });
  }

  Future<Null> _showRangoFechas(BuildContext context) async {
    DateTimeRange initialRange =
        DateTimeRange(start: fechaLlegada, end: fechaSalida);
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      locale: const Locale("es", "MX"),
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      //lastDate: DateTime(2101),
      lastDate: DateTime(
          DateTime.now().year,
          DateTime.now().month +
              int.parse(
                  _usuarioBloc.miFraccionamiento.rangoMesesReg.toString()),
          DateTime.now().day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.from(
              colorScheme: ColorScheme.highContrastLight(
            primary: _usuarioBloc.miFraccionamiento.getColor(),
          )),
          child: child ?? SizedBox(),
        );
      },
    );

    if (picked != null) {
      int days = picked.end.difference(picked.start).inDays;
      print(days.toString());
      if (days >= 0 &&
          days <=
              int.parse(_usuarioBloc.miFraccionamiento.rangoDiasVisitasReg
                  .toString())) {
        print(picked);
        setState(() {
          fechaLlegada = picked.start;
          _fechaLlegada.text = DateFormat('dd-MM-yyyy').format(fechaLlegada);
          fechaSalida = picked.end;
          _fechaSalida.text = DateFormat('dd-MM-yyyy').format(fechaSalida);
        });
      } else {
        Alert(
          context: context,
          title: "",
          desc: "Puede elegir máximo " +
              _usuarioBloc.miFraccionamiento.rangoDiasVisitasReg.toString() +
              " días",
          buttons: [
            DialogButton(
              radius: BorderRadius.all(Radius.circular(25)),
              color: _usuarioBloc.miFraccionamiento.getColor(),
              child: Text(
                "Aceptar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      }
    }
  }

  _tiemposDetalle(Invitado _invitado) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 15, right: 10, top: 0),
            alignment: Alignment.bottomLeft,
            child: Text("Válido del: " +
                DateFormat('dd/MM/yyyy')
                    .format(_invitado.tiempos?.fechaEntrada as DateTime))),
        Container(
            margin: EdgeInsets.only(left: 15, right: 10, top: 0),
            alignment: Alignment.bottomLeft,
            child: Text("Hasta el : " +
                DateFormat('dd/MM/yyyy')
                    .format(_invitado.tiempos?.fechaSalida as DateTime))),
        Container(
            margin: EdgeInsets.only(left: 15, right: 10, top: 0),
            alignment: Alignment.bottomLeft,
            child: Text(_invitado.tiempos?.horaEntrada != ""
                ? "Desde las: " +
                    _invitado.tiempos!.horaEntrada.toString() +
                    " horas"
                : "")),
        Container(
            margin: EdgeInsets.only(left: 15, right: 10, top: 0, bottom: 10),
            alignment: Alignment.bottomLeft,
            child: Text(_invitado.tiempos?.horaEntrada != ""
                ? "Hasta las: " +
                    _invitado.tiempos!.horaSalida.toString() +
                    " horas"
                : "")),
      ],
    );
  }

  _verQR(String url) {
    return Container(
        margin: EdgeInsets.all(10),
        width: w - 100,
        //height: h! / 3,
        child: Column(
          children: [
            Text("QR de acceso",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left),
            SizedBox(
              height: 20,
            ),
            url.isNotEmpty
                ? InkWell(
                    onTap: () {
                      _alerta("Ver QR", url.isNotEmpty ? _qr(url) : SizedBox());
                    },
                    
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: _usuarioBloc.miFraccionamiento.getColor()                          
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0) //                 <--- border radius here
                        ),
                      ),
                      
                      child: Text(
                        "Ver QR",
                        style: TextStyle(
                            color: _usuarioBloc.miFraccionamiento.getColor()),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ));
  }

  _alerta(String txt, Widget wid) {
    return Alert(
      context: context,
      desc: txt,
      content:
          Container(width: w - 150, height: h / 4, child: wid //width: w!-150,
              ),
      buttons: [
        DialogButton(
          radius: BorderRadius.all(Radius.circular(25)),
          color: _usuarioBloc.miFraccionamiento.getColor(),
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  _qr(String idInvitado) {
    return RepaintBoundary(
      key: previewContainer,
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 50, right: 50, top: 10),
        //margin: EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        width: 200,
        //height: 250,
        child: InkWell(
            onTap: () async {
              //Platform.isAndroid ? _getWidgetImage2() : null;
            },
            child:
                //SizedBox()
                Column(
              children: [
                QrImage(
                  data: idInvitado,
                  version: QrVersions.auto,
                  size: 190,
                ),
              ],
            )),
      ),
    );
  }

  _foto(String url, String txt) {
    return Container(
        margin: EdgeInsets.all(10),
        width: w - 100,
        //height: h! / 3,
        child: Column(
          children: [
            Text(txt,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left),
            SizedBox(
              height: 20,
            ),
            url.isNotEmpty
                ?  InkWell(
                    onTap: () {
                       _alerta(
                          txt,
                          url.isNotEmpty
                              ? Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox());
                    },
                    
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: _usuarioBloc.miFraccionamiento.getColor()                          
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0) //                 <--- border radius here
                        ),
                      ),
                      
                      child: Text(
                        "Ver Foto",
                        style: TextStyle(
                            color: _usuarioBloc.miFraccionamiento.getColor()),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ));
  }

  textTipoVisita(String visita, Color color) {
    switch (visita) {
      case "regularindefinido":
        return Text(
          "Encargado de obra",
          style: TextStyle(color: color),
        );

      case "regulardefinido":
        // do something else
        return Text("Regular Definido", style: TextStyle(color: color));
      case "Trabajador":
        return Text("Trabajador", style: TextStyle(color: color));
      case "TrabajadorPermanente":
        return Text("Trabajador Permanente", style: TextStyle(color: color));
      case "Mudanza":
        return Text("Mudanza", style: TextStyle(color: color));
      case "Paqueteria":
        return Text("Paquetería", style: TextStyle(color: color));
      case "Evento":
        return Text("Paquetería", style: TextStyle(color: color));
      case "rentaVac":
        return Text("Renta local o AirBnb", style: TextStyle(color: color));
      case "Instantanea":
        return Text("Instantánea", style: TextStyle(color: color));
      case "unicoDia":
        return Text("Unico Dia", style: TextStyle(color: color));
      default:
        return Text(visita, style: TextStyle(color: color));
    }
  }
}


// import 'package:campestre/bloc/usuario_bloc.dart';
// import 'package:campestre/controls/connection.dart';
// import 'package:campestre/models/invitadoModel.dart';
// import 'package:campestre/provider/splashProvider.dart';
// import 'package:campestre/view/menuInicio.dart';
// import 'package:campestre/view/misVisitas/reactivaTrabajador.dart';
// import 'package:campestre/widgets/textfielborder.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:share_plus/share_plus.dart';

// class VisitasActivas extends StatefulWidget {
//   const VisitasActivas({Key? key}) : super(key: key);

//   @override
//   State<VisitasActivas> createState() => _VisitasActivasState();
// }

// class _VisitasActivasState extends State<VisitasActivas> {
//   List<Invitado> _list = [];
//   DatabaseServices _databaseServices = new DatabaseServices();
//   UsuarioBloc _usuarioBloc = new UsuarioBloc();
//   DateFormat formatter = DateFormat('dd-MM-yyyy');
//   double w = 0.0, h = 0.0;
//   final FirebaseStorage storage = FirebaseStorage.instance;
//   final _formKeyDos = GlobalKey<FormState>();
//   DateTime fechaLlegada = DateTime.now();
//   DateTime fechaSalida = DateTime.now().add(Duration(days: 3));
//   TextEditingController _fechaLlegada = new TextEditingController();
//   TextEditingController _fechaSalida = new TextEditingController();
//   TextEditingController _fecha = new TextEditingController();
//   DateTime fechaDia = DateTime.now();

//   TextEditingController editingController = TextEditingController();
//   DateTime selectedDate = new DateTime.now().add(Duration(days: 1));

//   TextEditingController _hora = new TextEditingController();
//   TextEditingController _hora2 = new TextEditingController();
//   TextEditingController _placas = new TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     w = MediaQuery.of(context).size.width;
//     h = MediaQuery.of(context).size.height;
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Text("Mis visitas",
//               style: TextStyle(fontSize: 20, color: Color(0xFF06323D))),
//           centerTitle: true,
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 PageRouteBuilder(
//                   pageBuilder: (context, animation1, animation2) =>
//                       MenuInicio(),
//                   transitionDuration: Duration(seconds: 0),
//                 ),
//               );
//             },
//             child: Icon(
//               Icons.arrow_back,
//               color: Color(0xFF0C0C0C),
//             ),
//           ),
//         ),
//         body: FutureBuilder(
//           future: _databaseServices.getVisitasActivas(),
//           builder: (BuildContext context, AsyncSnapshot sn) {
//             if (!sn.hasData)
//               return Center(
//                 child: Image.asset(
//                   "assets/icon/casita.gif",
//                   width: 200,
//                   height: 200,
//                   fit: BoxFit.contain,
//                 ),
//               );

//             _list = sn.data;

//             return ListView.builder(
//               itemCount: _list.length,
//               itemBuilder: (context, index) {
//                 //return _contenido(DateFormat('dd/MM/yyyy').format(_mantenimientos.data!.mantenimientoList![index].payDate as DateTime), _mantenimientos.data!.mantenimientoList![index].status.toString().toCapitalized() , _mantenimientos.data!.mantenimientoList![index].amount.toString());

//                 return Container(
//                   margin: EdgeInsets.only(left: 30, right: 30, top: 15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ExpansionTile(
//                         title: _list[index].activo as bool == false
//                             ? Text(
//                                 _list[index].nombre.toString(),
//                                 style: TextStyle(color: Color(0xFFA09FA1)),
//                               )
//                             : Text(
//                                 _list[index].nombre.toString(),
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                         subtitle: textTipoVisita(
//                             _list[index].tipoVisita.toString(),
//                             _list[index].activo as bool == false
//                                 ? Color(0xFFA09FA1)
//                                 : Colors.black), //fefeff
//                         children: <Widget>[
//                           Container(
//                               margin:
//                                   EdgeInsets.only(left: 15, right: 10, top: 0),
//                               alignment: Alignment.bottomLeft,
//                               child: Text("Válido del: " +
//                                   DateFormat('dd/MM/yyyy').format(_list[index]
//                                       .tiempos
//                                       ?.fechaEntrada as DateTime))),
//                           Container(
//                               margin:
//                                   EdgeInsets.only(left: 15, right: 10, top: 0),
//                               alignment: Alignment.bottomLeft,
//                               child: Text("Hasta el : " +
//                                   DateFormat('dd/MM/yyyy').format(_list[index]
//                                       .tiempos
//                                       ?.fechaSalida as DateTime))),
//                           Container(
//                               margin:
//                                   EdgeInsets.only(left: 15, right: 10, top: 0),
//                               alignment: Alignment.bottomLeft,
//                               child: Text(
//                                   _list[index].tiempos?.horaEntrada != ""
//                                       ? "Desde las: " +
//                                           _list[index]
//                                               .tiempos!
//                                               .horaEntrada
//                                               .toString() +
//                                           " horas"
//                                       : "")),
//                           Container(
//                               margin:
//                                   EdgeInsets.only(left: 15, right: 10, top: 0),
//                               alignment: Alignment.bottomLeft,
//                               child: Text(
//                                   _list[index].tiempos?.horaEntrada != ""
//                                       ? "Hasta las: " +
//                                           _list[index]
//                                               .tiempos!
//                                               .horaSalida
//                                               .toString() +
//                                           " horas"
//                                       : "")),
//                           //_list[index].tiempos?.fechaEntrada != null ? ListTile(title: Text("Fecha de entrada permitada: "+formatter.format(_list[index].tiempos?.fechaEntrada as DateTime))) : SizedBox(),
//                           //_list[index].tiempos?.fechaSalida != null ? ListTile(title: Text("Fecha de salida permitada: "+formatter.format(_list[index].tiempos?.fechaSalida as DateTime))) : SizedBox(),
//                           _list[index].activo as bool
//                               ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     _compartir(_list[index]),
//                                     InkWell(
//                                       onTap: () {
//                                         _alertConfirmacion(_list[index]);
//                                       },
//                                       child: Icon(FontAwesomeIcons.trash,
//                                           color: Colors.red),
//                                     )
//                                   ],
//                                 )
//                               : SizedBox()
//                         ],
//                         trailing: _list[index].activo as bool
//                             ? Text(
//                                 "Activo",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: Color.fromARGB(
//                                         255,
//                                         _usuarioBloc.miFraccionamiento.color!.r,
//                                         _usuarioBloc.miFraccionamiento.color!.g,
//                                         _usuarioBloc
//                                             .miFraccionamiento.color!.b)),
//                               )
//                             : Container(
//                                 width: 100,
//                                 child: esReactivable(_list[index].tipoVisita!)
//                                     ? Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                             TextButton(
//                                                 onPressed: () {
//                                                   switch (
//                                                       _list[index].tipoVisita) {
//                                                     case "Trabajador":
//                                                       Navigator.push(
//                                                         context,
//                                                         PageRouteBuilder(
//                                                           pageBuilder: (context,
//                                                                   animation1,
//                                                                   animation2) =>
//                                                               ReactivaTrabajador(
//                                                                   invitado: _list[
//                                                                       index]),
//                                                           transitionDuration:
//                                                               Duration(
//                                                                   seconds: 0),
//                                                         ),
//                                                       );
//                                                       break;
//                                                     default:
//                                                       _modal(index);
//                                                       break;
//                                                   }
//                                                 },
//                                                 child: Text("Reactivar"))
//                                           ])
//                                     : Text(
//                                         "Desactivado",
//                                         style:
//                                             TextStyle(color: Color(0xFFA09FA1)),
//                                       ),
//                               ),
//                       ),
//                       /*Container(
//                       child: Text(_list[index].nombre.toString()),
//                     )*/
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         ));
//   }

//   esReactivable(String tipo) {
//     switch (tipo) {
//       case "unicoDia":
//         return true;
//         break;
//       case "regulardefinido":
//         return true;
//         break;
//       case "Trabajador":
//         return true;
//         break;
//       case "TrabajadorPermanente":
//         return true;
//         break;
//       case "Mudanza":
//         return true;
//         break;
//       default:
//         return false;
//     }
//   }

//   _modal(int index) {
//     Widget _widgetHorario() {
//       switch (_list[index].tipoVisita) {
//         case "regularindefinido":
//           return Text(
//             "Encargado de obra",
//           );

//         case "regulardefinido":
//           // do something else
//           return Column(
//             children: [
//               Wrap(
//                 crossAxisAlignment: WrapCrossAlignment.start,
//                 alignment: WrapAlignment.spaceAround,
//                 children: [
//                   _fechaw(_fechaLlegada, "Dia de inicio"),
//                   _fechaw(_fechaSalida, "Día final"),
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   _cancelatBtn(),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       Provider.of<LoadingProvider>(context, listen: false)
//                           .setLoad(true);

//                       if (!_formKeyDos.currentState!.validate()) {
//                         Provider.of<LoadingProvider>(context, listen: false)
//                             .setLoad(false);
//                         Fluttertoast.showToast(
//                             msg: "Revise todos los campos",
//                             toastLength: Toast.LENGTH_LONG);
//                         return;
//                       }

//                       Tiempos tiempos = new Tiempos();
//                       _list[index].activo = true;

//                       tiempos.fechaEntrada = fechaLlegada;
//                       tiempos.fechaSalida = fechaSalida;

//                       _list[index].tiempos = tiempos;

//                       await _databaseServices.desactivarQRs(_list[index]);
//                       Fluttertoast.showToast(
//                         msg: 'El QR ha sido reactivado',
//                         toastLength: Toast.LENGTH_LONG,
//                         gravity: ToastGravity.BOTTOM,
//                         backgroundColor: Colors.grey[800],
//                       );
//                       Navigator.pop(context, 'Reactivar');
//                       Navigator.pushReplacement(
//                         context,
//                         PageRouteBuilder(
//                           pageBuilder: (context, animation1, animation2) =>
//                               VisitasActivas(),
//                           transitionDuration: Duration(seconds: 0),
//                         ),
//                       );

//                       Provider.of<LoadingProvider>(context, listen: false)
//                           .setLoad(false);
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.blue),
//                     ),
//                     child: const Text(
//                       'Reactivar',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           );
//         case "Trabajador":
//           return Text("Trabajador");
//         case "TrabajadorPermanente":
//           return Text("Trabajador");

//         case "Mudanza":
//           return Column(
//             children: [
//               _fechaM(),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   _cancelatBtn(),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       Provider.of<LoadingProvider>(context, listen: false)
//                           .setLoad(true);

//                       if (!_formKeyDos.currentState!.validate()) {
//                         Provider.of<LoadingProvider>(context, listen: false)
//                             .setLoad(false);
//                         Fluttertoast.showToast(
//                             msg: "Revise todos los campos",
//                             toastLength: Toast.LENGTH_LONG);
//                         return;
//                       }

//                       _list[index].activo = true;
//                       _list[index]..tiempos = new Tiempos();
//                       _list[index].tiempos?.fechaEntrada = selectedDate;
//                       _list[index].tiempos?.fechaSalida =
//                           selectedDate.add(Duration(hours: 17, minutes: 59));

//                       //_list[index].tiempos = tiempos;

//                       await _databaseServices.desactivarQRs(_list[index]);
//                       Fluttertoast.showToast(
//                         msg: 'El QR ha sido reactivado',
//                         toastLength: Toast.LENGTH_LONG,
//                         gravity: ToastGravity.BOTTOM,
//                         backgroundColor: Colors.grey[800],
//                       );
//                       Navigator.pop(context, 'Reactivar');
//                       Navigator.pushReplacement(
//                         context,
//                         PageRouteBuilder(
//                           pageBuilder: (context, animation1, animation2) =>
//                               VisitasActivas(),
//                           transitionDuration: Duration(seconds: 0),
//                         ),
//                       );

//                       Provider.of<LoadingProvider>(context, listen: false)
//                           .setLoad(false);

//                       //  Alert(
//                       //       context: context,
//                       //       desc:
//                       //           "Se genero la nota de entrega : ${ofertaVenta?.payload?.nota.toString()}",
//                       //       buttons: [
//                       //         DialogButton(
//                       //           radius: BorderRadius.all(Radius.circular(25)),
//                       //           color: Colors.blue,
//                       //           child: Text(
//                       //             "Aceptar",
//                       //             style: TextStyle(
//                       //                 color: Colors.white, fontSize: 20),
//                       //           ),
//                       //           onPressed: () {
//                       //             Navigator.pop(context);
//                       //           },
//                       //           width: 120,
//                       //         )
//                       //       ],
//                       //     ).show();
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.blue),
//                     ),
//                     child: const Text(
//                       'Reactivar',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           );
//         case "unicoDia":
//           return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _fechaUnDia(),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     _cancelatBtn(),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         Provider.of<LoadingProvider>(context, listen: false)
//                             .setLoad(true);

//                         if (!_formKeyDos.currentState!.validate()) {
//                           Provider.of<LoadingProvider>(context, listen: false)
//                               .setLoad(false);
//                           Fluttertoast.showToast(
//                               msg: "Revise todos los campos",
//                               toastLength: Toast.LENGTH_LONG);
//                           return;
//                         }

//                         Tiempos tiempos = new Tiempos();
//                         _list[index].activo = true;

//                         DateTime seleccion = DateTime(selectedDate.year,
//                             selectedDate.month, selectedDate.day);

//                         tiempos.fechaEntrada = seleccion;
//                         tiempos.fechaSalida =
//                             seleccion.add(Duration(hours: 23, minutes: 59));
//                         _list[index].tiempos = tiempos;

//                         await _databaseServices.desactivarQRs(_list[index]);
//                         Fluttertoast.showToast(
//                           msg: 'El QR ha sido reactivado',
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.BOTTOM,
//                           backgroundColor: Colors.grey[800],
//                         );
//                         Navigator.pop(context, 'Reactivar');
//                         Navigator.pushReplacement(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder: (context, animation1, animation2) =>
//                                 VisitasActivas(),
//                             transitionDuration: Duration(seconds: 0),
//                           ),
//                         );

//                         Provider.of<LoadingProvider>(context, listen: false)
//                             .setLoad(false);

//                         //  Alert(
//                         //       context: context,
//                         //       desc:
//                         //           "Se genero la nota de entrega : ${ofertaVenta?.payload?.nota.toString()}",
//                         //       buttons: [
//                         //         DialogButton(
//                         //           radius: BorderRadius.all(Radius.circular(25)),
//                         //           color: Colors.blue,
//                         //           child: Text(
//                         //             "Aceptar",
//                         //             style: TextStyle(
//                         //                 color: Colors.white, fontSize: 20),
//                         //           ),
//                         //           onPressed: () {
//                         //             Navigator.pop(context);
//                         //           },
//                         //           width: 120,
//                         //         )
//                         //       ],
//                         //     ).show();
//                       },
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(Colors.blue),
//                       ),
//                       child: const Text(
//                         'Reactivar',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 )
//               ]);
//         default:
//           return Text(
//             "Regular",
//           );
//       }
//     }

//     Widget horario = _widgetHorario();

//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) =>
//           StatefulBuilder(builder: (c, setState) {
//         return Form(
//             key: _formKeyDos,
//             child: AlertDialog(
//               title: const Text('Reactivar QR'),
//               content: Container(
//                 width: w * 0.9,
//                 child: SingleChildScrollView(child: horario),
//               ),
//             ));
//       }),
//     );
//   }

//   _fechaUnDia() {
//     return Container(
//         //width: 270,
//         margin: EdgeInsets.only(left: 10, right: 10),
//         //padding: EdgeInsets.only(left: 80, right: 80),
//         child: TextFormField(
//           //enableInteractiveSelection: false,
//           onTap: () {
//             _selectDate();
//           },
//           readOnly: true,
//           decoration: InputDecoration(
//             hoverColor: _usuarioBloc.miFraccionamiento.getColor(),
//             //prefixIcon: Icon(FontAwesome.calendar),
//             filled: true,
//             fillColor: Colors.white,
//             labelText: "Día",
//             hintText: "dd/MM/yyyy",
//             enabledBorder: border(false),
//             focusedBorder: border(true),
//             border: border(false),
//             errorText: null,
//           ),
//           controller: _fecha,

//           validator: (value) {
//             if (value!.isEmpty) {
//               return "Campo requerido";
//             }
//             return null;
//           },
//         ));
//   }

//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary:
//                   _usuarioBloc.miFraccionamiento.getColor(), // <-- SEE HERE
//               onPrimary: Colors.white, // <-- SEE HERE
//               onSurface: Colors.black, // <-- SEE HERE
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 primary: _usuarioBloc.miFraccionamiento
//                     .getColor(), // button text color
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//         fechaDia = picked;
//         //_fechaLlegada.text = DateFormat('dd-MM-yyyy').format(fechaLlegada);
//         _fecha.text = selectedDate.day.toString() +
//             "/" +
//             selectedDate.month.toString() +
//             "/" +
//             selectedDate.year.toString();
//       });
//   }

//   _fechaM() {
//     return Container(
//         //width: 150,
//         padding: EdgeInsets.only(left: 10, right: 10),
//         //padding: EdgeInsets.only(left: 80, right: 80),
//         child: TextFormField(
//           //enableInteractiveSelection: false,
//           onTap: () {
//             _selectDateM();
//           },
//           readOnly: true,
//           decoration: InputDecoration(
//             hoverColor: _usuarioBloc.miFraccionamiento.getColor(),
//             //prefixIcon: Icon(FontAwesome.calendar),
//             filled: true,
//             fillColor: Colors.white,
//             labelText: "Día",
//             hintText: "dd/MM/yyyy",
//             enabledBorder: border(false),
//             focusedBorder: border(true),
//             border: border(false),
//             errorText: null,
//           ),
//           controller: _fecha,

//           validator: (value) {
//             if (value!.isEmpty) {
//               return "Campo requerido";
//             }
//             return null;
//           },
//         ));
//   }

//   Future<void> _selectDateM() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(
//           DateTime.now().year,
//           DateTime.now().month +
//               int.parse(
//                   _usuarioBloc.miFraccionamiento.rangoMesesMud.toString()),
//           DateTime.now().day),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary:
//                   _usuarioBloc.miFraccionamiento.getColor(), // <-- SEE HERE
//               onPrimary: Colors.white, // <-- SEE HERE
//               onSurface: Colors.black, // <-- SEE HERE
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 primary: _usuarioBloc.miFraccionamiento
//                     .getColor(), // button text color
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != selectedDate) if (picked.weekday == 7) {
//       Alert(
//         context: context,
//         title: "",
//         desc: "No puede elegir el día domingo",
//         buttons: [
//           DialogButton(
//             radius: BorderRadius.all(Radius.circular(25)),
//             color: _usuarioBloc.miFraccionamiento.getColor(),
//             child: Text(
//               "Aceptar",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             width: 120,
//           )
//         ],
//       ).show();
//     } else {
//       setState(() {
//         selectedDate = picked as DateTime;

//         //print("dia****");

//         //print(selectedDate.weekday);

//         _fecha.text = selectedDate.day.toString() +
//             "/" +
//             selectedDate.month.toString() +
//             "/" +
//             selectedDate.year.toString();
//       });
//     }
//   }

//   _fechaw(TextEditingController fecha, String text) {
//     return Container(
//         //width: 150,
//         padding: EdgeInsets.only(left: 10, right: 10),
//         child: TextFormField(
//           //enableInteractiveSelection: false,
//           onTap: () {
//             _showRangoFechas(context);
//             //_selectDate();
//           },
//           readOnly: true,
//           decoration: InputDecoration(
//             hoverColor: _usuarioBloc.miFraccionamiento.getColor(),
//             //prefixIcon: Icon(FontAwesome.calendar),
//             filled: true,
//             fillColor: Colors.white,
//             labelText: text,
//             hintText: "dd/MM/yyyy",
//             enabledBorder: border(false),
//             focusedBorder: border(true),
//             border: border(false),
//             errorText: null,
//           ),
//           controller: fecha,

//           validator: (value) {
//             if (value!.isEmpty) {
//               return "Campo requerido";
//             }
//             return null;
//           },
//         ));
//   }

//   Future<Null> _showRangoFechas(BuildContext context) async {
//     DateTimeRange initialRange =
//         DateTimeRange(start: fechaLlegada, end: fechaSalida);
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       initialDateRange: initialRange,
//       locale: const Locale("es", "MX"),
//       firstDate: DateTime(
//           DateTime.now().year, DateTime.now().month, DateTime.now().day),
//       //lastDate: DateTime(2101),
//       lastDate: DateTime(
//           DateTime.now().year,
//           DateTime.now().month +
//               int.parse(
//                   _usuarioBloc.miFraccionamiento.rangoMesesReg.toString()),
//           DateTime.now().day),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.from(
//               colorScheme: ColorScheme.highContrastLight(
//             primary: _usuarioBloc.miFraccionamiento.getColor(),
//           )),
//           child: child ?? SizedBox(),
//         );
//       },
//     );

//     if (picked != null) {
//       int days = picked.end.difference(picked.start).inDays;
//       print(days.toString());
//       if (days >= 0 &&
//           days <=
//               int.parse(_usuarioBloc.miFraccionamiento.rangoDiasVisitasReg
//                   .toString())) {
//         print(picked);
//         setState(() {
//           fechaLlegada = picked.start;
//           _fechaLlegada.text = DateFormat('dd-MM-yyyy').format(fechaLlegada);
//           fechaSalida = picked.end;
//           _fechaSalida.text = DateFormat('dd-MM-yyyy').format(fechaSalida);
//         });
//       } else {
//         Alert(
//           context: context,
//           title: "",
//           desc: "Puede elegir máximo " +
//               _usuarioBloc.miFraccionamiento.rangoDiasVisitasReg.toString() +
//               " días",
//           buttons: [
//             DialogButton(
//               radius: BorderRadius.all(Radius.circular(25)),
//               color: _usuarioBloc.miFraccionamiento.getColor(),
//               child: Text(
//                 "Aceptar",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               width: 120,
//             )
//           ],
//         ).show();
//       }
//     }
//   }

//   _compartir(Invitado _invitado) {
//     return Container(
//       alignment: Alignment.centerRight,
//       child: IconButton(
//         onPressed: () async {
//           /*String response;
//           Reference reference = storage.ref().child("${_invitado.id}/qr");
//           response = await reference.getDownloadURL();

//           print(response);

//           final shortener = BitLyShortener(
//               accessToken: "784ce10cf099581554f2c50169308aa659f7ed35");
//           final linkData = await shortener.generateShortLink(longUrl: response);
//           String? urfinal = linkData.link;
//           print(linkData.link);*/

//           String urlPadre = "https://communecampestre.web.app/#/commune/qr/";
//           String url = urlPadre + _invitado.id!;
//           await Share.share("¡Hola!,este es el link para tu acceso ${url}");
//         },
//         icon: Icon(
//           FontAwesomeIcons.shareFromSquare,
//           color: Colors.grey[850],
//           size: 20,
//         ),
//       ),
//     );
//   }

//   _alertConfirmacion(Invitado _invitado) {
//     showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) {
//           return AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0)),
//               // title: Container(child: Text("")), //Row(children: <Widget>[Icon(FontAwesomeIcons.checkCircle, color: Colors.green),Text("Envio éxitoso"),],),
//               content: Container(
//                   width: w - 170,
//                   height: h * 0.3,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         child: Text(
//                             "¿Estás seguro de que deseas eliminar este acceso?"),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Container(
//                                 child: Text(
//                                   "Cancelar",
//                                   style: TextStyle(
//                                       letterSpacing: 0.8,
//                                       color: Color.fromARGB(
//                                           255,
//                                           _usuarioBloc
//                                               .miFraccionamiento.color!.r,
//                                           _usuarioBloc
//                                               .miFraccionamiento.color!.g,
//                                           _usuarioBloc
//                                               .miFraccionamiento.color!.b)),
//                                 ),
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       width: 1.0,
//                                       color: Color.fromARGB(
//                                           255,
//                                           _usuarioBloc
//                                               .miFraccionamiento.color!.r,
//                                           _usuarioBloc
//                                               .miFraccionamiento.color!.g,
//                                           _usuarioBloc
//                                               .miFraccionamiento.color!.b)),
//                                   borderRadius: BorderRadius.all(
//                                       Radius.circular(
//                                           15.0) //                 <--- border radius here
//                                       ),
//                                 ),
//                               )),
//                           InkWell(
//                               onTap: () {
//                                 _invitado.activo = false;
//                                 _databaseServices.desactivarQRs(_invitado);
//                                 /*Fluttertoast.showToast(
//                                   msg: 'Tu visita ha sido eliminada',
//                                   toastLength: Toast.LENGTH_LONG,
//                                   gravity: ToastGravity.BOTTOM,
//                                   backgroundColor: Colors.grey[800],
//                                 );*/

//                                 Alert(
//                                   context: context,
//                                   desc: 'Tu visita ha sido eliminada ',
//                                   buttons: [
//                                     DialogButton(
//                                       radius:
//                                           BorderRadius.all(Radius.circular(25)),
//                                       color: _usuarioBloc.miFraccionamiento
//                                           .getColor(),
//                                       child: Text(
//                                         "Aceptar",
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 20),
//                                       ),
//                                       onPressed: () {
//                                         //Navigator.pop(context);
//                                         Navigator.pushReplacement(
//                                           context,
//                                           PageRouteBuilder(
//                                             pageBuilder: (context, animation1,
//                                                     animation2) =>
//                                                 VisitasActivas(),
//                                             transitionDuration:
//                                                 Duration(seconds: 0),
//                                           ),
//                                         );
//                                       },
//                                       width: 120,
//                                     )
//                                   ],
//                                 ).show();
//                               },
//                               child: Container(
//                                 child: Text(
//                                   "Aceptar",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     letterSpacing: 0.8,
//                                   ),
//                                 ),
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: Color.fromARGB(
//                                       255,
//                                       _usuarioBloc.miFraccionamiento.color!.r,
//                                       _usuarioBloc.miFraccionamiento.color!.g,
//                                       _usuarioBloc.miFraccionamiento.color!.b),
//                                   borderRadius: BorderRadius.all(
//                                       Radius.circular(
//                                           15.0) //                 <--- border radius here
//                                       ),
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ],
//                   )));
//         });
//   }

//   textTipoVisita(String visita, Color color) {
//     switch (visita) {
//       case "regularindefinido":
//         return Text(
//           "Regular Indefinido",
//           style: TextStyle(color: color),
//         );

//       case "regulardefinido":
//         // do something else
//         return Text("Regular Definido", style: TextStyle(color: color));
//       case "Trabajador":
//         return Text("Trabajador", style: TextStyle(color: color));
//       case "Mudanza":
//         return Text("Mudanza", style: TextStyle(color: color));
//       case "Paqueteria":
//         return Text("Paquetería", style: TextStyle(color: color));
//       case "unicoDia":
//         return Text("Único día", style: TextStyle(color: color));
//       default:
//         return Text("Evento", style: TextStyle(color: color));
//     }
//   }

//   _cancelatBtn() {
//     return TextButton(
//       onPressed: () => Navigator.pop(context, 'Cancel'),
//       child: const Text('Cancelar'),
//     );
//   }
// }
