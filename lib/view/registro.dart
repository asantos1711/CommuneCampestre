import 'dart:async';
import 'dart:io';

import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/EstadoCuentaDireccion.dart';
import 'package:campestre/models/usuarioModel.dart';
import 'package:campestre/services/apiResidencial/registroUsuarios.dart';
import 'package:campestre/view/login.dart';
import 'package:campestre/view/terminos.dart';
import 'package:campestre/widgets/textfielborder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../bloc/usuario_bloc.dart';
import '../models/modeloRegistro.dart';
import '../provider/splashProvider.dart';
import '../services/push_notifications_services.dart';

//import 'package:toast/toast.dart';

class RegistroView extends StatefulWidget {
  String lote;
  RegistroView(this.lote);

  @override
  _RegistroViewState createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  double w = 0, h = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _nombre = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _telefono = TextEditingController();
  TextEditingController _reflote = TextEditingController();
  Usuario _usuario = new Usuario();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  DatabaseServices db = new DatabaseServices();
  late bool onCharge;
  int? tiponum = 1;
  bool _aceptar = false;
  String remotePDFpath = "";

  @override
  void initState() {
    onCharge = false;
    _setDatos();
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
    super.initState();
  }

  _setDatos() async {
    if (this.widget.lote != null && this.widget.lote.isNotEmpty) {
      EstadoCuentaDireccion datos =
          await EstadoCuentaDireccion.getEstadoDireccion(this.widget.lote);
      print(datos.toJson().toString());
      setState(() {
        _nombre.text = datos.data!.direccion!.name.toString();
        _reflote.text = datos.data!.direccion!.direccion.toString();
      });
    }
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = _usuarioBloc.miFraccionamiento.terminos!;
      // "https://firebasestorage.googleapis.com/v0/b/commune-cf48f.appspot.com/o/fraccionamientos%2FPOLITICAS%20PARA%20EL%20USO%20DE%20QR%20CAMPESTRE.pdf?alt=media&token=79df43c7-6a06-4d5f-a5f0-73edc9d81949";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      Fluttertoast.showToast(msg: "No hay término disponibles.");
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  _charge(bool val) {
    setState(() {
      onCharge = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
      ),
      body: _form(),
    );
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 15),
          children: [
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "Ingresa tus datos para crear tu cuenta",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormFieldBorder("Nombre completo", _nombre,
                  TextInputType.text, false, Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormFieldBorder("Email", _email,
                  TextInputType.emailAddress, false, Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormFieldBorder(
                    "Password", //Translations.of(context).text("password"),
                    _password,
                    TextInputType.visiblePassword,
                    true,
                    Colors.white)),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormFieldBorder("Telefono", _telefono,
                  TextInputType.phone, false, Colors.white),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormFieldBorder("Dirección completa", _reflote,
                  TextInputType.text, false, Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            _terminos(),
            SizedBox(
              height: 30,
            ),
            //_tipo(),
            _button(),
            SizedBox(
              height: 30,
            ),
          ],
        ));
  }

  _terminos() {
    return Container(
        margin: EdgeInsets.only(left: 25),
        child: Row(
          children: [
            Checkbox(
              activeColor: _usuarioBloc.miFraccionamiento.getColor(),
              value: _aceptar,
              onChanged: (bool? value) {
                setState(() {
                  _aceptar = value as bool;
                });
              },
            ),
            InkWell(
                onTap: () {
                  if (remotePDFpath.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFScreen(path: remotePDFpath),
                      ),
                    );
                  }
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TerminosView()),
                  );*/
                },
                child: Container(
                  child: Text("Acepto términos y condiciones",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                )),
          ],
        ));
  }

  _tipo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Text(
            'Soy ...',
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          title: Text(
            'Titular',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.black),
          ),
          leading: Radio(
            value: 0,
            groupValue: tiponum,
            activeColor: Color(0xFF6200EE),
            onChanged: (int? value) {
              setState(() {
                tiponum = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text(
            'Habitante',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.black),
          ),
          leading: Radio(
            value: 1,
            groupValue: tiponum,
            activeColor: Color(0xFF6200EE),
            onChanged: (int? value) {
              setState(() {
                tiponum = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _button() {
    UsuarioBloc usuarioBloc = new UsuarioBloc();
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 40, right: 40),
        width: w / 2,
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
          style: TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      onTap: () async {
        Provider.of<LoadingProvider>(context, listen: false).setLoad(true);

        if (!_aceptar) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          Fluttertoast.showToast(
            msg: 'Debes de aceptar términos y condiciones',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );
          return;
        }
        if (!_formKey.currentState!.validate()) {
          print(PushNotificationsService.token);
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          return;
        }
        bool hayLote =
            (this.widget.lote != null && this.widget.lote.isNotEmpty);
        try {
          _usuario.nombre = _nombre.text;
          _usuario.email = _email.text;
          _usuario.telefono = _telefono.text;
          _usuario.idResidente = _reflote.text;
          _usuario.direccion = _reflote.text;
          _usuario.tokenNoti = PushNotificationsService.token;
          _usuario.tipo = "Titular";
          _usuario.estatus = "0";
          _usuario.lote = hayLote ? int.parse(this.widget.lote) : null;

          UserCredential val =
              await db.registerUser(_email.text, _password.text);

          print("el val****");
          print(val);
          _usuario.idResidente = val.user?.uid;

          db.guardarDatosRegistro(_usuario).whenComplete(() async {
            if (!hayLote) {
              Fluttertoast.showToast(
                msg:
                    'Tus datos serán enviados a la administración para ser aprobada',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey[800],
              );
            }

            RegistroUsuarioConnect connect = RegistroUsuarioConnect();
            ResponseRegistro response = await connect.mandarRegistro(_usuario);

            if (response.success ?? false) {
              /** Guardado del id en sharedPrefrence*/ //TODO
              _usuario.idRegistro = response.data!.id;
              await db.guardarDatosRegistro(_usuario);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            } else {
              Fluttertoast.showToast(
                msg: 'Ocurrio un error al mandar tus datos',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey[800],
              );
            }

            Provider.of<LoadingProvider>(context, listen: false).setLoad(false);

            /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );*/
          });

          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
        } on FirebaseAuthException catch (ef) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          Fluttertoast.showToast(
            msg: 'Error en el registro ' + ef.message.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );
        } catch (e) {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          Fluttertoast.showToast(
            msg: 'Error en el registro',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
          );
          print("Error en registro: " + e.toString());
        }
      },
    );
  }
}
