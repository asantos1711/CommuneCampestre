import 'dart:io';

import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/invitadoModel.dart';
import 'package:campestre/widgets/textfielborder.dart';
import 'package:campestre/widgets/ui_helper.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class InvitadosView extends StatefulWidget {
  Invitado? invitado;
  InvitadosView({this.invitado});

  @override
  _InvitadosViewState createState() => _InvitadosViewState();
}

class _InvitadosViewState extends State<InvitadosView> {
  UIHelper u = new UIHelper();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombre = new TextEditingController();
  TextEditingController _fecha = new TextEditingController();
  TextEditingController _hora = new TextEditingController();
  TextEditingController _acomp = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _fotoIdUrl = new TextEditingController();
  TextEditingController _fotoPlacaUrl = new TextEditingController();
  DatabaseServices db = new DatabaseServices();
  DateTime selectedDate = new DateTime.now();
  TimeOfDay _fromTime = new TimeOfDay.now();
  Invitado? _invitado = new Invitado();
  double? w, h;
  final picker = ImagePicker();
  File? _image;
  bool? isLoading, recurrente = false;
  UsuarioBloc usuarioBloc = new UsuarioBloc();
  bool? onCharge;
  bool typePhoto = false;
  bool typePhotoPlaca = false;
  bool? _uno = false, _repeat = false;
  _bloquearPantalla() {
    this.setState(() {
      isLoading = !isLoading!;
    });
  }

  @override
  void initState() {
    _invitado = this.widget.invitado != null ? this.widget.invitado : _invitado;

    isLoading = false;
    _initCampos();
    // TODO: implement initState
    //bloquearPantalla();
    super.initState();
  }

  _initCampos() {
    if (this.widget.invitado != null) {
      _nombre.text = _invitado!.nombre!;
      _acomp.text = _invitado!.acompanantes!;
      _phone.text = _invitado!.telefono!;
      _email.text = _invitado!.email!;
    }
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
            _title(),
            Container(
              padding: EdgeInsets.only(left: 25, right: 20),
              child: TextFormFieldBorder("Nombre", _nombre,
                  TextInputType.emailAddress, false, Colors.white),
            ),
            _subtitle(),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Color(0xFF5E1281),
                      value: _uno,
                      onChanged: (bool? value) {
                        setState(() {
                          _uno = value;
                          _repeat = false;
                        });
                      },
                    ),
                    Container(
                        child: Text("Una sola ocasión",
                            style:
                                TextStyle(fontSize: 17, color: Colors.black)))
                  ],
                )),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Color(0xFF5E1281),
                      value: _repeat,
                      onChanged: (bool? value) {
                        setState(() {
                          _repeat = value;
                          _uno = false;
                        });
                      },
                    ),
                    Container(
                        child: Text("Por tiempo indefinido",
                            style:
                                TextStyle(fontSize: 17, color: Colors.black)))
                  ],
                )),
            Visibility(
              child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [_fechaw(), _horaw()],
                      ),
                    ],
                  )),
              visible: _uno!,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20),
              child: Text(
                "Foto de la identificación del visitante",
                style: TextStyle(fontSize: 16, color: Color(0xFF434343)),
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
            _getImageProfile(),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Text(
                "Foto de la placa del vehículo",
                style: TextStyle(fontSize: 16, color: Color(0xFF434343)),
              ),
            ),
            _getImageId(),
            SizedBox(
              height: 30,
            ),
            _recurrente(),
            SizedBox(
              height: 30,
            ),
            _button(),
            SizedBox(
              height: 30,
            ),
          ],
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

  _subtitle() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          "Tiempo",
          style: TextStyle(
              color: Color(0xFF414596),
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
            hoverColor: Colors.purple,
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

  Widget _button() {
    print(usuarioBloc.perfil.nombre);
    return InkWell(
      onTap: () async {
        //await db.saveRecurrentes(usuarioBloc.perfil.idResidente);
        //List<Invitado> lista =
        //    await db.getRecurrentes(usuarioBloc.perfil.idResidente);
        //print("lista " + lista.toString());
        _bloquearPantalla();
        if (!_formKey.currentState!.validate()) {
          _bloquearPantalla();
          // _charge(false);
          return;
        }
        setState(() {
          selectedDate = new DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, _fromTime.hour, _fromTime.minute);
        });
        print(_fromTime.toString());
        print(selectedDate.toString());
        _invitado!.nombre = _nombre.text;
        _invitado!.telefono = _phone.text;
        _invitado!.email = _email.text;
        _invitado!.domicilio = usuarioBloc.perfil.direccion;
        _invitado!.idResidente = usuarioBloc.perfil.idResidente;
        _invitado!.nombreResidente = usuarioBloc.perfil.nombre;

        if (recurrente!) {
          await db.addRecurrente(usuarioBloc.perfil.idResidente!, _invitado);
        }

        //_invitado.fotoIdUrl = _fotoIdUrl.text;
        //_invitado.fotoPlacaUrl = _fotoPlacaUrl.text;
        //setState(() {
        //_bloquearPantalla();
        //_charge(true);

        /*_guardaFoto().whenComplete(() {
          _bloquearPantalla();
          db.guardarDatos(_invitado!);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QrPage()),
          );
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
        width: w! - 100,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF5562A1),
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

  _getImageProfile() {
    return InkWell(
        onTap: () => _alert(),
        child: Container(
          margin: EdgeInsets.all(20),
          width: 180,
          height: 180,
          child: _invitado!.fotoId != null
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
                              _invitado!.fotoId!,
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
                              color: Color(0xFF5562A1),
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
                                color: Color(0xFF5562A1)),
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
                              color: Color(0xFF5562A1),
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
                                color: Color(0xFF5562A1)),
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
          await picker.getImage(source: ImageSource.gallery).then((value) {
        setState(() {
          _invitado!.fotoId = File(value!.path);
          _fotoIdUrl.text = value.path;
        });
      });
    } else {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.camera).then((value) {
        setState(() {
          _invitado!.fotoId = File(value!.path);
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
          child: _invitado!.fotoPlaca != null
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
                              _invitado!.fotoPlaca!,
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
          await picker.getImage(source: ImageSource.gallery).then((value) {
        setState(() {
          _invitado!.fotoPlaca = File(value!.path);
          //_fotoPlacaUrl.text = value.path;
        });
      });
    } else {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.camera).then((value) {
        setState(() {
          _invitado!.fotoPlaca = File(value!.path);
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

  _title() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(
          "Información visita",
          style: TextStyle(
              color: Color(0xFF5E1281),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ));
  }
}
