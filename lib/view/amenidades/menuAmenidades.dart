import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/models/amenidades/allAmenidades.dart';
import 'package:campestre/services/apiResidencial/amenidadesProvider.dart';
import 'package:campestre/view/amenidades/fechaAmenidad.dart';
import 'package:campestre/view/menuInicio.dart';
import 'package:campestre/widgets/columnBuilder.dart';
import 'package:flutter/material.dart';

import 'casaClub/qr.dart';

class MenuAmenidades extends StatefulWidget {
  const MenuAmenidades({Key? key}) : super(key: key);

  @override
  State<MenuAmenidades> createState() => _MenuAmenidadesState();
}

class _MenuAmenidadesState extends State<MenuAmenidades> {
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  AmenidadesProvider _amenidadesProvider = new AmenidadesProvider();
  List<AllAmenidades> _allAmenidades = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
            )),
        title: Text(
          "Amenidades",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            (_usuarioBloc.miFraccionamiento.idRestaurante != null &&
                    _usuarioBloc.miFraccionamiento.idRestaurante!.isNotEmpty)
                ? _restaurante()
                : SizedBox(),
            _lista(),
          ],
        ),
      ),
    );
  }

  _lista() {
    return FutureBuilder(
      future: _amenidadesProvider.getAllAmenidades(),
      builder: (BuildContext context, AsyncSnapshot sn) {
        if (!sn.hasData)
          return Center(
              child: Image.asset(
            "assets/icon/casita.gif",
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ));

        _allAmenidades = sn.data;

        return ColumnBuilder(
          itemCount: _allAmenidades.length,
          itemBuilder: (context, index) {
            //return _contenido(DateFormat('dd/MM/yyyy').format(_mantenimientos.data!.mantenimientoList![index].payDate as DateTime), _mantenimientos.data!.mantenimientoList![index].status.toString().toCapitalized() , _mantenimientos.data!.mantenimientoList![index].amount.toString());

            return Container(
              //margin: EdgeInsets.only(left:30, right: 30, top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FechaAmenidad(
                                idAmenidad: _allAmenidades[index])),
                      );
                    },
                    child: _opcion(Icons.restaurant_menu,
                        _allAmenidades[index].name.toString()),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  _restaurante() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QrRestaurant()),
        );
      },
      child: _opcion(Icons.restaurant_menu, "Casa club"),
    );
  }

  _opcion(IconData icono, String titulo) {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Column(
        children: [
          ListTile(
            /*leading: Icon(
              icono,
              color: Color.fromARGB(
                  255,
                  _usuarioBloc.miFraccionamiento.color!.r,
                  _usuarioBloc.miFraccionamiento.color!.g,
                  _usuarioBloc.miFraccionamiento.color!.b),
              size: 28,
            ),*/
            title: Text(
              titulo,
              style: TextStyle(fontSize: 18, color: Color(0xff1A1C3D)),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Color(0xff8F8F8F),
              size: 28,
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
