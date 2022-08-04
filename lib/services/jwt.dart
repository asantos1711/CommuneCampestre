import 'package:http/http.dart' as http;
import 'dart:convert';

import '../bloc/usuario_bloc.dart';

class JWTProvider {
  //final String _url = "https://apimadrid.commune.com.mx/api/v1/security/login";
  UsuarioBloc _configBloc = new UsuarioBloc();

  Future<String> getJWT() async {
    //print("es aqui");
    //print("token " + _configBloc.jwt.toString());
    String token = await setJWT();
    //print("este ***" + token);
    //_configBloc.jwt;
    /*bool existToken = token!.isNotEmpty;

    if (!existToken) return await setJWT();

    bool tokenValid = await validateJWTExpiration();

    if (!tokenValid) return await setJWT();*/

    return token;
  }

  Future<String> setJWT() async {
    String urlApi = _configBloc.miFraccionamiento.urlApi.toString();
    String _url = urlApi + "api/v1/security/login";
    //print("en set");
    //final String url = _configBloc.urlAut; //"$_url/auth/login";
    String username = "apiconnect";
    String password = "apiconnect2022";
    String token = "";

    final body = {'username': username, 'password': password};
    //print("antes " + body.toString());
    try {
      //print("estamos en el try");
      final response = await http.post(Uri.parse(_url),
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'}); // make POST request
      //print(response.body);
      if (response.statusCode != 200) {
        print("Response Code: ${response.statusCode}");

        return token;
      }

      final result = json.decode(response.body);
      //print(result);
      //almacenar el jwt
      token = result["access_token"];
      //print(token);
      _configBloc.jwt = "Bearer $token";

      //almacenar el jwt expiration date
      /*DateTime now = new DateTime.now();
      Duration duration = new Duration(hours: 7, minutes: 30, seconds: 0);
      DateTime jwtExpiration = now.add(duration);
      _configBloc.jwtExpirationDate = jwtExpiration.toString();*/
    } catch (e) {
      print(
          "Is not possible get the token at this time. Unexpected error:\n$e");
      //return null;
    }

    return token;
  }

  Future<bool> validateJWTExpiration() async {
    DateTime now = new DateTime.now();
    String? expirationDate = _configBloc.jwtExpirationDate;

    if (expirationDate!.isEmpty) return false;

    try {
      DateTime jwtExpirationDate = DateTime.parse(expirationDate);

      if (now.isAfter(jwtExpirationDate)) return false;
    } catch (e) {
      print("\tNo se Logro validar el JWT. Ocurrion un error inesperado:\n$e");
      return false;
    }

    return true;
  }
}
