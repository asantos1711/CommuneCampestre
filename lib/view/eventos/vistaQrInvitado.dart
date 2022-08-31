import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:clipboard/clipboard.dart';
import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/view/eventos/visitasEventosPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_shortener/bitly_shortener.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../../provider/splashProvider.dart';

class VistaQRInvitado extends StatefulWidget {
  //const VistaQRInvitado({ Key? key }) : super(key: key);
  String idEvento;
  VistaQRInvitado({required this.idEvento});

  @override
  State<VistaQRInvitado> createState() => _VistaQRInvitadoState();
}

class _VistaQRInvitadoState extends State<VistaQRInvitado> {
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  late String idEvento;
  late String urlQr;

  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    idEvento = this.widget.idEvento;
    //saveQr();
    /*if (SchedulerBinding.instance!.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance!.addPostFrameCallback((_) => saveQr(context));
    }*/
    // SchedulerBinding.instance!.addPostFrameCallback((_) => saveQr(context));
    //Timer.run(() => saveQr(context));
    //Future.delayed(Duration.zero, () => saveQr(context));
    // WidgetsBinding.instance!.addPostFrameCallback((_) => saveQr());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        VisitasEventosPage(id: idEvento),
                  ),
                );
              },
              child: Icon(
                Icons.arrow_back,
                color: Color(0xFF0C0C0C),
              ),
            ),
          ),
          body: ListView(
            children: [
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 40),
                  child: Text(
                    "Información recibida",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                child: Text(
                    "Tu invitado ${_usuarioBloc.invitado.nombre.toString()} tiene acceso para ingresar como visita.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    )),
              ),
              //_qr(),
              Container(
                margin:
                    EdgeInsets.only(bottom: 10, top: 20, right: 40, left: 40),
                child: FlatButton(
                  //minWidth: 100,
                  onPressed: () async {
                    //_getWidgetImage();
                    String urlPadre =
                        "https://communecampestre.web.app/#/commune/qr/";
                    String url = urlPadre + _usuarioBloc.invitado.id!;
                    await Share.share(
                        "¡Hola!,este es el link para tu acceso ${url}");
                  },
                  color: Color.fromARGB(
                      255,
                      _usuarioBloc.miFraccionamiento.color!.r,
                      _usuarioBloc.miFraccionamiento.color!.g,
                      _usuarioBloc.miFraccionamiento.color!.b),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    "Compartir url de acceso",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
              urlShortener(),
              Container(
                margin:
                    EdgeInsets.only(bottom: 20, top: 0, right: 30, left: 30),
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  //minWidth: 100,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            VisitasEventosPage(id: idEvento),
                      ),
                    );
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      /*side: BorderSide(
                  color: Color(0xff5E1281),
                  width: 1,
                  style: BorderStyle.solid
                ),*/
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Text(
                    "Regresar a mi evento",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(
                          255,
                          _usuarioBloc.miFraccionamiento.color!.r,
                          _usuarioBloc.miFraccionamiento.color!.g,
                          _usuarioBloc.miFraccionamiento.color!.b),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  urlShortener() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 20, right: 40, left: 40),
      child: FlatButton(
        //minWidth: 100,
        onPressed: () {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
          _guardarQR();
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        },
        color: Color.fromARGB(
            255,
            _usuarioBloc.miFraccionamiento.color!.r,
            _usuarioBloc.miFraccionamiento.color!.g,
            _usuarioBloc.miFraccionamiento.color!.b),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Copiar url de acceso",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            SizedBox(width: 5),
            Icon(
              FontAwesome.copy,
              color: Colors.white,
            )
          ],
        ),
      ),
    ); /*FutureBuilder(
      future: _guardarQR(),
      builder: (context, AsyncSnapshot<String> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snap.data == null ||
            snap.data.toString().isEmpty ||
            snap.data == "") {
          return SizedBox();
        }

        return Container(
            margin: EdgeInsets.only(bottom: 20, top: 0, right: 30, left: 30),
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: TextEditingController(text: snap.data.toString()),
              decoration: InputDecoration(
                  suffix: InkWell(
                child: Icon(FontAwesome.copy),
              )),
            ));
      },
    );*/
  }

  _qr() {
    return RepaintBoundary(
      key: previewContainer,
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 50, right: 50, top: 10),
        //margin: EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        width: 200,
        height: 200,
        child: InkWell(
          onTap: () async {
            _getWidgetImage();
          },
          child:
              //SizedBox()

              QrImage(
            data: _usuarioBloc.qrInvitado.toString(),
            version: QrVersions.auto,
            size: 190,
          ),

          /*QrImage(
              data: "mili", //usuarioBloc.qrInvitado,
              version: QrVersions.auto,
              size: 190.0,
            )*/
        ),
      ),
    );
  }

  Future<void> _getWidgetImage() async {
    ShareFilesAndScreenshotWidgets().shareScreenshot(
        previewContainer, originalSize, "Title", "Name.png", "image/png",
        text:
            "¡Hola! ${_usuarioBloc.invitado.nombre.toString()}, este es tu código QR de acceso.");
  }

  Future<Directory?> getExternalStorageDirectory() async {
    final Directory? path = await getExternalStorageDirectory();
    if (path == null) {
      return null;
    }
    return path;
  }

  Future<String> _guardarQR() async {
    String? urlCorta = "";
    try {
      /*final shortener = BitLyShortener(
          accessToken: "784ce10cf099581554f2c50169308aa659f7ed35");
      final linkData = await shortener.generateShortLink(longUrl: urlQr);
      urlCorta = linkData.link;
      print(linkData.link);*/
      String urlPadre = "https://communecampestre.web.app/#/commune/qr/";
      String url = urlPadre + _usuarioBloc.invitado.id!;

      FlutterClipboard.copy("¡Hola!,este es el link para tu acceso : ${url}")
          .then((value) {
        Fluttertoast.showToast(
          msg: 'El url ha sido copiado',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );
      });
    } on BitLyException catch (e) {
      //For handling TinyUrlException
      print(e.errors.toString());
      Fluttertoast.showToast(
        msg: 'Ocurrio un error generando tu link :(',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
      );
    } on Exception catch (e) {
      print("Ocurrio un error en comparit el url del QR" + e.toString());
      Fluttertoast.showToast(
        msg: 'Ocurrio un error :(',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
      );
    }
    return urlCorta ?? "";
  }

  saveQr() async {
    await Future.delayed(Duration(seconds: 2));
    try {
      final RenderRepaintBoundary boundary = previewContainer.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage();
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      print(pngBytes);

      String response;
      Reference reference =
          storage.ref().child("${_usuarioBloc.invitado.id}/qr");
      UploadTask uploadTask = reference.putData(pngBytes);
      response = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();

      print(response);
      urlQr = response;
      print("Url guardado  : " + urlQr);
    } on BitLyException catch (e) {
      //For handling TinyUrlException
      print(e.errors.toString());
      Fluttertoast.showToast(
        msg: 'Ocurrio un error generando tu link :(',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
      );
    } on Exception catch (e) {
      print("Ocurrio un error en comparit el url del QR" + e.toString());
      Fluttertoast.showToast(
        msg: 'Ocurrio un error :(',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
      );
    }
    return;
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => VisitasEventosPage(id: idEvento),
      ),
    );
    return true;
    /*return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Des?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;*/
  }
}
