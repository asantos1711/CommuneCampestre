import 'package:flutter/material.dart';

import '../bloc/usuario_bloc.dart';
import '../widgets/textfielborder.dart';
import 'confirmacionVisita.dart';

class AccesoVisitas extends StatefulWidget {
  //const AccesoVisitas({ Key? key }) : super(key: key);

  @override
  State<AccesoVisitas> createState() => _AccesoVisitasState();
}

class _AccesoVisitasState extends State<AccesoVisitas> {
  TextEditingController _nombre = TextEditingController();
  TextEditingController _hora = TextEditingController();
  bool? _uno = false, _repeat = false;
  DateTime selectedDate = new DateTime.now();
  TextEditingController _fecha = new TextEditingController();
  TimeOfDay _fromTime = new TimeOfDay.now();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

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
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF0C0C0C),
            ),
          ),
        ),
        body: ListView(children: [
          _title(),
          Container(
            padding: EdgeInsets.only(left: 25, right: 60),
            child: TextFormFieldBorder("Nombre", _nombre,
                TextInputType.emailAddress, false, Colors.white),
          ),
          _subtitle(),
          Container(
              margin: EdgeInsets.only(left: 35),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Color.fromARGB(
                        255,
                        _usuarioBloc.miFraccionamiento.color!.r,
                        _usuarioBloc.miFraccionamiento.color!.g,
                        _usuarioBloc.miFraccionamiento.color!.b),
                    value: _uno,
                    onChanged: (bool? value) {
                      setState(() {
                        _uno = value;
                        _repeat = false;
                      });
                    },
                  ),
                  Container(
                      child: Text("Una sola ocasión",
                          style: TextStyle(fontSize: 17, color: Colors.black)))
                ],
              )),
          Container(
              margin: EdgeInsets.only(left: 35),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Color.fromARGB(
                        255,
                        _usuarioBloc.miFraccionamiento.color!.r,
                        _usuarioBloc.miFraccionamiento.color!.g,
                        _usuarioBloc.miFraccionamiento.color!.b),
                    value: _repeat,
                    onChanged: (bool? value) {
                      setState(() {
                        _repeat = value;
                        _uno = false;
                      });
                    },
                  ),
                  Container(
                      child: Text("Por tiempo indefinido",
                          style: TextStyle(fontSize: 17, color: Colors.black)))
                ],
              )),
          Visibility(
            child: Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [_fechaw(), _horaw()],
                    ),
                  ],
                )),
            visible: _uno!,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20, top: 20, right: 70, left: 70),
            child: FlatButton(
              //minWidth: 100,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmacionVistitas()),
                );
              },
              color: Color.fromARGB(
                  255,
                  _usuarioBloc.miFraccionamiento.color!.r,
                  _usuarioBloc.miFraccionamiento.color!.g,
                  _usuarioBloc.miFraccionamiento.color!.b),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Text(
                "Siguiente",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          )
        ]));
  }

  _title() {
    return Container(
        margin: EdgeInsets.only(left: 35, top: 20),
        child: Text(
          "Información visita",
          style: TextStyle(
              color: Color.fromARGB(
                  255,
                  _usuarioBloc.miFraccionamiento.color!.r,
                  _usuarioBloc.miFraccionamiento.color!.g,
                  _usuarioBloc.miFraccionamiento.color!.b),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ));
  }

  _subtitle() {
    return Container(
        margin: EdgeInsets.only(left: 35, top: 20),
        child: Text(
          "Tiempo",
          style: TextStyle(
              color: Color(0xFF414596),
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ));
  }

  _fechaw() {
    return Container(
        width: 150,
        //padding: EdgeInsets.only(left: 80, right: 80),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {
            _selectDate();
          },
          readOnly: true,
          decoration: InputDecoration(
            hoverColor: Colors.purple,
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: "Día",
            hintText: "dd/MM/yyyy",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: _fecha,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _fecha.text = selectedDate.day.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.year.toString();
      });
  }

  _horaw() {
    return Container(
      width: 150,
      //padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        //enableInteractiveSelection: false,
        onTap: () {
          _showTimePicker();
        },
        readOnly: true,
        decoration: InputDecoration(
          //prefixIcon: prefixIcon,
          filled: true,
          fillColor: Colors.white,
          labelText: "Hora",
          hintText: "hh:mm",
          enabledBorder: border(false),
          focusedBorder: border(true),
          border: border(false),
          errorText: null,
        ),
        controller: _hora,

        validator: (value) {
          if (value!.isEmpty) {
            return "Campo requerido";
          }
          return null;
        },
      ),
    );
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime,
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;

        _hora.text =
            _fromTime.hour.toString() + ":" + _fromTime.minute.toString();
      });
    }
  }
}
