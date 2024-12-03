import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../bloc/usuario_bloc.dart';
import '../../controls/connection.dart';
import '../../models/invitadoModel.dart';
import '../../provider/splashProvider.dart';
import '../../widgets/textfielborder.dart';
import '../../widgets/ui_helper.dart';
import '../confirmacionVisita.dart';

class RentaVacacionalView extends StatefulWidget {
  const RentaVacacionalView({Key? key}) : super(key: key);

  @override
  State<RentaVacacionalView> createState() => _RentaVacacionalViewState();
}

class _RentaVacacionalViewState extends State<RentaVacacionalView> {
  UIHelper u = new UIHelper();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombre = new TextEditingController();
  TextEditingController _placas = new TextEditingController();
  TextEditingController _fecha = new TextEditingController();
  TextEditingController _hora = new TextEditingController();
  DateTime fechaLlegada = DateTime.now();
  DateTime fechaDia = DateTime.now();
  DateTime fechaSalida = DateTime.now().add(Duration(days: 1));

  TextEditingController _fechaLlegada = new TextEditingController();
  TextEditingController _fechaSalida = new TextEditingController();
  TextEditingController _fotoIdUrl = new TextEditingController();
  TextEditingController _acompanantes = new TextEditingController();
  DatabaseServices db = new DatabaseServices();
  DateTime selectedDate = new DateTime.now();
  TimeOfDay _fromTime = new TimeOfDay.now();
  Invitado _invitado = new Invitado();
  double? w, h;
  final picker = ImagePicker();
  File? _image;
  bool? isLoading, recurrente = false;
  UsuarioBloc usuarioBloc = new UsuarioBloc();
  bool? onCharge;
  bool typePhoto = false;
  bool typePhotoPlaca = false;
  _bloquearPantalla() {
    this.setState(() {
      isLoading = !isLoading!;
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    //if (isLoading) _bloquearPantalla(false);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Acceso a visitas",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF06323D),
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF0C0C0C),
            ),
          ),
        ),
        //bottomNavigationBar: u.bottomBar(h, w!, 1, context),
        body: _form());
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 15, right: 20),
          children: [
            _title("Renta local o Airbnb"),
            _nombreField(),
            _nombreFieldAcompanantes(),
            _subtitle("Fecha de acceso"),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.spaceAround,
                      children: [
                        _fechaw(_fechaLlegada, "Dia de inicio"),
                        _fechaw(_fechaSalida, "Día final"),
                      ],
                    ),
                  ],
                )),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20),
              child: Text(
                "Foto de la identificación del visitante (requerida)",
                style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(
                        255,
                        usuarioBloc.miFraccionamiento.color!.r,
                        usuarioBloc.miFraccionamiento.color!.g,
                        usuarioBloc.miFraccionamiento.color!.b)),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                "Te recomendamos una foto de alta calidad para poder confirmar la identidad al momento de accesar.",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            _getImageid(),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Text(
                "Foto de la placa del vehículo (opcional)",
                style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(
                        255,
                        usuarioBloc.miFraccionamiento.color!.r,
                        usuarioBloc.miFraccionamiento.color!.g,
                        usuarioBloc.miFraccionamiento.color!.b)),
              ),
            ),
            _getImageplaca(),
            SizedBox(
              height: 30,
            ),
            //_recurrente(),
            _button(),
            SizedBox(
              height: 30,
            ),
          ],
        ));
  }

  _nombreFieldAcompanantes() {
    return Container(
        padding: EdgeInsets.only(left: 25, right: 20),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {},
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hoverColor: Colors.purple,
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: "Cantidad de acompañantes",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: _acompanantes,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  _nombreField() {
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
            labelText: "Nombre",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: _nombre,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            if (int.tryParse(_acompanantes.text) == null) {
              return "Insertar un número";
            }
            return null;
          },
        ));
  }

  _subtitle(String texto) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          texto,
          style: TextStyle(
              color: Color.fromARGB(
                  255,
                  usuarioBloc.miFraccionamiento.color!.r,
                  usuarioBloc.miFraccionamiento.color!.g,
                  usuarioBloc.miFraccionamiento.color!.b),
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ));
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
            hoverColor: Color.fromARGB(
                255,
                usuarioBloc.miFraccionamiento.color!.r,
                usuarioBloc.miFraccionamiento.color!.g,
                usuarioBloc.miFraccionamiento.color!.b),
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

  Widget _button() {
    //print(usuarioBloc.perfil.nombre);
    return InkWell(
      onTap: () async {
        Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
        if (!_formKey.currentState!.validate()) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          /*Fluttertoast.showToast(
            msg: "Complete los campos faltantes",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );*/
          
          Alert(
            context: context,
            desc: 'Complete los campos faltantes',
            buttons: [
              DialogButton(
                radius: BorderRadius.all(Radius.circular(25)),
                color: usuarioBloc.miFraccionamiento.getColor(),
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
          return;
        }

        if (int.tryParse(_acompanantes.text) == null) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          /*Fluttertoast.showToast(
            msg: "El campo acompañantes debe ser un número",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );*/

          Alert(
            context: context,
            desc: 'El campo acompañantes debe ser un número',
            buttons: [
              DialogButton(
                radius: BorderRadius.all(Radius.circular(25)),
                color: usuarioBloc.miFraccionamiento.getColor(),
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
          return;
        }
        if ((_invitado.fotoId ?? null) == null) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          /*Fluttertoast.showToast(
            msg: "Agrega uan foto de identificación",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );*/

          Alert(
            context: context,
            desc: 'Agrega una foto de identificación',
            buttons: [
              DialogButton(
                radius: BorderRadius.all(Radius.circular(25)),
                color: usuarioBloc.miFraccionamiento.getColor(),
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
          return;
        }
        setState(() {
          selectedDate = new DateTime(
              selectedDate.year, selectedDate.month, selectedDate.day);
        });
        print("por guardar");
        try {
          _invitado.nombre = _nombre.text;
          /* _invitado!.telefono = _phone.text;
          _invitado!.email = _email.text;
          _invitado!.numAcompa = _acomp.text;*/
          _invitado.tipoVisita = "rentaVac";
          _invitado.domicilio = usuarioBloc.perfil.direccion;
          _invitado.idResidente = usuarioBloc.perfil.idResidente;
          _invitado.nombreResidente = usuarioBloc.perfil.nombre;
          _invitado.idFraccionamiento = usuarioBloc.miFraccionamiento.id;

          _invitado.activo = true;

          _invitado.acompanantes = _acompanantes.text;
          Tiempos tiempos = new Tiempos();
          tiempos.fechaEntrada = fechaLlegada;
          tiempos.fechaSalida = fechaSalida;

          _invitado.tiempos = tiempos;

          _invitado.idLote = usuarioBloc.perfil.lote;
          _invitado.idRegistro = usuarioBloc.perfil.idRegistro;

          _invitado.fotoIdUrl = "";
          _invitado.fotoPlacaUrl = "";

          late var bytes; // data being hashed
          if (!TipoVisita.regularIndefinido
              .contains(_invitado.tipoVisita.toString())) {
            bytes = utf8.encode(
                _invitado.nombre! + _invitado.tiempos!.fechaEntrada.toString());
          } else {
            bytes = utf8.encode(_invitado.nombre! + DateTime.now().toString());
          }

          var digest = sha1.convert(bytes);
          _invitado.id = digest.toString();

          /*_guardaFoto().whenComplete(() {
            //_bloquearPantalla();
            db.guardarDatos(_invitado);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfirmacionVistitas()),
            );
          });*/

          if ((_invitado.fotoId ?? null) == null &&
              (_invitado.fotoPlaca ?? null) == null) {
            await db.guardarDatos(_invitado);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfirmacionVistitas()),
            );
          } else {
            await _guardaFoto();
            _invitado.placas = _placas.text;

            await db.guardarDatos(_invitado).whenComplete(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfirmacionVistitas()),
              );
            });
          }
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        } catch (ex) {
          print("un error *****" + ex.toString());
        }

        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
      },
      child: Container(
        width: w! - 200,
        margin: EdgeInsets.only(left: 30, right: 30),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(
              255,
              usuarioBloc.miFraccionamiento.color!.r,
              usuarioBloc.miFraccionamiento.color!.g,
              usuarioBloc.miFraccionamiento.color!.b),
          borderRadius: BorderRadius.all(
              Radius.circular(30.0) //         <--- border radius here
              ),
        ),
        child: Text(
          "Continuar",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
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
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.from(
              colorScheme: ColorScheme.highContrastLight(
            primary: usuarioBloc.miFraccionamiento.getColor(),
          )),
          child: child ?? SizedBox(),
        );
      },
    );

    if (picked != null) {
      int days = picked.end.difference(picked.start).inDays;
      print(days.toString());
      if (days >= 0 && days <= usuarioBloc.miFraccionamiento.rangoDiasVisitasReg!.toInt()) {
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
          desc: "Máximo "+usuarioBloc.miFraccionamiento.rangoDiasVisitasReg.toString() +" días",
          buttons: [
            DialogButton(
              radius: BorderRadius.all(Radius.circular(25)),
              color: usuarioBloc.miFraccionamiento.getColor(),
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

  _getImageid() {
    return InkWell(
        onTap: () => _alert(),
        child: Container(
          margin: EdgeInsets.all(20),
          width: 180,
          height: 180,
          child: _invitado.fotoId != null
              ? Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      width: w!,
                      child: Image.file(
                        _invitado.fotoId!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 15,
                      child: Container(
                          //width: 50,
                          child: InkWell(
                        onTap: () => getImage(),
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white.withOpacity(0.5),
                            child: Icon(
                              FontAwesomeIcons.edit,
                              color: Colors.white,
                              size: 15,
                            )),
                      )),
                    ),
                  ],
                )
              : DottedBorder(
                  color: Colors.black,
                  strokeWidth: 1,
                  radius: const Radius.circular(60),
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      //width: 180,
                      height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: Icon(
                              FontAwesomeIcons.plus,
                              color: Color.fromARGB(
                                  255,
                                  usuarioBloc.miFraccionamiento.color!.r,
                                  usuarioBloc.miFraccionamiento.color!.g,
                                  usuarioBloc.miFraccionamiento.color!.b),
                              size: 15,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color.fromARGB(
                                      255,
                                      usuarioBloc.miFraccionamiento.color!.r,
                                      usuarioBloc.miFraccionamiento.color!.g,
                                      usuarioBloc.miFraccionamiento.color!.b),
                                  width: 2),
                            ),
                          ),
                          Text("Agregar foto")
                        ],
                      ))),
        ));
  }

  _alert() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // title: Container(child: Text("")), //Row(children: <Widget>[Icon(FontAwesomeIcons.checkCircle, color: Colors.green),Text("Envio éxitoso"),],),
              content: Container(
                width: w! - 170,
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          typePhoto = false;
                          getImage();
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 10),
                            Icon(
                              FontAwesomeIcons.camera,
                              color: Color.fromARGB(
                                  255,
                                  usuarioBloc.miFraccionamiento.color!.r,
                                  usuarioBloc.miFraccionamiento.color!.g,
                                  usuarioBloc.miFraccionamiento.color!.b),
                            ),
                            SizedBox(height: 10),
                            Text("Cámara")
                          ],
                        )),
                    InkWell(
                        onTap: () {
                          typePhoto = true;
                          getImage();
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Icon(FontAwesomeIcons.images,
                                color: Color.fromARGB(
                                    255,
                                    usuarioBloc.miFraccionamiento.color!.r,
                                    usuarioBloc.miFraccionamiento.color!.g,
                                    usuarioBloc.miFraccionamiento.color!.b)),
                            SizedBox(height: 10),
                            Text("Galería")
                          ],
                        )),
                  ],
                ),
              ));
        });
  }

  _alertPlaca() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // title: Container(child: Text("")), //Row(children: <Widget>[Icon(FontAwesomeIcons.checkCircle, color: Colors.green),Text("Envio éxitoso"),],),
              content: Container(
                width: w! - 170,
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          typePhotoPlaca = false;
                          getImagePlaca();
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 10),
                            Icon(
                              FontAwesomeIcons.camera,
                              color: Color.fromARGB(
                                  255,
                                  usuarioBloc.miFraccionamiento.color!.r,
                                  usuarioBloc.miFraccionamiento.color!.g,
                                  usuarioBloc.miFraccionamiento.color!.b),
                            ),
                            SizedBox(height: 10),
                            Text("Cámara")
                          ],
                        )),
                    InkWell(
                        onTap: () {
                          typePhotoPlaca = true;
                          getImagePlaca();
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Icon(FontAwesomeIcons.images,
                                color: Color.fromARGB(
                                    255,
                                    usuarioBloc.miFraccionamiento.color!.r,
                                    usuarioBloc.miFraccionamiento.color!.g,
                                    usuarioBloc.miFraccionamiento.color!.b)),
                            SizedBox(height: 10),
                            Text("Galería")
                          ],
                        )),
                  ],
                ),
              ));
        });
  }

  Future getImage() async {
    if (typePhoto) {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 10).then((value) {
        setState(() {
          _invitado.fotoId = File(value!.path);
          _fotoIdUrl.text = value.path;
        });
      });
    } else {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 10).then((value) {
        setState(() {
          _invitado.fotoId = File(value!.path);
          _fotoIdUrl.text = value.path;
        });
      });
    }
  }

  _getImageplaca() {
    return InkWell(
        onTap: () => _alertPlaca(),
        child: Container(
          margin: EdgeInsets.all(20),
          width: 180,
          height: 180,
          child: _invitado.fotoPlaca != null
              ? Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      width: w!,
                      child: Image.file(
                        _invitado.fotoPlaca!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 15,
                      child: Container(
                          //width: 50,
                          child: InkWell(
                        onTap: () => getImagePlaca(),
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white.withOpacity(0.5),
                            child: Icon(
                              FontAwesomeIcons.penToSquare,
                              color: Colors.white,
                              size: 15,
                            )),
                      )),
                    ),
                  ],
                )
              : DottedBorder(
                  color: Colors.black,
                  strokeWidth: 1,
                  radius: const Radius.circular(60),
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      //width: 180,
                      height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: Icon(
                              FontAwesomeIcons.plus,
                              color: Color.fromARGB(
                                  255,
                                  usuarioBloc.miFraccionamiento.color!.r,
                                  usuarioBloc.miFraccionamiento.color!.g,
                                  usuarioBloc.miFraccionamiento.color!.b),
                              size: 15,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color.fromARGB(
                                      255,
                                      usuarioBloc.miFraccionamiento.color!.r,
                                      usuarioBloc.miFraccionamiento.color!.g,
                                      usuarioBloc.miFraccionamiento.color!.b),
                                  width: 2),
                            ),
                          ),
                          Text("Agregar foto")
                        ],
                      ))),
        ));
  }

  Future _guardaFoto() async {
    var bytes = utf8.encode(_invitado.nombre!); // data being hashed

    var digest = sha1.convert(bytes);
    print("en las fotos*****" + _invitado.id.toString());

    try {
      if (_invitado.fotoId != null) {
        final url = await db.uploadFilee(
            _invitado.fotoId!, "fotoId", _invitado.id.toString());

        print(url);
        _invitado.fotoIdUrl = url;
      }
      if (_invitado.fotoPlaca != null) {
        var url2 = await db.uploadFilee(
            _invitado.fotoPlaca!, "fotoPlaca", _invitado.id.toString());
        print(url2);
        _invitado.fotoPlacaUrl = url2;
      }
    } catch (ex) {
      print("Erorrr en guardado :" + ex.toString());
    }
  }

  Future getImagePlaca() async {
    if (typePhotoPlaca) {
      final dynamic pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 10).then((value) {
        setState(() {
          _invitado.fotoPlaca = File(value!.path);
          //_fotoPlacaUrl.text = value.path;
        });
      });
      String plate = await lprExtract(_invitado.fotoPlaca as File);
      _placas.text = plate;
    } else {
      final dynamic pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 10).then((value) {
        setState(() {
          _invitado.fotoPlaca = File(value!.path);
          //_fotoPlacaUrl.text = value.path;
        });
      });
    }
  }

  _charge(bool val) {
    setState(() {
      onCharge = val;
    });
  }

  _title(String text) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          text,
          style: TextStyle(
              color: Color.fromARGB(
                  255,
                  usuarioBloc.miFraccionamiento.color!.r,
                  usuarioBloc.miFraccionamiento.color!.g,
                  usuarioBloc.miFraccionamiento.color!.b),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ));
  }

  _horaw() {
    return Container(
      width: 150,
      //padding: EdgeInsets.only(left: 20, right: 20),
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
          labelText: "Hora",
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

  Future<String> lprExtract(File file) async {
    //var fileBytes = await file.readAsBytesSync();
    //String encoded = base64.encode(fileBytes);

    String filePath = file.path;
    String fileName = 'Image.jpg';
    String plate = "";

    String secretKey = "sk_c8866e83e0db2d70e1cc8e1c";
    final url = Uri.parse(
        'https://api.openalpr.com/v3/recognize?recognize_vehicle=0&country=mx&topn=2&secret_key= ' +
            secretKey);

    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
      });
      /*Response response = await Dio().post(url.toString(), data: formData);
      print("LPR Rsponse: $response");
      print(response.data.results);
      //ResponsePlacas _response = ResponsePlacas.fromJson(response);
      String str = response.data.results;*/

      Response response = await Dio().post(url.toString(), data: formData);
      //print("LPR Rsponse: $response");
      Map responseBody = response.data;
      List results = responseBody['results'];
      print("Hay resultados ?? " + results.length.toString()); //Hay que validar
      Map result = results.first;
      plate = result['plate'];

      print("La placa es : -----> " + plate);

      /*_response.results!.forEach((element) {
        str = element.plate.toString();
      });*/
    } catch (e) {
      print("Exception Caught: $e");
    }

    return plate;
  }
}
