import 'dart:convert';
import 'dart:io';

import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/invitadoModel.dart';
import 'package:campestre/provider/splashProvider.dart';
import 'package:campestre/view/confirmacionVisita.dart';
import 'package:campestre/widgets/textfielborder.dart';
import 'package:campestre/widgets/ui_helper.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:time_range/time_range.dart';

class VisitasPaquteriaPage extends StatefulWidget {
  const VisitasPaquteriaPage({Key? key}) : super(key: key);

  @override
  State<VisitasPaquteriaPage> createState() => _VisitasPaquteriaPageState();
}

class _VisitasPaquteriaPageState extends State<VisitasPaquteriaPage> {
  UIHelper u = new UIHelper();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombre = new TextEditingController();
  TextEditingController _fecha = new TextEditingController();
  TextEditingController _hora = new TextEditingController();
  TextEditingController _placas = new TextEditingController();
  TextEditingController _fotoIdUrl = new TextEditingController();
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
  TimeRangeResult? range;
  _bloquearPantalla() {
    this.setState(() {
      isLoading = !isLoading!;
    });
  }

  @override
  void initState() {
    isLoading = false;
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 15, right: 20),
          child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*TextButton(
                onPressed: () {
                  TimeOfDay val = stringToTimeOfDay("5:03");
                  print(val);
                },
                child: Text("press")),*/

