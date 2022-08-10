import 'package:campestre/models/amenidades/allAmenidades.dart';
import 'package:campestre/models/amenidades/horariosAmenidades.dart';
import 'package:campestre/services/jwt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:campestre/bloc/usuario_bloc.dart';

class AmenidadesProvider {
   UsuarioBloc _usuarioBloc = new UsuarioBloc();


  Future<List<AllAmenidades>> getAllAmenidades() async {
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    //print("Pagados***");
    JWTProvider jwtProvider = JWTProvider();
    AllAmenidades model = new AllAmenidades();
    List<AllAmenidades> _list = [];

    String url = urlApi+"api/v1/tipoamenidad/allactivas";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    //print( json.encode(body));
    final response = await http.get(Uri.parse(url), headers: headers);

    //print(response);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        //print(decodeData);
        for (var item in decodeData) {
          model = AllAmenidades.fromJson(item);
          _list.add(model);
        }

        //print(model);
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print("Error en pagados $e");
    }
    /*if(modelPorPagar.data.toString() == "[]"){
      modelPorPagar.success = false;
    }*/

    return _list;
  }



  Future<HorariosAmenidades> getHorarios(
      String fecha, String lote, String idAmenidad) async {

    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    //print("Pagados***");
    JWTProvider jwtProvider = JWTProvider();
    HorariosAmenidades model = new HorariosAmenidades();   
    String idLotePadre = _usuarioBloc.perfil.lotePadre.toString();

    String url =
        urlApi+"api/v1/amenidadagenda/getByFechaAmenidadLote/" +
            fecha +
            "/" +
            idAmenidad +
            "/" +idLotePadre;
    String tk = await jwtProvider.getJWT();

    print(url);

    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    //print( json.encode(body));
    final response = await http.get(Uri.parse(url), headers: headers);

    //print(response);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        //print(decodeData);
        model = HorariosAmenidades.fromJson(decodeData);
        /*for (var item in decodeData) {
          model = AllAmenidades.fromJson(item);
          _list.add(model);
        }*/

        //print(model);
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print("Error en pagados $e");
    }
    /*if(modelPorPagar.data.toString() == "[]"){
      modelPorPagar.success = false;
    }*/

    return model;
  }


  Future<bool> reservar(String id, String descrip, int espacios, int aforo) async {
    //print("Pagados***");
    JWTProvider jwtProvider = JWTProvider();        
    bool respuesta = false;
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    int lote = _usuarioBloc.perfil.lote!.toInt();

    String url = urlApi+"api/v1/amenidadagenda/reservar";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    /*final body = {
      "id": id,
      "estado": "reservado",
      "estadoDescripcion": descrip
    };*/

    final body = {
      "aforoMaximo": aforo,
      "idAFAH": id,
      "lote": {"id": lote},
      "id": lote,
      "lugaresOcupados": espacios,
    };

    //print(url);
    //print( json.encode(body));
    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));

    //print(response);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        print(decodeData);        
        respuesta = true;
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print("Error en pagados $e");
    }
    /*if(modelPorPagar.data.toString() == "[]"){
      modelPorPagar.success = false;
    }*/

    return respuesta;
  }
}
