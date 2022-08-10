import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/controls/connection.dart';
import 'package:campestre/models/preguntasModel.dart';
import 'package:flutter/material.dart';

class PreguntasView extends StatefulWidget {
  //const PreguntasView({ Key? key }) : super(key: key);

  @override
  State<PreguntasView> createState() => _PreguntasViewState();
}

class _PreguntasViewState extends State<PreguntasView> {
  List<PreguntasFrecuentes> _preguntasFrec = [];
  DatabaseServices _databaseServices = new DatabaseServices();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Preguntas frecuentes",
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
        body: FutureBuilder(
          future: _databaseServices.getPreguntas(),
          builder: (BuildContext context, AsyncSnapshot sn) {
            if (!sn.hasData)
              return Center(
                  child: Image.asset(
                "assets/icon/casita.gif",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ));

            _preguntasFrec = sn.data;

            return ListView.builder(
              itemCount: _preguntasFrec.length,
              itemBuilder: (context, index) {
                //return _contenido(DateFormat('dd/MM/yyyy').format(_mantenimientos.data!.mantenimientoList![index].payDate as DateTime), _mantenimientos.data!.mantenimientoList![index].status.toString().toCapitalized() , _mantenimientos.data!.mantenimientoList![index].amount.toString());

                return Container(
                  margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          _preguntasFrec[index].pregunta.toString(),
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(
                                  255,
                                  _usuarioBloc.miFraccionamiento.color!.r,
                                  _usuarioBloc.miFraccionamiento.color!.g,
                                  _usuarioBloc.miFraccionamiento.color!.b)),
                        ),
                      ),
                      Container(
                        child: Text(_preguntasFrec[index].respuesta.toString(),
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ],
                  ),
                );
              },
            );

            /*return Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _contenido("02/01/22", "Mantenimientos Enero", "820"),
                _contenido("02/02/22", "Mantenimientos febrero", "820"),
                _contenido("02/03/22", "Mantenimientos Marzo", "820"),
              ],
            ),
          );*/
          },
        ));
  }
}
