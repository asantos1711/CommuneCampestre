import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../bloc/usuario_bloc.dart';
import '../controls/connection.dart';
import '../models/EstadoCuentaDireccion.dart';
import '../models/modeloRegistro.dart';
import '../models/responseLote.dart';
import '../models/usuarioModel.dart';
import '../provider/splashProvider.dart';
import '../services/apiResidencial/registroUsuarios.dart';
import '../services/push_notifications_services.dart';
import '../widgets/textfielborder.dart';
import 'login.dart';
import 'terminos.dart';

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
  String mailSelected = "0";
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
  bool _aceptar = false, visiblePassword = true;
  String remotePDFpath = "";
  ResponseGetLote? _loteServices;
  List<Usuario> usuarios = [];

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
      _loteServices = await EstadoCuentaDireccion.getLote(this.widget.lote);
      setState(() {
        _nombre.text = datos.data!.direccion!.name.toString();
        _email.text = _loteServices!.data!.residenteLotes![0].residente!
            .correoElectronicoList![0].correo
            .toString();
        _reflote.text = datos.data!.direccion!.direccion.toString();
      });

      _validacionCorreo();
    }
  }

  _validacionCorreo() async {
    DatabaseServices databaseServices = DatabaseServices();
    usuarios = await databaseServices.getUsuarios(_email.text);

    print("Existen ${usuarios.length} con este correo");

    if (usuarios.length > 0) {
      setState(() {
        visiblePassword = false;
      });
      _modal();
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
    // ScreenUtil.init(context);

    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      //appBar: appBarOnlyPop(context, w),
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
        /*title: Text(
          "Opciones de registro",
          style: TextStyle(color: Colors.black),
        ),*/
      ),
      body: _loteServices != null
          ? _form()
          : Center(
              child: Image.asset(
                "assets/icon/casita.gif",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
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
                "Registro",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 20),
              alignment: Alignment.center,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: _usuarioBloc.miFraccionamiento.getColor(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: w - w / 3,
                      child: Text(
                        "Los datos deben coincidir con los registrados en administración",
                        style: TextStyle(
                            color: _usuarioBloc.miFraccionamiento.getColor()),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormFieldBorder(
                "Dirección completa",
                _reflote,
                readOnly: true,
                type: TextInputType.text,
                obscure: false,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormFieldBorder(
                "Nombre completo",
                _nombre,
                type: TextInputType.text,
                obscure: false,
                color: Colors.white,
                readOnly: true,
              ),
            ),
            SizedBox(
              height: 30,
            ),

            Row(
              children: [
                Expanded(
                  //padding: EdgeInsets.only(left: 35),
                  //width: w * 0.5,
                  child: Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: TextFormField(
                        decoration: InputDecoration(
                          //prefixIcon: prefixIcon,
                          filled: true,
                          enabled: false,
                          labelText: "Email",
                          fillColor: Colors.white,
                          hintText: "Email",
                          enabledBorder: border(false),
                          focusedBorder: border(true),
                          border: border(false),
                        ),
                        readOnly: true,
                        enabled: false,
                        controller: _email,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Campo requerido";
                          }

                          return null;
                        } as String? Function(String?)?),
                  ),
                ),
                usuarios.length > 0
                    ? TextButton.icon(
                        onPressed: () {
                          _modal();
                        },
                        icon: Icon(Icons.edit),
                        label: Text(""))
                    : SizedBox(),
              ],
            ),

            SizedBox(
              height: 30,
            ),

            Padding(
              padding: EdgeInsets.only(left: 35, right: 25),
              child: Text(
                "Ingresa tus datos",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: _usuarioBloc.miFraccionamiento.getColor()),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormFieldBorder("Telefono", _telefono,
                  readOnly: false,
                  type: TextInputType.phone,
                  obscure: false,
                  color: Colors.white),
            ),
            SizedBox(height: 30),
            Visibility(
                visible: visiblePassword,
                child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormFieldBorder(
                        "Password", //Translations.of(context).text("password"),
                        _password,
                        type: TextInputType.visiblePassword,
                        obscure: true,
                        readOnly: false,
                        color: Colors.white))),
            SizedBox(height: 30),

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
        if (_email.text.isEmpty) {
          Alert(
            context: context,
            desc: "Debe tener asignado un correo electrónico",
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
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          return;
        }

        if (!_formKey.currentState!.validate()) {
          print(PushNotificationsService.token);
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);
          return;
        }
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

        bool hayLote =
            (this.widget.lote != null && this.widget.lote.isNotEmpty);
        try {
          _usuario.nombre = _nombre.text;
          _usuario.email = _email.text;
          _usuario.telefono = _telefono.text;
          _usuario.direccion = _reflote.text;
          _usuario.tokenNoti = PushNotificationsService.token;
          _usuario.tipo = "Titular";
          _usuario.estatus = "1";
          _usuario.idFraccionamiento = _usuarioBloc.miFraccionamiento.id;
          _usuario.lote = hayLote ? int.parse(this.widget.lote) : null;

          if (usuarios.isEmpty) {
            //En caso de que no haya email asociado a lote,
            //que sea el primer lote para el email
            UserCredential val =
                await db.registerUser(_email.text, _password.text);
            _usuario.idResidente = val.user!.uid + "_" + "1";
          } else {
            //En caso de haber más de un lote encntrado

            bool containsMail = false;
            usuarios.forEach((element) {
              containsMail = element.email!.contains(_email.text);
            });

            //Si decide usar el mismo email para el nuevo lote
            if (containsMail) {
              String id = usuarios[0].idResidente!.split("_")[0];
              _usuario.idResidente =
                  id + "_" + (usuarios.length + 1).toString();
            } else {
              //Si decide usar otro mail para el nuevo lote
              UserCredential val =
                  await db.registerUser(_email.text, _password.text);
              _usuario.idResidente = val.user!.uid + "_" + "1";
            }
          }

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
              _usuario.lote = response.data!.lote!.id;
              _usuario.estatus = "1";
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

  _modal() {
    TextEditingController otro = TextEditingController();
    String imageEncoded = "";
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (c, setState) {
        return AlertDialog(
          //title: const Text('Correo de acceso'),
          content: Container(
            width: w * 0.95,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Hemos encontrado que dirección de correo (${usuarios.first.email}) ya tiene un lote asociado.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  RadioListTile(
                    title: Text(
                        "Utilizar el mismo correo (${usuarios.first.email})",
                        style: TextStyle(fontSize: 15)),
                    value: "0",
                    groupValue: mailSelected,
                    onChanged: (value) {
                      setState(() {
                        mailSelected = value.toString();
                        _email.text = usuarios.first.email.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: TextField(
                      controller: otro,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Utilizar otro",
                          hintStyle: TextStyle(fontSize: 15)),
                    ),
                    value: "1",
                    groupValue: mailSelected,
                    onChanged: (value) {
                      setState(() {
                        mailSelected = value.toString();
                        //_email.text = otro.text.toString();
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            /*TextButton(
              onPressed: () => Navigator.pop(context, 'Cancelar'),
              child: const Text('Cancelar'),
            ),*/
            TextButton(
              onPressed: () async {
                Provider.of<LoadingProvider>(context, listen: false)
                    .setLoad(true);
                this.setState(() {
                  if (mailSelected == "0") {
                    _email.text = usuarios.first.email.toString();
                    visiblePassword = false;
                  }

                  if (mailSelected == "1") {
                    _email.text = otro.text.toString();
                    visiblePassword = true;
                  }
                });

                Provider.of<LoadingProvider>(context, listen: false)
                    .setLoad(false);
                Navigator.pop(context, 'Continuar');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      }),
    );
  }
}
