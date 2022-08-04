import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../bloc/usuario_bloc.dart';
import '../../models/mantenimiento/Mantenimiento.dart';
import '../jwt.dart';

class MantenimientoProvider {
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  Future<Mantenimientos> getAllMantemientos() async {
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    //print("Mantenimientos*****");
    Mantenimientos model = new Mantenimientos();

    JWTProvider jwtProvider = JWTProvider();
    String url = urlApi + "api/v1/lote/get-for-mantenimiento/2282";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();
    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    //print(body);
    /*print("--------avilabilityHotelsAPI----------");
    print(url);
    print(token);*/

    final response = await http.get(Uri.parse(url), headers: headers);
    //print(response.body);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        /*if (decodeData["count"] == 0) {
          print("No hay hoteles disponibles");
          return model;
        }*/

        //print(decodeData);

        model = Mantenimientos.fromJson(decodeData);
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
}
