import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:campestre/view/tipoAcceso.dart';
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

class VisitasRegularPage extends StatefulWidget {
  const VisitasRegularPage({Key? key}) : super(key: key);

  @override
  State<VisitasRegularPage> createState() => _VisitasRegularPageState();
}

class _VisitasRegularPageState extends State<VisitasRegularPage> {
  DatabaseServices db = new DatabaseServices();
  DateTime fechaLlegada = DateTime.now();
  DateTime fechaDia = DateTime.now();
  DateTime fechaSalida = DateTime.now().add(Duration(days: 3));
  double? w, h;
  bool? onCharge;
  final picker = ImagePicker();
  bool? isLoading, recurrente = false;
  DateTime selectedDate = new DateTime.now().add(Duration(days: 1));
  bool? tiempoDefinido = true;
  bool? unicoDia = false;
  bool? tiempoIndefinido = false;
  bool typePhoto = false;
  bool typePhotoPlaca = false;
  UIHelper u = new UIHelper();
  UsuarioBloc usuarioBloc = new UsuarioBloc();
  TextEditingController _fecha = new TextEditingController();  
  TextEditingController _fechaLlegada = new TextEditingController();
  TextEditingController _placas = new TextEditingController();
  TextEditingController _fechaSalida = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fotoIdUrl = new TextEditingController();
  TimeOfDay _fromTime = new TimeOfDay.now();
  TextEditingController _hora = new TextEditingController();
  Invitado? _invitado = new Invitado();
  TextEditingController _nombre = new TextEditingController();

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  _bloquearPantalla() {
    this.setState(() {
      isLoading = !isLoading!;
    });
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 20),
            child: Column(
              children: [
                _title(),
                _nombreField(),
                _subtitle(),
                _tiempos(),
                _fotoId(),
                SizedBox(
                  height: 20,
                ),
                _fotoPlacas(),
                SizedBox(
                  height: 30,
                ),
                _button(),
                SizedBox(
                  height: 30,
                ),
              ],
            )));
  }

  _fotoPlacas() {
    return Container(
      child: Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: Text(
            "Foto de la placa del vehículo (Opcional)",
            style: TextStyle(
              fontSize: 17,
              color: Color.fromARGB(
                  255,
                  usuarioBloc.miFraccionamiento.color!.r,
                  usuarioBloc.miFraccionamiento.color!.g,
                  usuarioBloc.miFraccionamiento.color!.b),
            ),
          ),
        ),
        _getImageplaca(),
      ]),
    );
  }

  _fotoId() {
    return Container(
      child: Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20),
          child: Text(
            "Foto de la identificación del visitante (Opcional)",
            style: TextStyle(
              fontSize: 17,
              color: Color.fromARGB(
                  255,
                  usuarioBloc.miFraccionamiento.color!.r,
                  usuarioBloc.miFraccionamiento.color!.g,
                  usuarioBloc.miFraccionamiento.color!.b),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Text(
            "Te recomendamos una foto de alta calidad para poder confirmar la identidad al momento de accesar.",
            style: TextStyle(fontSize: 12, color: Color(0xFF434343)),
          ),
        ),
        _getImageid()
      ]),
    );
  }

  _tiempos() {
    return Container(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Color.fromARGB(
                        255,
                        usuarioBloc.miFraccionamiento.color!.r,
                        usuarioBloc.miFraccionamiento.color!.g,
                        usuarioBloc.miFraccionamiento.color!.b),
                    value: unicoDia,
                    onChanged: (bool? value) {
                      setState(() {
                        unicoDia = value;
                        tiempoDefinido = !unicoDia!;
                        tiempoIndefinido = !unicoDia!;
                      });
                    },
                  ),
                  Container(
                      child: Text("Solo un día",
                          style: TextStyle(fontSize: 17, color: Colors.black)))
                ],
              )),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Color.fromARGB(
                        255,
                        usuarioBloc.miFraccionamiento.color!.r,
                        usuarioBloc.miFraccionamiento.color!.g,
                        usuarioBloc.miFraccionamiento.color!.b),
                    value: tiempoDefinido,
                    onChanged: (bool? value) {
                      setState(() {
                        tiempoDefinido = value;
                        unicoDia = !tiempoDefinido!;
                        tiempoIndefinido = !tiempoDefinido!;
                      });
                    },
                  ),
                  Container(
                      child: Text("Por período definido",
                          style: TextStyle(fontSize: 17, color: Colors.black)))
                ],
              )),
          /*Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Color.fromARGB(
                        255,
                        usuarioBloc.miFraccionamiento.color!.r,
                        usuarioBloc.miFraccionamiento.color!.g,
                        usuarioBloc.miFraccionamiento.color!.b),
                    value: tiempoIndefinido,
                    onChanged: (bool? value) {
                      setState(() {
                        tiempoIndefinido = value;

                        tiempoDefinido = !tiempoIndefinido!;
                        unicoDia = !tiempoIndefinido!;
                      });
                    },
                  ),
                  Container(
                      child: Text("Por período indefinido",
                          style: TextStyle(fontSize: 17, color: Colors.black)))
                ],
              )),*/
          Visibility(
            child: Container(
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
            visible: tiempoDefinido!,
          ),
          Visibility(
            child: Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: _fechaUnDia()),
            visible: unicoDia!,
          )
        ],
      ),
    );
  }

  _subtitle() {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          "Tiempo",
          style: TextStyle(
              color: usuarioBloc.miFraccionamiento.getColor(),
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
            hoverColor: usuarioBloc.miFraccionamiento.getColor(),
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
              primary: usuarioBloc.miFraccionamiento.getColor(), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: usuarioBloc.miFraccionamiento
                    .getColor(), // button text color
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

  Widget _button() {
    return InkWell(
      onTap: () async {
        Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
        if (!_formKey.currentState!.validate()) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          return;
        }
        /*_invitado!.tipoVisita = tiempoDefinido!
            ? TipoVisita.regularDefinido
            : TipoVisita.regularIndefinido;*/
        _invitado!.nombre = _nombre.text;

        if (unicoDia!) {
          Tiempos tiempos = new Tiempos();
          _invitado!.tipoVisita = TipoVisita.regularDefinido;

          DateTime seleccion =
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

          tiempos.fechaEntrada = seleccion;
          tiempos.fechaSalida = seleccion.add(Duration(hours: 23, minutes: 59));

          _invitado!.tiempos = tiempos;
        } else if (tiempoDefinido!) {
          Tiempos tiempos = new Tiempos();
          _invitado!.tipoVisita = TipoVisita.regularDefinido;
          tiempos.fechaEntrada = fechaLlegada;
          tiempos.fechaSalida = fechaSalida;

          _invitado!.tiempos = tiempos;
        } else if (tiempoIndefinido!) {
          Tiempos tiempos = new Tiempos();
          _invitado!.tipoVisita = TipoVisita.regularIndefinido;
          //_invitado?.tiempos = null;
          tiempos.fechaEntrada = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);
          tiempos.fechaSalida = DateTime(DateTime.now().year,
              DateTime.now().month + 1, DateTime.now().day);
          _invitado!.tiempos = tiempos;
        }
        _invitado!.activo = true;

        _invitado!.domicilio = usuarioBloc.perfil.direccion;
        _invitado!.idResidente = usuarioBloc.perfil.idResidente;
        _invitado!.nombreResidente = usuarioBloc.perfil.nombre;
        _invitado!.idFraccionamiento = usuarioBloc.miFraccionamiento.id;

        _invitado!.idLote = usuarioBloc.perfil.lote;
        _invitado!.idRegistro = usuarioBloc.perfil.idRegistro;

        late var bytes; // data being hashed
        if (!TipoVisita.regularIndefinido
            .contains(_invitado!.tipoVisita.toString())) {
          bytes = utf8.encode(
              _invitado!.nombre! + _invitado!.tiempos!.fechaEntrada.toString());
        } else {
          bytes = utf8.encode(_invitado!.nombre! + DateTime.now().toString());
        }

        var digest = sha1.convert(bytes);
        _invitado!.id = digest.toString();

        if ((_invitado!.fotoId ?? null) == null &&
            (_invitado!.fotoPlaca ?? null) == null) {
          await db.guardarDatos(_invitado!);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfirmacionVistitas()),
          );
        } else {
          await _guardaFoto();
          _invitado!.placas = _placas.text;

          await db.guardarDatos(_invitado!).whenComplete(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfirmacionVistitas()),
            );
          });
        }
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
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

  _nombreField() {
    return Container(
        padding: EdgeInsets.only(left: 25, right: 20),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {},

          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hoverColor: Color.fromARGB(
                255,
                usuarioBloc.miFraccionamiento.color!.r,
                usuarioBloc.miFraccionamiento.color!.g,
                usuarioBloc.miFraccionamiento.color!.b),
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

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime,
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;
        String minute = _fromTime.minute < 10
            ? "0${_fromTime.minute}"
            : _fromTime.minute.toString();
        _hora.text = _fromTime.hour.toString() + ":" + minute;
      });
    }
  }

  _getImageid() {
    return InkWell(
        onTap: () => _alert(),
        child: Container(
          width: w! * 0.75,
          height: 180,
          child: _invitado?.fotoId != null
              ? Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      width: w!,
                      child: Image.file(
                        _invitado!.fotoId!,
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
                              color: usuarioBloc.miFraccionamiento.getColor(),
                              size: 15,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      usuarioBloc.miFraccionamiento.getColor(),
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
                            Icon(FontAwesomeIcons.camera,
                                color:
                                    usuarioBloc.miFraccionamiento.getColor()),
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
                                color:
                                    usuarioBloc.miFraccionamiento.getColor()),
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
                            Icon(
                              FontAwesomeIcons.images,
                              color: Color.fromARGB(
                                  255,
                                  usuarioBloc.miFraccionamiento.color!.r,
                                  usuarioBloc.miFraccionamiento.color!.g,
                                  usuarioBloc.miFraccionamiento.color!.b),
                            ),
                            SizedBox(height: 10),
                            Text("Galería")
                          ],
                        )),
                  ],
                ),
              ));
        });
  }

  _getImageplaca() {
    return InkWell(
        onTap: () => _alertPlaca(),
        child: Container(
          //margin: EdgeInsets.all(20),
          width: w! * 0.75,
          height: 180,
          child: _invitado?.fotoPlaca != null
              ? Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      width: w!,
                      child: Image.file(
                        _invitado!.fotoPlaca!,
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
                              color: usuarioBloc.miFraccionamiento.getColor(),
                              size: 15,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      usuarioBloc.miFraccionamiento.getColor(),
                                  width: 2),
                            ),
                          ),
                          Text("Agregar foto")
                        ],
                      ))),
        ));
  }

  Future _guardaFoto() async {
    var bytes = utf8.encode(_invitado!.nombre.toString()); // data being hashed

    var digest = sha1.convert(bytes);
    print("en las fotos*****" + _invitado!.id.toString());

    try {
      if (_invitado!.fotoId != null) {
        _invitado!.fotoIdUrl = await db.uploadFilee(
            _invitado!.fotoId!, "fotoId", _invitado!.id.toString());

        print(_invitado!.fotoIdUrl);
      }
      if (_invitado!.fotoPlaca != null) {
        _invitado!.fotoPlacaUrl = await db.uploadFilee(
            _invitado!.fotoPlaca!, "fotoPlaca", _invitado!.id.toString());
        print(_invitado!.fotoPlacaUrl);
      }
    } catch (ex) {
      print("Erorrr en guardado :" + ex.toString());
    }
  }

  _charge(bool val) {
    setState(() {
      onCharge = val;
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
          DateTime.now().year, DateTime.now().month + usuarioBloc.miFraccionamiento.rangoMesesReg!.toInt(), DateTime.now().day),
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
      } else{

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
        /*Fluttertoast.showToast(
          msg: "Máximo "+usuarioBloc.miFraccionamiento.rangoDiasVisitasReg.toString() +" días",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );*/
      }
    }
  }

  _title() {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          "Información visita",
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TipoAcceso()),
              );
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF0C0C0C),
            ),
          ),
        ),
        body: _form());
  }

  Future getImage() async {
    if (typePhoto) {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 10).then((value) {
        setState(() {
          _invitado!.fotoId = File(value!.path);
          _fotoIdUrl.text = value.path;
        });
      });
    } else {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 10).then((value) {
        setState(() {
          _invitado!.fotoId = File(value!.path);
          _fotoIdUrl.text = value.path;
        });
      });
    }
  }

  Future getImagePlaca() async {
    Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
    if (typePhotoPlaca) {
      final dynamic pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _invitado!.fotoPlaca = File(pickedFile!.path);
        //_fotoPlacaUrl.text = value.path;
      });

      String plate = await lprExtract(_invitado!.fotoPlaca as File);
      _placas.text = plate;
    } else {
      final dynamic pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
      setState(() {
        _invitado!.fotoPlaca = File(pickedFile!.path);
        //_fotoPlacaUrl.text = value.path;
      });
      /*String plate = await lprExtract(_invitado!.fotoPlaca as File);
      _placas.text = plate;*/
    }
    Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
  }

  Future<String> lprExtract(File file) async {
    String key = "";
    //var fileBytes = await file.readAsBytesSync();
    //String encoded = base64.encode(fileBytes);

    String filePath = file.path;
    String fileName = 'Image.jpg';
    String plate = "";

    String secret_key = "sk_c8866e83e0db2d70e1cc8e1c";
    final url = Uri.parse(
        'https://api.openalpr.com/v3/recognize?recognize_vehicle=0&country=mx&topn=2&secret_key= ' +
            secret_key);

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
      print("LPR Rsponse: $response");
      Map responseBody = response.data;
      List results = responseBody['results'];
      print("Hay resultados ?? " + results.length.toString()); //Hay que validar
      
      if(results.length == 0){
         Fluttertoast.showToast(
          msg: 'La foto de la placa no puede ser procesada, favor de elegir otra más clara y cercana',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );
      }

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
