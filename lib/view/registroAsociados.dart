import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/usuarioModel.dart';
import 'package:campestre/provider/splashProvider.dart';
import 'package:campestre/view/menuInicio.dart';
import 'package:campestre/view/registroSucess.dart';
import 'package:campestre/widgets/textfielborder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegistroAsociados extends StatefulWidget {
  const RegistroAsociados({Key? key}) : super(key: key);

  @override
  State<RegistroAsociados> createState() => _RegistroAsociadosState();
}

class _RegistroAsociadosState extends State<RegistroAsociados> {
  ShapeBorder _customBorder = CircleBorder();
  double w = 0, h = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _nombre = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _telefono = TextEditingController();
  TextEditingController _reflote = TextEditingController();
  Usuario _usuario = new Usuario();
  DatabaseServices db = new DatabaseServices();
  late bool onCharge;
  int? tiponum = 1;
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Ingresa los datos para crear una cuenta asociada",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                    child: TextFormFieldBorder("Telefono celular", _telefono,
                        TextInputType.phone, false, Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            //_tipo(),
            _button(),
          ],
        ));
  }

  Widget _button() {
    return //Text("Holaaa", style: TextStyle(fontSize: 30, color: Colors.red),);
        Ink(
            width: 250,
            height: 100,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                //width: w/2,
                alignment: Alignment.center,
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
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () async {
                Provider.of<LoadingProvider>(context, listen: false)
                    .setLoad(true);

                try {
                  //_charge(true);
                  if (!_formKey.currentState!.validate()) {
                    Provider.of<LoadingProvider>(context, listen: false)
                        .setLoad(false);
                    return;
                  }
                  setState(() {
                    _usuario.nombre = _nombre.text;
                    _usuario.email = _email.text;
                    _usuario.telefono = _telefono.text;
                    _usuario.idResidente = _reflote.text;
                    _usuario.direccion = _usuarioBloc.perfil.direccion;
                    _usuario.lote = _usuarioBloc.perfil.lote;
                    _usuario.idTitular = _usuarioBloc.perfil.idResidente;
                    _usuario.tipo = "Habitante";
                    _usuario.estatus = "1";
                    _usuario.idRegistro = _usuarioBloc.perfil.idRegistro;
                  });
                  Map<String, bool> val =
                      await db.registerUser(_email.text, _password.text);

                  print("el val****");
                  print(val);

                  db.guardarDatosRegistro(_usuario).whenComplete(() async {
                    Fluttertoast.showToast(
                      msg: 'Se ha dado de alta al usuario',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.grey[800],
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistroSucess()),
                    );

                    Provider.of<LoadingProvider>(context, listen: false)
                        .setLoad(false);

                    /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );*/
                  });

                  Provider.of<LoadingProvider>(context, listen: false)
                      .setLoad(false);
                } on FirebaseAuthException catch (ef) {
                  Provider.of<LoadingProvider>(context, listen: false)
                      .setLoad(false);
                  Fluttertoast.showToast(
                    msg: 'Error en el registro ' + ef.message.toString(),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey[800],
                  );
                } catch (e) {
                  Provider.of<LoadingProvider>(context, listen: false)
                      .setLoad(false);
                  Fluttertoast.showToast(
                    msg: 'Error en el registro',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey[800],
                  );
                  print("Error en registro: " + e.toString());
                }
              },
            ));
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "Registro de cuentas asociadas",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      leading: Container(
        child: Ink(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: InkWell(
            //child: Icon(FontAwesome.power_off, color: Colors.black, ),
            child: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black,
              size: 23,
            ),
            customBorder: _customBorder,
            splashColor: Color(0xff5E1281),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuInicio()),
              );
            },
          ),
        ),
      ),
    );
  }
}
