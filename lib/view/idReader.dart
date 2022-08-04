import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show EventChannel, PlatformException, rootBundle;
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_document_reader_core_full/flutter_document_reader_core_full.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../bloc/usuario_bloc.dart';
import '../provider/splashProvider.dart';
import 'trabajadores/visitasTrabajadoresPage.dart';

class IdReaderView extends StatefulWidget {
  const IdReaderView({Key? key}) : super(key: key);

  @override
  State<IdReaderView> createState() => _IdReaderViewState();
}

class _IdReaderViewState extends State<IdReaderView> {
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  Future<List<String>> getImages() async {
    Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
    setStatus("Procesando imagen...");
    List<XFile>? files = await ImagePicker().pickMultiImage();
    List<String> result = [];
    for (XFile file in files!)
      result.add(base64Encode(io.File(file.path).readAsBytesSync()));
    Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
    return result;
  }

  Object setStatus(String s) => {setState(() => _status = s)};
  String _status = "Cargando...";
  String _platformVersion = 'Unknown';
  bool isReadingRfid = false;
  String rfidUIHeader = "Leyendo RFID";
  Color rfidUIHeaderColor = Colors.black;
  String rfidDescription = "Coloca tu teléfono encima de la etiqueta NFC";
  double rfidProgress = -1;
  var _portrait = Image.asset('assets/images/portrait.png');
  var _docImage = Image.asset('assets/images/id.png');
  List<List<String>> _scenarios = [];
  String _selectedScenario = "FullProcess";
  String result = "";
  bool _canRfid = false;
  bool _doRfid = false;
  var printError =
      (Object error) => print((error as PlatformException).message);

  @override
  void initState() {
    super.initState();
    initPlatformState();
    EventChannel('flutter_document_reader_api/event/completion')
        .receiveBroadcastStream()
        .listen((jsonString) => this.handleCompletion(
            DocumentReaderCompletion.fromJson(json.decode(jsonString))!));
    EventChannel('flutter_document_reader_api/event/database_progress')
        .receiveBroadcastStream()
        .listen(
            (progress) => setStatus("Downloading database: " + progress + "%"));
    EventChannel(
            'flutter_document_reader_api/event/rfid_notification_completion')
        .receiveBroadcastStream()
        .listen((event) =>
            print("rfid_notification_completion: " + event.toString()));
  }

