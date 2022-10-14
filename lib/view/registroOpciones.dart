import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/view/registro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/splashProvider.dart';
import '../services/apiResidencial/registroUsuarios.dart';

class RegistroOpciones extends StatefulWidget {
  const RegistroOpciones({Key? key}) : super(key: key);

  @override
  State<RegistroOpciones> createState() => _RegistroOpcionesState();
}

class _RegistroOpcionesState extends State<RegistroOpciones> {
  UsuarioBloc usuarioBloc = UsuarioBloc();
  double? w, h;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF0C0C0C),
            )),
        title: Text(
          "Opciones de registro",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          //height: h,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              // _registroManual(),
              // _opcionLeerId(),

              /*SizedBox(
                height: 20,
              ),
              //_opcionDelivery(),
              _opcionLeerId(),*/
              SizedBox(
                height: 20,
              ),
              _registroQR(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _registroQR() {
    return _opcion("Registro por QR", FontAwesome.qrcode, () async {
      var result;
      try {
        result = await BarcodeScanner.scan();
        Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
        if (result.type.name.contains("Cancelled") ||
            result.type.name.contains("Failed")) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          return;
        }
        print(result.type);
        print(result.format);
        print(result.rawContent);

        print(result.rawContent);

        final str = result.rawContent.toString();

        final str2 = utf8.decode(base64.decode(str));
        print(str2);

        RegistroUsuarioConnect connect = RegistroUsuarioConnect();
        bool isALreadyExist = await connect.isAlreadyLoteUsed(str2);
        print("Is Al readyExist");
        print(isALreadyExist);
        if (isALreadyExist) {
          Fluttertoast.showToast(
            msg: 'Este código de resgistro ya ha sido utilizado',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          return;
        }

        if (str2 != null && str2.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistroView(str2)),
          );
        }

        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
      } catch (e) {}
    });
  }

  _opcionLeerId() {
    return _opcion("Escanear ID", FontAwesome.id_card, () async {
      try {} catch (e) {}
    });
  }

  _opcionDelivery() {
    // List<BarcodeFormat> restrictFormat = const [BarcodeFormat.code128];
    return _opcion("Registro por QR NUEVO Lector", FontAwesome.qrcode,
        () async {
      var result;
      try {
        /* result = await BarcodeScanner.scan(
            options: ScanOptions(restrictFormat: restrictFormat));
        Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
        if (result.type.name.contains("Cancelled") ||
            result.type.name.contains("Failed")) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          return;
        }
        print(result.type);
        print(result.format);
        print(result.rawContent);

        print(result.rawContent);*/
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRViewExample()),
        );*/
        Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
      } catch (e) {}
    });
  }

  _registroManual() {
    return _opcion("Registro con datos", FontAwesomeIcons.penToSquare, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistroView("")),
      );
    });
  }

  _opcionLlamarMesero() {
    return _opcion("Llamar a mesero", FontAwesome.hand_stop_o, () {});
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
}

/*class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}*/
