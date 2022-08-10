import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/view/login.dart';
import 'package:campestre/widgets/cuadroLoginShape.dart';
import 'package:campestre/widgets/textfielborder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecuperarContra extends StatefulWidget {
  //const RecuperarContra({ Key? key }) : super(key: key);

  @override
  State<RecuperarContra> createState() => _RecuperarContraState();
}

class _RecuperarContraState extends State<RecuperarContra> {
  TextEditingController _email = TextEditingController();
  double w = 0.0, h = 0.0;
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                child: Center(
                  child: CustomPaint(
                    size: Size(400, 300),
                    painter: CurvedPainter(),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 15, left: 50, right: 20),
                  child: Text("Recuperar contraseña",
                      style: TextStyle(color: Colors.black, fontSize: 20))),
              Container(
                  margin: EdgeInsets.only(top: 15, left: 50, right: 20),
                  child: Text("Ingrese su correo electrónico",
                      style: TextStyle(color: Colors.black, fontSize: 14))),
              _nombreField(),
              /*Container(
            width: w - 50,
            // height: 800,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormFieldBorder("CORREO", _email,
                      TextInputType.emailAddress, false, Colors.white),
                ),
              ])
          ),*/
              _button(),
              _buttonCancelar()
            ],
          ),
        ));
  }

  _nombreField() {
    return Container(
        padding: EdgeInsets.only(left: 50, right: 50),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {},

          keyboardType: TextInputType.emailAddress,

          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hoverColor: Colors.purple,
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: "Correo",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: _email,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  Widget _button() {
    return InkWell(
      onTap: () async {
        if (!_formKey.currentState!.validate()) {
          //bloquear(false);
          return;
        }
        try {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: _email.text)
              .whenComplete(() {
            Fluttertoast.showToast(
              msg: 'Se ha enviado un enlace a tu correo',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey[800],
            );
          });
        } on FirebaseAuthException catch (e) {
          print(e.code);
          print(e.message);
        }
      },
      child: Container(
        width: w - 100,
        margin: EdgeInsets.only(left: 50, right: 50, top: 50),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          /*color: Color.fromARGB(255, _fraccionamiento.color?.r ?? 0,
              _fraccionamiento.color?.g ?? 0, _fraccionamiento.color?.b ?? 0),*/
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
          "ENVIAR",
          style: TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buttonCancelar() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => LoginPage(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      },
      child: Container(
        width: w - 100,
        margin: EdgeInsets.only(left: 50, right: 50, top: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          /*color: Color.fromARGB(255, _fraccionamiento.color?.r ?? 0,
              _fraccionamiento.color?.g ?? 0, _fraccionamiento.color?.b ?? 0),*/

          borderRadius: BorderRadius.all(
              Radius.circular(30.0) //         <--- border radius here
              ),
        ),
        child: Text(
          "CANCELAR",
          style: TextStyle(
              color: Color.fromARGB(
                  255,
                  _usuarioBloc.miFraccionamiento.color!.r,
                  _usuarioBloc.miFraccionamiento.color!.g,
                  _usuarioBloc.miFraccionamiento.color!.b),
              fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
