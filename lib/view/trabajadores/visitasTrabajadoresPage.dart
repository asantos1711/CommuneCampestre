import 'dart:convert';
import 'dart:io';

import 'package:campestre/controls/connection.dart';
import 'package:campestre/view/confirmacionVisita.dart';
import 'package:campestre/view/menuInicio.dart';
import 'package:campestre/view/tipoAcceso.dart';
import 'package:campestre/widgets/textfielborder.dart';
import 'package:campestre/widgets/ui_helper.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:time_range/time_range.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../bloc/usuario_bloc.dart';
import '../../models/invitadoModel.dart';
import '../../provider/splashProvider.dart';
import '../../widgets/idOverlay.dart';

class VisitasTrabajadoresPage extends StatefulWidget {
  const VisitasTrabajadoresPage({Key? key}) : super(key: key);

  @override
  State<VisitasTrabajadoresPage> createState() =>
      _VisitasTrabajadoresPageState();
}

class _VisitasTrabajadoresPageState extends State<VisitasTrabajadoresPage> {
  UIHelper u = new UIHelper();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombre = new TextEditingController();
  TextEditingController _fechaLlegada = new TextEditingController();
  TextEditingController _fechaSalida = new TextEditingController();
  TextEditingController _hora = new TextEditingController();
  TextEditingController _hora2 = new TextEditingController();
  TextEditingController _placas = new TextEditingController();
  TextEditingController _fotoIdUrl = new TextEditingController();
  DatabaseServices db = new DatabaseServices();
  DateTime selectedDate = new DateTime.now().add(Duration(days: 1));

  List<bool> values = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  bool daySalected = false;

  DateTime fechaLlegada = DateTime.now();
  DateTime fechaSalida = DateTime.now().add(Duration(days: 3));

  TimeOfDay _fromTime = new TimeOfDay.now();
  TimeOfDay _fromTime2 = new TimeOfDay.now();
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
  void initState() {
    //_invitado = this.widget.invitado != null ? this.widget.invitado : _invitado;

    isLoading = false;
    _initCampos();
    // TODO: implement initState
    //bloquearPantalla();
    super.initState();
  }

