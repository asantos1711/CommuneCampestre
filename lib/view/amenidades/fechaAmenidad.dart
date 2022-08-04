import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/usuario_bloc.dart';
import '../../models/amenidades/allAmenidades.dart';
import '../../models/amenidades/horariosAmenidades.dart';
import '../../services/apiResidencial/amenidadesProvider.dart';
import '../../widgets/columnBuilder.dart';
import 'menuAmenidades.dart';

class FechaAmenidad extends StatefulWidget {
  AllAmenidades? idAmenidad;
  FechaAmenidad({required this.idAmenidad});

  @override
  State<FechaAmenidad> createState() => _FechaAmenidadState();
}

class _FechaAmenidadState extends State<FechaAmenidad> {
  DateTime hoy = new DateTime.now();
  DateTime dt = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  AmenidadesProvider _amenidadesProvider = new AmenidadesProvider();
  HorariosAmenidades _horariosAmenidades = new HorariosAmenidades();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  AllAmenidades _idAmenidad = new AllAmenidades();
  double w = 0.0, h = 0.0;
  TextEditingController _descripcion = new TextEditingController();
  int espacios = 1;

  @override
  void initState() {
    _idAmenidad = this.widget.idAmenidad as AllAmenidades;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Disponibilidad",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuAmenidades()),
                );
              },
              child: Icon(
                Icons.arrow_back,
                color: Color(0xFF0C0C0C),
              )),
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Text(
                _idAmenidad.name.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            _fechas(),
            _lista(),
          ],
        ));
  }

  _fechas() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, left: 10),
      child: FlatButton(
        onPressed: () {
          _calend();
        },
        child: Row(
          children: <Widget>[
            Text(
              "Fecha " + formatDate(dt, [d, '/', M, '/', yy]),
              style: TextStyle(color: Color(0xFF003C91), fontSize: 18),
            ),
            Icon(
              Icons.expand_more,
              color: Color(0xFF003C91),
            )
          ],
        ),
      ),
    );
  }

  _calend() async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
        maxTime: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 8),
        theme: DatePickerTheme(
            //headerColor: Colors.orange,
            backgroundColor: Colors.white,
            itemStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
            doneStyle: TextStyle(color: Colors.black, fontSize: 16)),
        /*onChanged: (date) {
        dt = date;
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
      }, */

        onConfirm: (date) {
      setState(() {
        dt = date;
      });
      print('confirm $date');
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  _lista() {
    if (_usuarioBloc.perfil.lotePadre != null ||
        _usuarioBloc.perfil.lotePadre != 0) {
      return FutureBuilder(
        future: _amenidadesProvider.getHorarios(
            formatDate(dt, [yy, '-', mm, '-', d]),
            _usuarioBloc.perfil.lote.toString(),
            _idAmenidad.id.toString()),
        builder: (BuildContext context, AsyncSnapshot sn) {
          if (!sn.hasData)
            return Center(
                child: Image.asset(
              "assets/icon/casita.gif",
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ));

          _horariosAmenidades = sn.data;

          return ColumnBuilder(
            itemCount: _horariosAmenidades.data?.length ?? 0,
            itemBuilder: (context, index) {
              //return _contenido(DateFormat('dd/MM/yyyy').format(_mantenimientos.data!.mantenimientoList![index].payDate as DateTime), _mantenimientos.data!.mantenimientoList![index].status.toString().toCapitalized() , _mantenimientos.data!.mantenimientoList![index].amount.toString());

              return Container(
                //margin: EdgeInsets.only(left:30, right: 30, top: 15),
                child: Card(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Container(
                        //margin: EdgeInsets.only(left:40, right:40),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text(_horariosAmenidades.data?[index].name ?? ""),
                                  Text(
                                    _horariosAmenidades.data?[index].horario ??
                                        "",
                                    style: TextStyle(
                                        color: _usuarioBloc.miFraccionamiento
                                            .getColor(),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text((_horariosAmenidades.data?[index].estado
                                              .toString()
                                              .contains("parcialmente") ??
                                          false)
                                      ? "Parcialmente disponible"
                                      : "Disponible"),
                                  Text("Aforo " +
                                      _horariosAmenidades
                                          .data![index].lugaresDisponibles
                                          .toString()),
                                ],
                              ),
                            ),
                            ((_horariosAmenidades.data?[index].estado
                                            .toString()
                                            .contains("parcialmente") ??
                                        false) ||
                                    (_horariosAmenidades.data?[index].estado
                                            .toString()
                                            .contains("disponible") ??
                                        false))
                                ? InkWell(
                                    onTap: () async {
                                      _alertConfirmacion(
                                          _horariosAmenidades.data?[index].id
                                                  .toString() ??
                                              "",
                                          _horariosAmenidades
                                              .data![index].lugaresDisponibles!
                                              .toInt());
                                    },
                                    child: Image.asset(
                                      "assets/images/reserve.png",
                                      width: 100,
                                      height: 50,
                                    ))
                                : SizedBox()
                          ],
                        ))),
              );
            },
          );
        },
      );
    } else {
      SizedBox();
    }
  }

  _alertConfirmacion(String id, int aforo) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // title: Container(child: Text("")), //Row(children: <Widget>[Icon(FontAwesomeIcons.checkCircle, color: Colors.green),Text("Envio éxitoso"),],),
              content: Container(
                  width: w - 170,
                  height: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text(
                            "¿Estás seguro de este reservar esta amenidad?"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      letterSpacing: 0.8,
                                      color: Color.fromARGB(
                                          255,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.r,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.g,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.b)),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: Color.fromARGB(
                                          255,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.r,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.g,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.b)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          15.0) //                 <--- border radius here
                                      ),
                                ),
                              )),
                          InkWell(
                              onTap: () async {
                                _alertDescripcion(id, aforo);
                              },
                              child: Container(
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                      255,
                                      _usuarioBloc.miFraccionamiento.color!.r,
                                      _usuarioBloc.miFraccionamiento.color!.g,
                                      _usuarioBloc.miFraccionamiento.color!.b),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          15.0) //                 <--- border radius here
                                      ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  )));
        });
  }

  _alertDescripcion(String id, int aforo) {
    List<int> _visitas = <int>[];

    for (var i = 0; i <= aforo; i++) {
      _visitas.add(i);
    }
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // title: Container(child: Text("")), //Row(children: <Widget>[Icon(FontAwesomeIcons.checkCircle, color: Colors.green),Text("Envio éxitoso"),],),
              content: Container(
                  width: w - 150,
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child:
                            Text("Ingrese el  número de espacios a reservar"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      /*Container(
                        //padding: EdgeInsets.only(left: 25, right: 60),
                        child: TextFormFieldBorder(
                            "(Comentario opcional)",
                            _descripcion,
                            TextInputType.multiline,
                            false,
                            Colors.white),
                      ),*/
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(labelText: "Espacios"),
                          isExpanded: true,
                          value: espacios,
                          items: _visitas.map((int value) {
                            return new DropdownMenuItem<int>(
                              value: value,
                              child: new Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (va) {
                            //setState(() {
                            espacios = va!.toInt();
                            //});
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      letterSpacing: 0.8,
                                      color: Color.fromARGB(
                                          255,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.r,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.g,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.b)),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: Color.fromARGB(
                                          255,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.r,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.g,
                                          _usuarioBloc
                                              .miFraccionamiento.color!.b)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          15.0) //                 <--- border radius here
                                      ),
                                ),
                              )),
                          InkWell(
                              onTap: () async {
                                await _amenidadesProvider.reservar(
                                    id, _descripcion.text, espacios, aforo);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FechaAmenidad(
                                          idAmenidad: _idAmenidad)),
                                );

                                Fluttertoast.showToast(
                                  msg: 'Se ha reservado con éxito',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.grey[800],
                                );
                              },
                              child: Container(
                                child: Text(
                                  "Guardar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                      255,
                                      _usuarioBloc.miFraccionamiento.color!.r,
                                      _usuarioBloc.miFraccionamiento.color!.g,
                                      _usuarioBloc.miFraccionamiento.color!.b),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          15.0) //                 <--- border radius here
                                      ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  )));
        });
  }
}
