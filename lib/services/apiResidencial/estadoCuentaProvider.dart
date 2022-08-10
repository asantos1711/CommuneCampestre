import 'dart:convert';

import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/models/estadoCuenta/detailEstadoCuenta.dart';
import 'package:campestre/services/jwt.dart';
import 'package:http/http.dart' as http;

class EstadoCuentaProvider {
  final _jwt = new JWTProvider();
  UsuarioBloc _usuarioBloc = new UsuarioBloc();
  

  Future<DetailEstadoCuenta> getDetail() async {
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    //print("EstadoCuenta*****");
    JWTProvider jwtProvider = JWTProvider();
    DetailEstadoCuenta model = new DetailEstadoCuenta();
    String url =urlApi+"api/v1/residente/get/estadocuenta/detail";
    String tk = await jwtProvider.getJWT();
    int deuda = 0;
    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final body = {
      "fechaInicial": "2021-01-01",
      "fechaFinal": "2022-12-31 23:59:59",
      "id": _usuarioBloc.perfil.lote,
      "variante": 0,
      "email": false
    };

    /*print(body);
    print("--------avilabilityHotelsAPI----------");
    print(url);
    print(token);*/

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
    //print(response.body);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        /*if (decodeData["count"] == 0) {
          print("No hay hoteles disponibles");
          return model;
        }*/

        //print(decodeData);

        model = DetailEstadoCuenta.fromJson(decodeData);

        if(model.data != null){
          model.data?.forEach((element) {            
            if(element.estado != "pagado" &&  element.tipo!.contains("mantenimiento")){
              deuda++;
              //print(deuda);
            }
           }
          );
          if(deuda > 2){
            _usuarioBloc.deudor = true;
          }
        }
        
        //print("Datos cargados");
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Is not possible get availablility hotels at this time. Unexpected error:\n$e");
    }

    return model;
  }


  Future<DetailEstadoCuenta> getDetailPagados() async {
    //print("Pagados*****");
    JWTProvider jwtProvider = JWTProvider();
    DetailEstadoCuenta model = new DetailEstadoCuenta();
    DetailEstadoCuenta modelPagados = new DetailEstadoCuenta();
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();

    String url = urlApi+"api/v1/residente/get/estadocuenta/detail";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final body = {
      "fechaInicial": "2021-01-01",
      "fechaFinal": "2022-12-31 23:59:59",
      "id": _usuarioBloc.perfil.lote,
      "variante": 0,
      "email": false
    };


    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
    //print(response.body);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));

        model = DetailEstadoCuenta.fromJson(decodeData);
        modelPagados.success = true;
        modelPagados.message = "ok";
        modelPagados.data = <Datum>[];

        if(model.data != null){
          model.data?.forEach((element) {
            if(element.estado!.contains("pagado")){
              modelPagados.data?.add(element);
            }}
          );
        }
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Error en pagados $e");
    }

    return modelPagados;
  }

  Future<DetailEstadoCuenta> getDetailPorPagar() async {
    //print("Pagados*****");
    JWTProvider jwtProvider = JWTProvider();
    DetailEstadoCuenta model = new DetailEstadoCuenta();
    DetailEstadoCuenta modelPorPagar = new DetailEstadoCuenta();
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    String url = urlApi+"api/v1/residente/get/estadocuenta/detail";
    String tk = await jwtProvider.getJWT();
    String token = "Bearer $tk"; //await _jwt.getJWT();
    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };
    final body = {
      "fechaInicial": "2021-01-01",
      "fechaFinal": "2022-12-31 23:59:59",
      "id": _usuarioBloc.perfil.lote,
      "variante": 0,
      "email": false
    };

    
    //print( json.encode(body));
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));


    print(response.request);
    
    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));

        model = DetailEstadoCuenta.fromJson(decodeData);
        modelPorPagar.success = true;
        modelPorPagar.message = "ok";
        modelPorPagar.data = <Datum>[];

        //print(model);

        if(model.data != null){
          model.data?.forEach((element) {
            if(!element.estado!.contains("pagado")  && !element.estado!.contains("cancelado") ){
              modelPorPagar.data?.add(element);
            }}
          );
        }else{
          modelPorPagar.success = false;
        }
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Error en pagados $e");
    }
    /*if(modelPorPagar.data.toString() == "[]"){
      modelPorPagar.success = false;
    }*/

    return modelPorPagar;
  }
}