  void addCertificates() async {
    List certificates = [];
    final manifestJson =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final certPaths = json
        .decode(manifestJson)
        .keys
        .where((String key) => key.startsWith('assets/certificates'));

    for (var path in certPaths) {
      var findExt = path.split('.');
      var pkdResourceType = 0;
      if (findExt.length > 0)
        pkdResourceType =
            PKDResourceType.getType(findExt[findExt.length - 1].toLowerCase());
      ByteData byteData = await rootBundle.load(path);
      var certBase64 = base64.encode(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      certificates
          .add({"binaryData": certBase64, "resourceType": pkdResourceType});
    }

    DocumentReader.addPKDCertificates(certificates)
        .then((value) => print("certificates added"));
  }

  void handleCompletion(DocumentReaderCompletion completion) {
    if (isReadingRfid &&
        (completion.action == DocReaderAction.CANCEL ||
            completion.action == DocReaderAction.ERROR)) this.hideRfidUI();
    if (isReadingRfid && completion.action == DocReaderAction.NOTIFICATION)
      this.updateRfidUI(completion.results!.documentReaderNotification);
    if (completion.action ==
        DocReaderAction.COMPLETE) if (isReadingRfid) if (completion
            .results!.rfidResult !=
        1)
      this.restartRfidUI();
    else {
      this.hideRfidUI();
      this.displayResults(completion.results!);
    }
    else
      this.handleResults(completion.results!);
  }

  void showRfidUI() {
    // show animation
    setState(() => isReadingRfid = true);
  }

  hideRfidUI() {
    // show animation
    this.restartRfidUI();
    DocumentReader.stopRFIDReader();
    setState(() {
      isReadingRfid = false;
      rfidUIHeader = "Reading RFID";
      rfidUIHeaderColor = Colors.black;
    });
  }

  restartRfidUI() {
    setState(() {
      rfidUIHeaderColor = Colors.red;
      rfidUIHeader = "Failed!";
      rfidDescription = "Place your phone on top of the NFC tag";
      rfidProgress = -1;
    });
  }

  updateRfidUI(results) {
    if (results.code ==
        eRFID_NotificationCodes.RFID_NOTIFICATION_PCSC_READING_DATAGROUP)
      setState(() =>
          rfidDescription = eRFID_DataFile_Type.getTranslation(results.number));
    setState(() {
      rfidUIHeader = "Reading RFID";
      rfidUIHeaderColor = Colors.black;
      rfidProgress = results.value / 100;
    });
    if (Platform.isIOS)
      DocumentReader.setRfidSessionStatus(
          rfidDescription + "\n" + results.value.toString() + "%");
  }

  customRFID() {
    this.showRfidUI();
    DocumentReader.readRFID();
  }

  usualRFID() {
    setState(() => _doRfid = false);
    DocumentReader.startRFIDReader();
  }

  Future<void> initPlatformState() async {
    print(await DocumentReader.prepareDatabase("Full"));
    setStatus("Initializing...");
    ByteData byteData = await rootBundle.load("assets/regula.license");
    print(await DocumentReader.initializeReader(base64.encode(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes))));
    setStatus("Ready");
    bool canRfid = await DocumentReader.isRFIDAvailableForUse();
    setState(() => _canRfid = canRfid);
    List<List<String>> scenarios = [];
    var scenariosTemp =
        json.decode(await DocumentReader.getAvailableScenarios());
    for (var i = 0; i < scenariosTemp.length; i++) {
      DocumentReaderScenario? scenario = DocumentReaderScenario.fromJson(
          scenariosTemp[i] is String
              ? json.decode(scenariosTemp[i])
              : scenariosTemp[i]);
      scenarios.add([scenario!.name!, scenario.caption!]);
    }
    setState(() => _scenarios = scenarios);
    DocumentReader.setConfig({
      "functionality": {
        "videoCaptureMotionControl": true,
        "showCaptureButton": true
      },
      "customization": {
        "showResultStatusMessages": true,
        "showStatusMessages": true
      },
      "processParams": {"scenario": _selectedScenario}
    });
    DocumentReader.setRfidDelegate(RFIDDelegate.NO_PA);

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterDocumentReaderCore.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    // addCertificates();
  }

  displayResults(DocumentReaderResults results) {
    setState(() {
      Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
      /* _status = results.getTextFieldValueByType(
              eVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES) ??
          "";*/
      _docImage = Image.asset('assets/images/id.png');
      _portrait = Image.asset('assets/images/portrait.png');
      if (results.getGraphicFieldImageByType(207) != null)
        _docImage = Image.memory(Uri.parse("data:image/png;base64," +
                results
                    .getGraphicFieldImageByType(
                        eGraphicFieldType.GF_DOCUMENT_IMAGE)!
                    .replaceAll('\n', ''))
            .data!
            .contentAsBytes());
      if (results.getGraphicFieldImageByType(201) != null)
        _portrait = Image.memory(Uri.parse("data:image/png;base64," +
                results
                    .getGraphicFieldImageByType(eGraphicFieldType.GF_PORTRAIT)!
                    .replaceAll('\n', ''))
            .data!
            .contentAsBytes());
      result = "";
      for (var textField in results.textResult!.fields) {
        for (var value in textField!.values) {
          int val = 0;

          if (textField.fieldName == "Apellidos y nombres" ||
              textField.fieldName == "Surname and given names") {
            print("si entro");
            val++;
            if (val == 1) {
              result =
                  value!.value!.toString().replaceAll("\n", " ").toString() +
                      " ";

              //String foo = value.value!.replaceAll("/(\r\n|\n|\r)/gm", "").toString();
              _usuarioBloc.nombreTrabId = value.value;
            }
          }
          print(textField.fieldName! +
              ', value: ' +
              value!.value! +
              ', source: ' +
              value.sourceType.toString());
        }
      }

      Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
    });
  }

