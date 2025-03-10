import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:clipboard/clipboard.dart';
import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/view/menuInicio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_shortener/bitly_shortener.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:ui' as ui;

import '../provider/splashProvider.dart';

class ConfirmacionVistitas extends StatefulWidget {
  //const ConfirmacionVistitas({ Key? key }) : super(key: key);

  @override
  State<ConfirmacionVistitas> createState() => _ConfirmacionVistitasState();
}

class _ConfirmacionVistitasState extends State<ConfirmacionVistitas> {
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  late String urlQr;

  final FirebaseStorage storage = FirebaseStorage.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // saveQr();
  }

  @override
  Widget build(BuildContext context) {
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
            //Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuInicio()),
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
          SizedBox(
            height: 20,
          ),
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
          SizedBox(
            height: 20,
          ),
          _qr(),
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 20, right: 40, left: 40),
            child: TextButton(
              //minWidth: 100,
              onPressed: () async {
                //_getWidgetImage();
                String urlPadre =
                    "https://communecampestre.web.app/#/commune/qr/";
                String url = urlPadre + _usuarioBloc.invitado.id!;
                await Share.share(
                    "¡Hola!,este es el link para tu acceso ${url}");
              },
              style: TextButton.styleFrom(
                backgroundColor: _usuarioBloc.miFraccionamiento.getColor(),
                padding: const EdgeInsets.all(0),
              ),
              child: const Text(
                "Compartir url de acceso",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
          //urlShortener(),
          Container(
            margin: EdgeInsets.only(bottom: 20, top: 0, right: 30, left: 30),
            padding: EdgeInsets.all(10),
            child: TextButton(
              //minWidth: 100,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuInicio()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding:const EdgeInsets.all(0),
              ),
              child: Text(
                "Atrás",
                style: TextStyle(
                    fontSize: 15,
                    color: _usuarioBloc.miFraccionamiento.getColor())              
              ),
            ),
          )
        ],
      ),
    );
  }

  urlShortener() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 20, right: 40, left: 40),
      child: TextButton(
        //minWidth: 100,
        onPressed: () {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
          _guardarQR();
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        },
        style: TextButton.styleFrom(
          backgroundColor: _usuarioBloc.miFraccionamiento.getColor(),
          padding: const EdgeInsets.all(0),
        ),
        child: const Row(
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
        /*Fluttertoast.showToast(
          msg: 'El url ha sido copiado',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
        );*/

        Alert(
            context: context,
            desc: "El url ha sido copiado",
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
    return urlCorta;
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
}
