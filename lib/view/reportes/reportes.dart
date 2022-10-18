import 'dart:convert';
import 'dart:io';

import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/reporteModel.dart';
import 'package:campestre/provider/splashProvider.dart';
import 'package:campestre/view/reportes/reporteSucess.dart';
import 'package:crypto/crypto.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ReportesView extends StatefulWidget {
  const ReportesView({Key? key}) : super(key: key);

  @override
  State<ReportesView> createState() => _ReportesViewState();
}

class _ReportesViewState extends State<ReportesView> {
  double w = 0.0, h = 0.0;
  final picker = ImagePicker();
  Reporte _reporte = new Reporte();
  DatabaseServices db = new DatabaseServices();
  bool typePhoto = false;
  bool typePhotoPlaca = false;
  TextEditingController _fotoIdUrl = new TextEditingController();
  TextEditingController _descrip = new TextEditingController();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

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
            "Reportes a administración",
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
        body: ListView(
          children: [
            Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "Describa el problema",
                  style: TextStyle(fontSize: 18),
                )),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                    //labelText: "Reporte",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,
                          color: Color.fromARGB(
                              255,
                              _usuarioBloc.miFraccionamiento.color!.r,
                              _usuarioBloc.miFraccionamiento.color!.g,
                              _usuarioBloc.miFraccionamiento.color!.b)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,
                          color: Color.fromARGB(
                              255,
                              _usuarioBloc.miFraccionamiento.color!.r,
                              _usuarioBloc.miFraccionamiento.color!.g,
                              _usuarioBloc.miFraccionamiento.color!.b)),
                      borderRadius: BorderRadius.circular(15),
                    )
                    /*enabledBorder: border(false),
                focusedBorder: border(true),
                border: border(false),*/
                    ),
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                controller: _descrip,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20),
              child: Text(
                "Fotos del problema (opcional)",
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
            ),
            _getImageid(),
            _getImageplacas(),
            _button(),
            SizedBox(height: 40)
          ],
        ));
  }

  _getImageid() {
    return InkWell(
        onTap: () => _alert(),
        child: Container(
          margin: EdgeInsets.all(20),
          width: 180,
          height: 180,
          child: _reporte.fotoId != null
              ? Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      width: w,
                      child: Image.file(
                        _reporte.fotoId!,
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
                                  _usuarioBloc.miFraccionamiento.color!.r,
                                  _usuarioBloc.miFraccionamiento.color!.g,
                                  _usuarioBloc.miFraccionamiento.color!.b),
                              size: 15,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color.fromARGB(
                                      255,
                                      _usuarioBloc.miFraccionamiento.color!.r,
                                      _usuarioBloc.miFraccionamiento.color!.g,
                                      _usuarioBloc.miFraccionamiento.color!.b),
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
                width: w - 170,
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
                                  _usuarioBloc.miFraccionamiento.color!.r,
                                  _usuarioBloc.miFraccionamiento.color!.g,
                                  _usuarioBloc.miFraccionamiento.color!.b),
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
                            Icon(
                              FontAwesomeIcons.images,
                              color: Color.fromARGB(
                                  255,
                                  _usuarioBloc.miFraccionamiento.color!.r,
                                  _usuarioBloc.miFraccionamiento.color!.g,
                                  _usuarioBloc.miFraccionamiento.color!.b),
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

  Future getImage() async {
    if (typePhoto) {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 10).then((value) {
        setState(() {
          _reporte.fotoId = File(value!.path);
          _fotoIdUrl.text = value.path;
        });
      });
    } else {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 10).then((value) {
        setState(() {
          _reporte.fotoPlaca = File(value!.path);
          _fotoIdUrl.text = value.path;
        });
      });
    }
  }

  _getImageplacas() {
    return InkWell(
        onTap: () => _alertPlaca(),
        child: Container(
          margin: EdgeInsets.all(20),
          width: 180,
          height: 180,
          child: _reporte.fotoPlaca != null
              ? Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      width: w,
                      child: Image.file(
                        _reporte.fotoPlaca!,
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
                              color: Color(0xFF5562A1),
                              size: 15,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color.fromARGB(
                                      255,
                                      _usuarioBloc.miFraccionamiento.color!.r,
                                      _usuarioBloc.miFraccionamiento.color!.g,
                                      _usuarioBloc.miFraccionamiento.color!.b),
                                  width: 2),
                            ),
                          ),
                          Text("Agregar foto")
                        ],
                      ))),
        ));
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
                width: w - 170,
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
                                  _usuarioBloc.miFraccionamiento.color!.r,
                                  _usuarioBloc.miFraccionamiento.color!.g,
                                  _usuarioBloc.miFraccionamiento.color!.b),
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
                                  _usuarioBloc.miFraccionamiento.color!.r,
                                  _usuarioBloc.miFraccionamiento.color!.g,
                                  _usuarioBloc.miFraccionamiento.color!.b),
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

  Future getImagePlaca() async {
    if (typePhotoPlaca) {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 10).then((value) {
        setState(() {
          _reporte.fotoPlaca = File(value!.path);
          //_fotoPlacaUrl.text = value.path;
        });
      });
    } else {
      final dynamic pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 10).then((value) {
        setState(() {
          _reporte.fotoPlaca = File(value!.path);
          //_fotoPlacaUrl.text = value.path;
        });
      });
    }
  }

  Widget _button() {
    return InkWell(
      onTap: () async {
        try {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(true);

          _usuarioBloc.perfil.idResidente;
          var fecha = new DateTime.now();

          var bytes = utf8.encode(fecha.toString());

          var digest = sha1.convert(bytes);
          _reporte.id = _usuarioBloc.perfil.idResidente! + digest.toString();
          //_reporte.id = "";
          _reporte.descripcion = _descrip.text;
          _reporte.estatus = 0;
          _reporte.idFraccionamiento = _usuarioBloc.miFraccionamiento.id;

          if ((_reporte.fotoId ?? null) == null &&
              (_reporte.fotoPlaca ?? null) == null) {
            await db.guardarReporte(_reporte).whenComplete(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReporteSucess()),
              );
            });
          } else {
            _guardaFoto().whenComplete(() async {
              //_bloquearPantalla();
              await db.guardarReporte(_reporte).whenComplete(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReporteSucess()),
                );
              });
            });
          }
        } catch (error) {
          print(error);
        }
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
      },
      child: Container(
        width: w - 200,
        margin: EdgeInsets.only(left: 30, right: 30, top: 40),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(
              255,
              _usuarioBloc.miFraccionamiento.color!.r,
              _usuarioBloc.miFraccionamiento.color!.g,
              _usuarioBloc.miFraccionamiento.color!.b),
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

  Future _guardaFoto() async {
    try {
      if (_reporte.fotoId != null) {
        final url = await db.uploadFilee(
            _reporte.fotoId!, "fotoId", _reporte.id.toString());

        print(url);
        _reporte.foto1 = url;
      }
      if (_reporte.fotoPlaca != null) {
        var url2 = await db.uploadFilee(
            _reporte.fotoPlaca!, "fotoPlaca", _reporte.id.toString());
        print(url2);
        _reporte.foto2 = url2;
      }
    } catch (ex) {
      print("Erorrr en guardado :" + ex.toString());
    }
  }

  UnderlineInputBorder border(bool focus) {
    return UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color(0xFF5562A1), width: focus ? 2 : 1));
  }
}