  void handleResults(DocumentReaderResults results) {
    if (_doRfid && results != null && results.chipPage != 0) {
      String accessKey =
          results.getTextFieldValueByType(eVisualFieldType.FT_MRZ_STRINGS)!;
      if (accessKey != null && accessKey != "")
        DocumentReader.setRfidScenario({
          "mrz": accessKey.replaceAll('^', '').replaceAll('\n', ''),
          "pacePasswordType": eRFID_Password_Type.PPT_MRZ
        });
      else if (results.getTextFieldValueByType(159) != null &&
          results.getTextFieldValueByType(159) != "")
        DocumentReader.setRfidScenario({
          "password": results.getTextFieldValueByType(159),
          "pacePasswordType": eRFID_Password_Type.PPT_CAN
        });

      // customRFID();
      usualRFID();
    } else {
      Provider.of<LoadingProvider>(context, listen: false).setLoad(true);

      displayResults(results);
      Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
    }
  }

  void onChangeRfid(bool? value) {
    setState(() => _doRfid = value! && _canRfid);
    DocumentReader.setConfig({
      "processParams": {"doRfid": _doRfid}
    });
  }

  Widget createImage(
      String title, double height, double width, ImageProvider image) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title),
          Image(height: height, width: width, image: image)
        ]);
  }

  Widget createButton(String text, VoidCallback onPress) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      transform: Matrix4.translationValues(0, -7.5, 0),
      child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(50, 10, 10, 10)),
          onPressed: onPress,
          child: Text(text)),
      width: 150,
    );
  }

  Widget _buildRow(int index) {
    Radio radio = new Radio(
        value: _scenarios[index][0],
        groupValue: _selectedScenario,
        onChanged: (value) => setState(() {
              print(value);
              _selectedScenario = value;
              DocumentReader.setConfig({
                "processParams": {"scenario": _selectedScenario}
              });
            }));
    return Container(
        child: ListTile(
            title: GestureDetector(
                onTap: () => radio.onChanged!(_scenarios[index][0]),
                child: Text(_scenarios[index][1])),
            leading: radio),
        padding: EdgeInsets.only(left: 40));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.white,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Visibility(
              visible: isReadingRfid,
              child: Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[]),
                    Container(
                        child: Text(rfidUIHeader,
                            textScaleFactor: 1.75,
                            style: TextStyle(color: rfidUIHeaderColor)),
                        padding: EdgeInsets.only(bottom: 40)),
                    Container(
                        child: Text(rfidDescription, textScaleFactor: 1.4),
                        padding: EdgeInsets.only(bottom: 40)),
                    FractionallySizedBox(
                        widthFactor: 0.6,
                        child: LinearProgressIndicator(
                            value: rfidProgress,
                            minHeight: 10,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFF4285F4)))),
                    TextButton(
                      onPressed: () => hideRfidUI(),
                      child: Text("X"),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.only(top: 50)),
                    ),
                  ]))),
          Visibility(
              visible: !isReadingRfid,
              child: Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          createImage("Retrato", 150, 150, _portrait.image),
                          createImage("Documento", 150, 200, _docImage.image),
                        ]),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 20, top: 10, bottom: 25),
                      child: Text(
                        "Escanear documento",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            createButton("Cámara", () {
                              Provider.of<LoadingProvider>(context,
                                      listen: false)
                                  .setLoad(true);
                              DocumentReader.showScanner();
                              Provider.of<LoadingProvider>(context,
                                      listen: false)
                                  .setLoad(false);
                            }),
                            createButton("Galería", () async {
                              Provider.of<LoadingProvider>(context,
                                      listen: false)
                                  .setLoad(true);
                              DocumentReader.recognizeImages(await getImages());
                              Provider.of<LoadingProvider>(context,
                                      listen: false)
                                  .setLoad(false);
                            }),
                          ]),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: 25, right: 20, top: 20),
                      alignment: Alignment.topLeft,
                      child: Text("Resultados \n\n" + result),
                    )),

                    /*Expanded(
                            child: Container(
                                color: Color.fromARGB(5, 10, 10, 10),
                                child: ListView.builder(
                                    itemCount: _scenarios.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            _buildRow(index)))),*/
                    /*CheckboxListTile(
                            value: _doRfid,
                            onChanged: onChangeRfid,
                            title: Text(
                                "Process rfid reading ${_canRfid ? "" : "(unavailable)"}")),*/

                    SizedBox(
                      height: 50,
                    ),
                    result.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VisitasTrabajadoresPage()),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color:
                                    _usuarioBloc.miFraccionamiento.getColor(),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        25.0) //                 <--- border radius here
                                    ),
                              ),
                              child: Text(
                                "Continuar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ))
                        : SizedBox(),
                    SizedBox(
                      height: 50,
                    ),
                  ]))),
        ]));
  }
}