  _initCampos() {
    _nombre.text = usuarioBloc.nombreTrabId != null
        ? usuarioBloc.nombreTrabId.toString().replaceAll("\n", " ").toString()
        : "";
    /* if (this.widget.invitado != null) {
      _nombre.text = _invitado!.nombre!;
      _acomp.text = _invitado!.numAcompa!;
      _phone.text = _invitado!.telefono!;
      _email.text = _invitado!.email!;
    }*/
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
        //bottomNavigationBar: u.bottomBar(h, w!, 1, context),
        body: _form());
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 15, right: 20),
          child: Column(
            children: [
              _title(),
              //_opcionLeerId(),
              _nombreField(),
              _subtitle("Tiempo"),
              _tiempos(),
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
                        usuarioBloc.miFraccionamiento.color!.b),
                  ),
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
              //_fotoId(),
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
              //_fotoPlacas(),
              SizedBox(
                height: 30,
              ),
              _button(),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
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
                        onTap: () => _alert(),
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
                        onTap: () => _alertPlaca(),
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

  _fotoPlacas() {
    return Container(
      child: Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: Text(
            "Foto de la placa del vehículo (Opcional)",
            style: TextStyle(fontSize: 17, color: Color(0xFF414596)),
          ),
        ),
        _getImageId(),
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
            style: TextStyle(fontSize: 17, color: Color(0xFF414596)),
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
        _getImageProfile()
      ]),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _fechaw(_fechaLlegada, "Dia de inicio"),
                      _fechaw(_fechaSalida, "Día final"),
                    ],
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          _subtitle("Días de trabajo"),
          _dias(),
          SizedBox(
            height: 20,
          ),
          _subtitle("Hora"),
          Container(
            margin: EdgeInsets.only(
              left: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _horaw(),
                _horaw2(),
              ],
            ),
          )
          //_rangoHoras()
        ],
      ),
    );
  }

  _dias() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: WeekdaySelector(
        splashColor: Color.fromARGB(
            255,
            usuarioBloc.miFraccionamiento.color!.r,
            usuarioBloc.miFraccionamiento.color!.g,
            usuarioBloc.miFraccionamiento.color!.b),
        selectedFillColor: Color.fromARGB(
            255,
            usuarioBloc.miFraccionamiento.color!.r,
            usuarioBloc.miFraccionamiento.color!.g,
            usuarioBloc.miFraccionamiento.color!.b),
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

  _nombreField() {
    return Container(
        padding: EdgeInsets.only(left: 25, right: 20),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {},
          //readOnly: true,
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

  _recurrente() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Checkbox(
            value: recurrente,
            onChanged: (nv) {
              setState(() {
                recurrente = nv;
              });
            },
            activeColor: Color(0xFF5562A1),
          ),
          Text("Agregar a invitados recurrentes.")
        ],
      ),
    );
  }

  _horaw() {
    return Container(
      width: (w! - 80) / 2,
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
      width: (w! - 80) / 2,
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
                  usuarioBloc.miFraccionamiento.color!.r,
                  usuarioBloc.miFraccionamiento.color!.g,
                  usuarioBloc.miFraccionamiento.color!.b)),
        ));
  }

  _fechaw(TextEditingController fecha, String text) {
    return Container(
        alignment: Alignment.centerLeft,
        width: (w! - 80) / 2,
        //padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {
            _showRangoFechas(context);
            //_selectDate();
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

  Widget _button() {
    print(usuarioBloc.perfil.nombre);
    return InkWell(
      onTap: () async {
        //await db.saveRecurrentes(usuarioBloc.perfil.idResidente);
        //List<Invitado> lista =
        //    await db.getRecurrentes(usuarioBloc.perfil.idResidente);
        //print("lista " + lista.toString());

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
            desc: "Complete los campos faltantes",
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
          // _charge(false);
          return;
        }
        if (!daySalected) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          /*Fluttertoast.showToast(
            msg: "Seleccione almenos un día de la semana",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );*/
          Alert(
            context: context,
            desc: "Seleccione al menos un día de la semana",
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

        print(_fromTime.toString());
        print(selectedDate.toString());
        _invitado.nombre = _nombre.text;
        //_invitado!.telefono = _phone.text;
        //_invitado!.email = _email.text;
        _invitado.domicilio = usuarioBloc.perfil.direccion;
        _invitado.idResidente = usuarioBloc.perfil.idResidente;
        _invitado.nombreResidente = usuarioBloc.perfil.nombre;
        _invitado.acompanantes = "";
        _invitado.tiempos = new Tiempos();
        _invitado.idFraccionamiento = usuarioBloc.miFraccionamiento.id;
        _invitado.idLote = usuarioBloc.perfil.lote;
        _invitado.idRegistro = usuarioBloc.perfil.idRegistro;

        fechaLlegada = new DateTime(
            fechaLlegada.year, fechaLlegada.month, fechaLlegada.day);

        _invitado.tiempos?.fechaEntrada = fechaLlegada;
        fechaSalida = new DateTime(
            fechaSalida.year, fechaSalida.month, fechaSalida.day, 23, 59);

        _invitado.tiempos?.fechaSalida = fechaSalida;
        _invitado.tiempos?.horaEntrada = _hora.text;
        _invitado.tiempos?.horaSalida = _hora2.text;
        _invitado.tiempos?.dias = values;
        _invitado.activo = true;
        _invitado.tipoVisita = "Trabajador";

        bool exitetrabajador = await existeTrabajador(_invitado);
        if (exitetrabajador) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          /*Fluttertoast.showToast(
            msg: "Ya hay trabajador",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );*/
          Alert(
            context: context,
            desc: "Ya hay trabajador",
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
          usuarioBloc.nombreTrabId = "";
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfirmacionVistitas()),
          );
        } else {
          await _guardaFoto();
          _invitado.placas = _placas.text;
          usuarioBloc.nombreTrabId = "";
          await db.guardarDatos(_invitado).whenComplete(() {
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

  _getImageProfile() {
    return InkWell(
        onTap: () => _alert(),
        child: Container(
          margin: EdgeInsets.all(20),
          //width: 180,
          height: 180,
          child: _invitado.fotoId != null
              ? Container(
                  height: 110,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(10),
                          width: (w! / 5) * 3,
                          height: (w! / 5) * 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: Image.file(
                              _invitado.fotoId!,
                              fit: BoxFit.cover,
                            ),
                          )),
                      Container(
                          width: 100,
                          child: InkWell(
                            onTap: () => getImage(),
                            child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white.withOpacity(0.5),
                                child: Icon(
                                  FontAwesomeIcons.penToSquare,
                                  color: Colors.white,
                                  size: 15,
                                )),
                          )),
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
                              color: Color(0xFF5562A1),
                              size: 15,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(0xFF5562A1), width: 2),
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
                          /*typePhoto = false;
                          getImage();
                          Navigator.of(context).pop();*/
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CameraOverlayCustom(func: (value) {
                                setState(() {
                                  _invitado.fotoId = value;
                                  _fotoIdUrl.text = value.path;
                                });
                              }),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 10),
                            Icon(
                              FontAwesomeIcons.camera,
                              color: usuarioBloc.miFraccionamiento.getColor(),
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
                              color: usuarioBloc.miFraccionamiento.getColor(),
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
          //width: 180,
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
                              color: Color(0xFF5562A1),
                              size: 15,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(0xFF5562A1), width: 2),
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
          await picker.getImage(source: ImageSource.camera).then((value) {
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
      if (days >= 1 && days <= usuarioBloc.miFraccionamiento.rangoDiasTrabReg!.toInt()) {
        print(picked);
        setState(() {
          fechaLlegada = picked.start;
          _fechaLlegada.text = DateFormat('dd-MM-yyyy').format(fechaLlegada);
          fechaSalida = picked.end;
          _fechaSalida.text = DateFormat('dd-MM-yyyy').format(fechaSalida);
        });
      } else {
        /*Fluttertoast.showToast(
          msg: "Máximo "+usuarioBloc.miFraccionamiento.rangoDiasTrabReg!.toString() + " días",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );*/
        Alert(
          context: context,
          desc: "Máximo "+usuarioBloc.miFraccionamiento.rangoDiasTrabReg!.toString() + " días",
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

  _rangoHoras() {
    return TimeRange(
      fromTitle: Text(
        'Desde',
        style: TextStyle(fontSize: 18, color: Color(0xFF5E1281)),
      ),
      toTitle: Text(
        'Hasta',
        style: TextStyle(fontSize: 18, color: Color(0xFF5E1281)),
      ),
      titlePadding: 20,
      textStyle:
          TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
      activeTextStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      borderColor: Colors.black,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Color(0xFF5E1281),
      firstTime: TimeOfDay(hour: 8, minute: 00),
      lastTime: TimeOfDay(hour: 22, minute: 00),
      timeStep: 30,
      timeBlock: 60,
      onRangeCompleted: (range) => setState(() => print(range.toString())),
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

  Future<bool> existeTrabajador(Invitado invitado) async {
    List<Invitado> lista =
        await db.getRegistroInvitadoByNombre(invitado.nombre.toString());

    if (lista.isEmpty) return false;

    Invitado last = lista.last;

    bool entre = (last.tiempos!.fechaEntrada!
            .isBefore(invitado.tiempos!.fechaEntrada!) &&
        last.tiempos!.fechaSalida!.isAfter(invitado.tiempos!.fechaEntrada!));

    bool igual = last.tiempos!.fechaEntrada == invitado.tiempos!.fechaEntrada!;

    bool activo = last.activo as bool;

    print(igual);

    if (entre || igual || activo) {
      return true;
    } else {
      return false;
    }
  }
}
