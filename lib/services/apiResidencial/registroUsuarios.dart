import 'dart:convert';

import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:campestre/models/NoticiasModel.dart';
import 'package:campestre/models/responseLote.dart';

import '../../models/modeloRegistro.dart';
import '../../models/usuarioModel.dart';
import '../jwt.dart';

import 'package:http/http.dart' as http;

import '../push_notifications_services.dart';

class RegistroUsuarioConnect {
  UsuarioBloc _usuarioBloc = new UsuarioBloc();

  Future<ResponseRegistro> mandarRegistro(Usuario usuario) async {
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    //print("Pagados*****");
    JWTProvider jwtProvider = JWTProvider();
    ResponseRegistro model = new ResponseRegistro();

    String url = urlApi + "api/v1/userapp/save";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };
    //print(url);
    PushNotificationsService service = PushNotificationsService();
    print(service.getToken());
    final body = {
      "email": usuario.email,
      "id": null,
      "lote": (usuario.lote != null) ? {"id": usuario.lote} : null,
      "name": usuario.nombre,
      "phone": usuario.telefono,
      "status": (usuario.lote != null) ? "verificada" : "pendiente",
      "token": service.getToken()
    };

    print(json.encode(body));
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        //print(decodeData);
        model = ResponseRegistro.fromJson(decodeData);
      } else {
        print("mandarRegistro service status code: ${response.body}");
      }
    } catch (e) {
      print("Error en mandarRegistro $e");
    }

    return model;
  }

  Future<bool> isAlreadyLoteUsed(String lote) async {
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    print("Lote*****  $lote");
    JWTProvider jwtProvider = JWTProvider();
    ResponseRegistro model = new ResponseRegistro();
    bool alreadyExist = false;
    String url = urlApi + "api/v1/userapp/all";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };
    //print(url);
    /*PushNotificationsService service = PushNotificationsService();
    print(service.getToken());
    final body = {
      "email": usuario.email,
      "id": null,
      "lote": (usuario.lote != null) ? {"id": usuario.lote} : null,
      "name": usuario.nombre,
      "phone": usuario.telefono,
      "status": (usuario.lote != null) ? "verificada" : "pendiente",
      "token": service.getToken()
    };*/

    // print(json.encode(body));
    final response = await http.get(Uri.parse(url), headers: headers);

    try {
      if (response.statusCode == 200) {
        final List<dynamic> decodeData =
            json.decode(utf8.decode(response.bodyBytes));
        print("LOTE del LISTa");

        for (var val in decodeData) {
          final dd = ((val) as Map);
          //print(dd["lote"]["id"]);

          String loteNow = dd["lote"]?["id"]?.toString() ?? "";
          print(loteNow);
          alreadyExist = lote == loteNow ? true : alreadyExist;
        }

        // model = ResponseRegistro.fromJson(decodeData);
      } else {
        print("isAlreadyLoteUsed service status code: ${response.body}");
      }
    } catch (e) {
      print("Error en isAlreadyLoteUsed $e");
    }

    return alreadyExist;
  }

  Future<void> actualizarToken(Usuario usuario, String status) async {
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();
    //print("Pagados*****");
    JWTProvider jwtProvider = JWTProvider();
    ResponseRegistro model = new ResponseRegistro();

    String url = urlApi + "api/v1/userapp/save";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };
    //print(url);
    PushNotificationsService service = PushNotificationsService();
    print(service.getToken());
    final body = {
      "email": usuario.email,
      "id": usuario.idRegistro,
      "lote": {"id": usuario.lote},
      "name": usuario.nombre,
      "phone": usuario.telefono,
      "status": status,
      "token": service.getToken()
    };

    //print(body);

    //print(json.encode(body));
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
        //print(decodeData);
        model = ResponseRegistro.fromJson(decodeData);
        //print(model.toJson());
      } else {
        print("actualizar token service status code: ${response.body}");
      }
    } catch (e) {
      print("Error en actualizar token $e");
    }

    return;
  }

  Future<ResponseRegistro> getRegistro(int id) async {
    //print("Mantenimientos*****");
    ResponseRegistro model = new ResponseRegistro();
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();

    JWTProvider jwtProvider = JWTProvider();
    String url = urlApi + "api/v1/userapp/get/$id";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();
    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));

        model = ResponseRegistro.fromJson(decodeData);
        //print("Datos cargados");
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print("Error getRegistro :\n$e");
    }

    return model;
  }

  Future<ResponseGetLote> getLotePadre(int id) async {
    //print("Mantenimientos*****");
    ResponseGetLote model = new ResponseGetLote();
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();

    JWTProvider jwtProvider = JWTProvider();
    String url = urlApi + "api/v1/lote/get/$id";
    String tk = await jwtProvider.getJWT();

    print(url);

    String token = "Bearer $tk"; //await _jwt.getJWT();
    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    //print(response);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));

        model = ResponseGetLote.fromJson(decodeData);
        //print("Datos cargados");
        //print(decodeData);
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print("Error getRegistro :\n$e");
    }

    return model;
  }

  Future<String> getRegistroStatus(int id) async {
    //print("Mantenimientos*****");
    String model = "";
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();

    JWTProvider jwtProvider = JWTProvider();
    String url = urlApi + "api/v1/userapp/get/$id";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();
    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    /*print("el response****");

    print(response.request);
    print(response);*/

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));

        model = ResponseRegistro.fromJson(decodeData).data!.status!;
        //print("Estatus del usuario : $model");
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print("Error getRegistro Status :\n$e");
    }

    return model;
  }

  Future<List<NewsLetterList>> getNewsLetter() async {
    //print("Mantenimientos*****");
    List<NewsLetterList> model = [];
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();

    JWTProvider jwtProvider = JWTProvider();
    String url = urlApi +
        "api/v1/newsletter/allpaginable?page=0&size=20&sortBy=createdAt";
    String tk = await jwtProvider.getJWT();

    String token = "Bearer $tk"; //await _jwt.getJWT();
    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));

        model = NewsletterModel.fromJson(decodeData).newsLetterList!;
        //print("Estatus del usuario : $model");
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print("Error getRegistro Status :\n$e");
    }

    return model;
  }
}