                _title("Información paquetería/uber"),
                _nombreField(),
                /*Container(
              padding: EdgeInsets.only(left: 15, right: 20),
              child: TextFormFieldBorder(
                  "Nombre", _nombre, TextInputType.name, false, Colors.white),
            ),*/
                _subtitle("Hora acceso (del día de hoy)"),
                TimeRange(
                  fromTitle: Text(
                    'Desde',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(
                            255,
                            usuarioBloc.miFraccionamiento.color!.r,
                            usuarioBloc.miFraccionamiento.color!.g,
                            usuarioBloc.miFraccionamiento.color!.b)),
                  ),
                  toTitle: Text(
                    'Hasta',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(
                            255,
                            usuarioBloc.miFraccionamiento.color!.r,
                            usuarioBloc.miFraccionamiento.color!.g,
                            usuarioBloc.miFraccionamiento.color!.b)),
                  ),
                  titlePadding: 20,
                  textStyle: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black87),
                  activeTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  borderColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  activeBackgroundColor: Color.fromARGB(
                      255,
                      usuarioBloc.miFraccionamiento.color!.r,
                      usuarioBloc.miFraccionamiento.color!.g,
                      usuarioBloc.miFraccionamiento.color!.b),
                  firstTime: TimeOfDay(
                      hour: TimeOfDay.now().hour,
                      minute: 00), //TimeOfDay.now(),
                  lastTime: TimeOfDay(hour: 22, minute: 00),
                  timeStep: 30,
                  timeBlock: 30,
                  onRangeCompleted: (rang) => setState(() => range = rang),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20),
                  child: Text(
                    "Foto de la identificación del visitante (opcional)",
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
                //_getImageId(),
                SizedBox(
                  height: 30,
                ),
                //_recurrente(),
                _button(),
                SizedBox(
                  height: 30,
                ),
                //UIHelper.bloqueaPantalla(context, isLoading!)
              ]),
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
            return null;
          },
        ));
  }

  _subtitle(String texto) {
    return Container(
        alignment: Alignment.centerLeft,
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

  _fechaw() {
    return Container(
        width: 150,
        //padding: EdgeInsets.only(left: 80, right: 80),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {
            _selectDate();
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

  _getImageplaca() {
    return InkWell(
        onTap: () => _alertPlaca(),
        child: Container(
          //margin: EdgeInsets.all(20),
          width: w! * 0.75,
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

  Widget _button() {
    return InkWell(
      onTap: () async {
        Provider.of<LoadingProvider>(context, listen: false).setLoad(true);

        if (!_formKey.currentState!.validate()) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          Fluttertoast.showToast(
            msg: "Complete los campos faltantes",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );
          return;
        }
        if (range == null) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          Fluttertoast.showToast(
            msg: "Seleccione un rango de espera",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );
          return;
        }

        try {
          _invitado.nombre = _nombre.text;
          /*_invitado!.telefono = _phone.text;
          _invitado!.email = _email.text;
          _invitado!.numAcompa = _acomp.text;*/
          _invitado.tipoVisita = "Paqueteria";
          _invitado.acompanantes = "";
          _invitado.activo = true;
          _invitado.idFraccionamiento = usuarioBloc.miFraccionamiento.id;
          _invitado.tiempos = new Tiempos();

          DateTime hoy = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);

          _invitado.tiempos?.fechaEntrada = hoy;
          _invitado.tiempos?.fechaSalida =
              hoy.add(Duration(hours: 23, minutes: 59));
          _invitado.tiempos?.horaEntrada = timeOfDayToString(range!.start);
          _invitado.tiempos?.horaSalida = timeOfDayToString(range!.end);
          _invitado.domicilio = usuarioBloc.perfil.direccion;
          _invitado.idResidente = usuarioBloc.perfil.idResidente;
          _invitado.nombreResidente = usuarioBloc.perfil.nombre;
          _invitado.idLote = usuarioBloc.perfil.lote;
          _invitado.idRegistro = usuarioBloc.perfil.idRegistro;
          //_invitado.fotoIdUrl = "";
          //_invitado.fotoPlacaUrl = "";

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

          /*await db.guardarDatos(_invitado).whenComplete(() => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfirmacionVistitas()),
              ));*/
        } catch (error) {
          print("Ocurrio un error ***" + error.toString());
        }

        /* _invitado.fotoIdUrl = _fotoIdUrl.text;
        _invitado.fotoPlacaUrl = _fotoPlacaUrl.text;
        //setState(() {
        //_bloquearPantalla();
        //_charge(true);

        _guardaFoto().whenComplete(() {
          _bloquearPantalla();
          
        });*/

        //});

        //await db.getProfile("");
        /*Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => QrPage(),
            transitionDuration: Duration(seconds: 0),
          ),
        );*/
      },
      child: Container(
        width: w!,
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

  String timeOfDayToString(TimeOfDay time) {
    String hora;
    String minute =
        time.minute < 10 ? "0${time.minute}" : time.minute.toString();
    hora = time.hour.toString() + ":" + minute;
    return hora;
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _fecha.text = selectedDate.day.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.year.toString();
      });
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
          width: w! * 0.75,
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

  _getImageId() {
    return InkWell(
        onTap: () => _alertPlaca(),
        child: Container(
          margin: EdgeInsets.all(20),
          width: 180,
          height: 180,
          child: _invitado.fotoPlaca != null
              ? Container(
                  height: 110,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(10),
                          width: (w! / 5) * 3,
                          height: (w! / 5) * 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: Image.file(
                              _invitado.fotoPlaca!,
                              fit: BoxFit.cover,
                            ),
                          )),
                      Positioned(
                          top: 20,
                          right: 20,
                          height: 40,
                          width: 40,
                          child: Container(
                              width: 100,
                              child: InkWell(
                                onTap: () => getImagePlaca(),
                                child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.5),
                                    child: Icon(
                                      FontAwesomeIcons.penToSquare,
                                      color: Colors.white,
                                      size: 15,
                                    )),
                              ))),
                    ],
                  ),
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

  /* Future _guardaFoto() async {
    var bytes = utf8.encode(_invitado!.nombre!); // data being hashed

    var digest = sha1.convert(bytes);
    if (_invitado!.fotoId != null) {
      String url = await db
          .uploadFilee(_invitado!.fotoId!, "fotoId", digest.toString())
          .then((value) {
        _invitado!.fotoIdUrl = value;
        //_fotoPlacaUrl.text = value.path;
      } as FutureOr<String> Function(dynamic));
    }
    if (_invitado!.fotoPlaca != null) {
      String url = await db
          .uploadFilee(_invitado!.fotoPlaca!, "fotoPlaca", digest.toString())
          .then((value) {
        _invitado!.fotoPlacaUrl = value;
        //_fotoPlacaUrl.text = value.path;
      } as FutureOr<String> Function(dynamic));
    }
  }*/

  Future getImagePlaca() async {
    if (typePhotoPlaca) {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 10).then((value) {
        setState(() {
          _invitado.fotoPlaca = File(value!.path);
          //_fotoPlacaUrl.text = value.path;
        });
      });
      String plate = await lprExtract(_invitado.fotoPlaca as File);
      _placas.text = plate;
    } else {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 10).then((value) {
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
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 25, right: 20, top: 20),
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

  TimeOfDay stringToTimeOfDay(String horaString) {
    TimeOfDay horaResult;
    List<String> list = horaString.split(":");
    int hora = int.parse(list.first);
    int minuto = int.parse(list.last);

    horaResult = TimeOfDay(hour: hora, minute: minuto);
    return horaResult;
  }

  Future<String> lprExtract(File file) async {
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
