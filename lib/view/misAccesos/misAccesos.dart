import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../bloc/usuario_bloc.dart';
import '../../config/logs.dart';
import '../../controls/connection.dart';
import '../../models/entradasSalidas.dart';
import '../../provider/splashProvider.dart';
import '../menuInicio.dart';
import 'package:intl/intl.dart';

class MisAccesosView extends StatefulWidget {
  const MisAccesosView({Key? key}) : super(key: key);

  @override
  State<MisAccesosView> createState() => _MisAccesosViewState();
}

class _MisAccesosViewState extends State<MisAccesosView> {
  DatabaseServices db = new DatabaseServices();
  DateTime fechaLlegada = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day - 4); //DateTime.now();
  DateTime fechaDia = DateTime.now();
  DateTime fechaSalida = DateTime.now(); //.add(Duration(days: ));
  double? w, h;
  TextEditingController _fechaLlegada = new TextEditingController();
  TextEditingController _fechaSalida = new TextEditingController();
  UsuarioBloc usuarioBloc = new UsuarioBloc();
  List<EntradasSalidas> _listaEntradas = [];

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Mis accesos",
          style: TextStyle(
              fontSize: 20,
              color: Color(0xFF06323D),
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.push(
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
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(left: 40, right: 20, top: 20, bottom: 10),
            child: Text(
              "Ingrese las fechas de consulta",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.spaceAround,
              children: [
                _fechaw(_fechaLlegada, "Dia de inicio"),
                _fechaw(_fechaSalida, "Día final"),
              ],
            ),
          ),
          _consultar(),
          //_todos(),
          _listaEntradas != [] ? _mostrarRegistros() : SizedBox(),
        ]),
      ),
    );
  }

  _consultar() {
    return Container(
      width: w,
      margin: EdgeInsets.only(right: 20, top: 30),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () async {
          Provider.of<LoadingProvider>(context, listen: false).setLoad(true);
          try {
            _listaEntradas =
                await db.getListEntradas(fechaLlegada, fechaSalida);
            logSuccess(_listaEntradas.toList());
          } catch (e) {
            logError("Error");
          }
          Provider.of<LoadingProvider>(context, listen: false).setLoad(false);

          setState(() {});
        },
        child: Container(
            width: 150,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: usuarioBloc.miFraccionamiento.getColor(),
              borderRadius: BorderRadius.all(Radius.circular(
                      25.0) //                 <--- border radius here
                  ),
            ),
            child: Text(
              "Consultar",
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
            //Icon(FontAwesomeIcons.plus, color: Colors.white,),
            ),
      ),
    );
  }

  _mostrarRegistros() {
    List<Widget> _list = [];
    _listaEntradas.forEach((element) {
      _list.add(
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Card(
            child: ExpansionTile(
              title: Container(
                padding: EdgeInsets.only(
                  top: 20,
                ),
                child: Text(element.nombre.toString()),
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.centerLeft,
              collapsedIconColor: Colors.white,
              childrenPadding: EdgeInsets.only(left: 30),
              children: [
                Text("Fecha y hora de acceso: " +
                    element.fechaHoraAcceso.toString()),
                Text("Placas: " + element.placas.toString()),
                Text("Motivo: " + element.motivo.toString()),
                Text(element.tipo.toString()),
                Text("Tipo de visita: " + element.tipoVisita.toString()),
                //_foto(element.idUrl.toString(), "Foto de identificación"),
                element.idUrl != null
                    ? _foto(element.idUrl.toString(), "Foto de identificación")
                    : SizedBox(),
                element.placasUrl != null
                    ? _foto(element.placasUrl.toString(), "Foto de placas")
                    : SizedBox()
              ],
            ),
          ),
        ),
      );
    });

    return Column(
      children: _list,
    );
  }

  _fechaw(TextEditingController fecha, String text) {
    return Container(
        //width: 150,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          //enableInteractiveSelection: false,
          onTap: () {
            _showRangoFechas(context);
            //_selectDate();
          },
          readOnly: true,
          decoration: InputDecoration(
            hoverColor: usuarioBloc.miFraccionamiento.getColor(),
            //prefixIcon: Icon(FontAwesome.calendar),
            filled: true,
            fillColor: Colors.white,
            labelText: text,
            hintText: "dd/MM/yyyy",
            enabledBorder: border(false),
            focusedBorder: border(true),
            border: border(false),
            errorText: null,
          ),
          controller: fecha,

          validator: (value) {
            if (value!.isEmpty) {
              return "Campo requerido";
            }
            return null;
          },
        ));
  }

  Future<Null> _showRangoFechas(BuildContext context) async {
    DateTimeRange initialRange =
        DateTimeRange(start: fechaLlegada, end: fechaSalida);
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      locale: const Locale("es", "MX"),
      firstDate: DateTime(
          DateTime.now().year, (DateTime.now().month), DateTime.now().day - 7),
      //lastDate: DateTime(2101),
      lastDate: DateTime.now(), //.add(Duration(days: 3)),
      /*DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day-1),*/
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.from(
              colorScheme: ColorScheme.highContrastLight(
            primary: usuarioBloc.miFraccionamiento.getColor(),
          )),
          child: child ?? SizedBox(),
        );
      },
    );

    if (picked != null) {
      int days = picked.end.difference(picked.start).inDays;
      //print(days.toString());
      /*if (days >= 0 &&
          days <=
              int.parse(usuarioBloc.miFraccionamiento.rangoDiasVisitasReg
                  .toString())) {*/
      print(picked);
      setState(() {
        fechaLlegada = picked.start;
        _fechaLlegada.text = DateFormat('dd-MM-yyyy').format(fechaLlegada);
        fechaSalida = picked.end;
        _fechaSalida.text = DateFormat('dd-MM-yyyy').format(fechaSalida);
      });
    }
  }

  _foto(String url, String txt) {
    return Container(
        margin: EdgeInsets.all(10),
        width: w! - 100,
        //height: h! / 3,
        child: Column(
          children: [
            Text(txt,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left),
            SizedBox(
              height: 20,
            ),
            url.isNotEmpty
                ? InkWell(
                    onTap: () {
                      Alert(
                        context: context,
                        desc: txt,
                        content: Container(
                          width: w! - 150,
                          height: h! / 4,
                          child: url.isNotEmpty
                              ? Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox(), //width: w!-150,
                        ),
                        buttons: [
                          DialogButton(
                            radius: BorderRadius.all(Radius.circular(25)),
                            color: usuarioBloc.miFraccionamiento.getColor(),
                            child: Text(
                              "Aceptar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: usuarioBloc.miFraccionamiento.getColor()                          
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0) //                 <--- border radius here
                        ),
                      ),
                      
                      child: Text(
                        "Ver Foto",
                        style: TextStyle(
                            color: usuarioBloc.miFraccionamiento.getColor()),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ));
  }
}

UnderlineInputBorder border(bool focus) {
  UsuarioBloc usuarioBloc = new UsuarioBloc();
  return UnderlineInputBorder(
      //borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
          color: Color.fromARGB(
              255,
              usuarioBloc.miFraccionamiento.color!.r,
              usuarioBloc.miFraccionamiento.color!.g,
              usuarioBloc.miFraccionamiento.color!.b),
          width: focus ? 2 : 1));
}
