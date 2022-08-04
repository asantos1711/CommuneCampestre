import 'package:flutter/material.dart';

import '../bloc/usuario_bloc.dart';
import '../widgets/ui_helper.dart';

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  UIHelper u = new UIHelper();
  double w = 0, h = 0;
  static GlobalKey _renderObjectKey = new GlobalKey();
  UsuarioBloc usuarioBloc = new UsuarioBloc();
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: u.bottomBar(h, w, 1, context),
        body: Stack(children: <Widget>[
          ListView(children: [
            Container(
              width: w - 50,
              // height: 800,
              margin: EdgeInsets.only(top: h / 40, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500]!,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 10.0,
                    ),
                  ],
                  border: Border.all(width: 1, style: BorderStyle.none),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Column(children: [
                SizedBox(
                  height: 45,
                ),
                _qrText(),
                SizedBox(
                  height: 15,
                ),
                _scaneaText(),
                SizedBox(
                  height: 15,
                ),
                _qr(),
                SizedBox(
                  height: 45,
                ),
                _button(),
                SizedBox(
                  height: 25,
                ),
                _otroInvitado(),
                SizedBox(
                  height: 45,
                ),
              ]),
            ),
          ]),
        ]));
  }

  _qr() {
    return InkWell(
      onTap: () async {
        //Navigator.of(context).pop();

        /*final Uint8List bytes = await _getWidgetImage();
        await Sharedos.Share.file('esys image', 'esys.png', bytes, 'image/png',
            text: "Código de invitado");*/
      },
      child: RepaintBoundary(
        key: _renderObjectKey,
        child: Container(
            //margin: EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(color: Color(0xFF5562A1), width: 3),
                color: Colors.white),
            child: SizedBox()
            /*QrImage(
                data: 'This is a simple QR code',
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              ),*/

            /*QrImage(
              data: "mili", //usuarioBloc.qrInvitado,
              version: QrVersions.auto,
              size: 190.0,
            )*/
            ),
      ),
    );
  }

  /*Future<Uint8List> _getWidgetImage() async {
    try {
      RenderRepaintBoundary boundary =
          _renderObjectKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData>);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      debugPrint(bs64.length.toString());
      return pngBytes;
    } catch (exception) {}
  }*/

  _scaneaText() {
    return Text(
      "Puede compartir el código QR con su invitado",
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }

  _qrText() {
    return Text(
      "Invitado",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _button() {
    return InkWell(
      onTap: () async {
        /*final Uint8List bytes = await _getWidgetImage();
        await Sharedos.Share.file('esys image', 'esys.png', bytes, 'image/png',
            text: "Compartir QR");*/
      },
      child: Container(
        width: w - 120,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF5562A1),
          borderRadius: BorderRadius.all(
              Radius.circular(30.0) //         <--- border radius here
              ),
        ),
        child: Text(
          "Compartir",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _otroInvitado() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InvitadosView()),
        );*/
      },
      child: Container(
          child: Text(
        "Ingresar otro invitado",
        style: TextStyle(fontSize: 14, color: Color(0xFF434343)),
      )),
    );
  }
}
