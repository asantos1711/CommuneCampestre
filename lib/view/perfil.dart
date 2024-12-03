import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Perfil extends StatefulWidget {
  //const Perfil({ Key? key }) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  double? w, h;
  TextEditingController _nombre = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _tel = new TextEditingController();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  bool _edit = false;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    _nombre.text = _usuarioBloc.perfil.nombre!;
    _email.text = _usuarioBloc.perfil.email!;
    _tel.text = _usuarioBloc.perfil.telefono!;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Perfil",
              style: TextStyle(fontSize: 20, color: Color(0xFF06323D))),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
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
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //_foto(),
              _titulo(),
              !_edit
                  ? _content("Nombre", _nombre.text)
                  : _datos("Nombre", _nombre, _edit, wi: w),
              !_edit
                  ? _content("Email", _email.text)
                  : _datos("Email", _email, _edit, wi: w),
              !_edit
                  ? _content("Télefono", _tel.text)
                  : _datos("Teléfono", _tel, _edit, wi: w),

              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: _usuarioBloc.miFraccionamiento.getColor(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: w! - w! / 4,
                    child: Text(
                      "Favor de verificar su información, sino es correcta debe acercarse a administración para actualizarla",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: _usuarioBloc.miFraccionamiento.getColor()),
                    ),
                  )
                ]),
              )

              //!_edit ? _botonEditar() : _botonGuardar()
            ],
          ),
        )));
  }

  _foto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(20),
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/commune-cf48f.appspot.com/o/descarga.jpeg?alt=media&token=9f44c41f-4824-4389-9a92-22474bc340fb"),
            backgroundColor: Colors.transparent,
          ),
        )
      ],
    );
  }

  _titulo() {
    return Container(
        //margin: EdgeInsets.all(30),
        child: Text(
      "Información del usuario",
      style: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(
              255,
              _usuarioBloc.miFraccionamiento.color!.r,
              _usuarioBloc.miFraccionamiento.color!.g,
              _usuarioBloc.miFraccionamiento.color!.b),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3),
    ));
  }

  _content(String txt, String txt2) {
    return Container(
        margin: EdgeInsets.only(top: 32, right: 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            child: Text(
              txt,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff4F4F4F)),
            ),
          ),
          Container(
              child: Text(
            txt2,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff4F4F4F)),
          ))
        ]));
  }

  Widget _datos(String txt, TextEditingController controlador, bool habilitado,
      {TextInputType? entrada,
      bool? onlyDigits,
      bool? obscure,
      String? txtAbajo,
      bool? requerido,
      double? wi,
      bool? pwd,
      bool? year}) {
    return Container(
      margin: EdgeInsets.only(top: 32, right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              txt,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff4F4F4F)),
            ),
          ),
          Container(
            width: wi ?? w! / 2.8,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 8),
            child: TextFormField(
                enabled: habilitado,
                decoration: InputDecoration(
                  counterText: txtAbajo ?? "",
                  focusedBorder: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  /*enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hoverColor: Color(0xfff0f3f4),
                  fillColor: Color(0xfff0f3f4),
                  filled: true,*/
                ),
                controller: controlador,
                maxLength: (onlyDigits ?? false)
                    ? 10
                    : (year ?? false)
                        ? 4
                        : null,
                keyboardType: entrada ?? TextInputType.name,
                inputFormatters: (onlyDigits ?? false)
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : (year ?? false)
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : [FilteringTextInputFormatter.singleLineFormatter],
                obscureText: obscure == null ? false : obscure,
                validator: (requerido ?? false) == true
                    ? (value) {
                        if (value!.isEmpty) {
                          return "Campo requerido";
                          /*Translations.of(context)
                        .text("campo_requerido");*/
                        } else {
                          if (pwd ?? false) {
                            if (value.length < 6) {
                              return "Deben ser mínimo 6 caracteres";
                            }
                          }
                        }
                        return null;
                      }
                    : null),
          )
        ],
      ),
    );
  }
}
