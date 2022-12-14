import 'dart:convert';

import 'package:campestre/bloc/usuario_bloc.dart';
import 'package:http/http.dart' as http;

import '../models/usuarioModel.dart';
import 'connection.dart';

class Notificaciones {
  Future<void> sendNotiToUser(
      {required String usuarioId,
      required String titulo,
      required String bodyText}) async {
    DatabaseServices databaseServices = DatabaseServices();
    Usuario? usuario = await databaseServices.getProfileResidente(usuarioId);
    if (usuario == null) {
      print("Error al mandar notificación");
      return;
    }

    print("sendNotiToUser*****");

    String url = "https://fcm.googleapis.com/fcm/send";
    String? tk =
        "AAAAuxP4iOo:APA91bHpofo-unmmtiNe8rSsHMMnt-kE59Yn0Rwt5V9FY5nDUluaC4hg6BIwjstvkcdybR6bgluMoMsdl8_yh5IoDkL4iih7EZXHm7wwfOXHI8dTnHRnirfL3fYf0j6h9bT6uPb8A-kx";
    String? toUser = usuario.tokenNoti;
    String token = "Bearer $tk"; //await _jwt.getJWT();

    final headers = {
      "Content-type": "application/json",
      "Authorization": token
    };

    final body = {
      "notification": {"title": titulo, "body": bodyText},
      "to": toUser
    };

    print(json.encode(body));
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    try {
      if (response.statusCode == 200) {
        final decodeData = json.decode(utf8.decode(response.bodyBytes));
      } else {
        print("mandarRegistro service status code: ${response.body}");
      }
    } catch (e) {
      print("Error en mandarRegistro $e");
    }

    return;
  }

  Future<void> sendNotiToSeguridad(
      {required String titulo, required String bodyText}) async {
    DatabaseServices databaseServices = DatabaseServices();
    List<Usuario>? usuarios = await databaseServices.getUsuariosAdmin();
    UsuarioBloc usuarioBloc = new UsuarioBloc();

    usuarios = usuarios
        .where((element) => (element.idFraccionamiento!
            .contains(usuarioBloc.miFraccionamiento.id.toString())))
        .toList();

    if (usuarios == null) {
      print("Error al mandar notificación");
      return;
    }

    print("sendNotiToUser*****");

    usuarios.forEach((usuario) async {
      String url = "https://fcm.googleapis.com/fcm/send";
      String? tk =
          "AAAAuxP4iOo:APA91bHpofo-unmmtiNe8rSsHMMnt-kE59Yn0Rwt5V9FY5nDUluaC4hg6BIwjstvkcdybR6bgluMoMsdl8_yh5IoDkL4iih7EZXHm7wwfOXHI8dTnHRnirfL3fYf0j6h9bT6uPb8A-kx";
      String? toUser = usuario.tokenNoti;
      String token = "Bearer $tk"; //await _jwt.getJWT();

      final headers = {
        "Content-type": "application/json",
        "Authorization": token
      };

      final body = {
        "notification": {"title": titulo, "body": bodyText},
        "to": toUser
      };

      print(json.encode(body));
      final response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(body));

      try {
        if (response.statusCode == 200) {
          final decodeData = json.decode(utf8.decode(response.bodyBytes));
        } else {
          print("mandarRegistro service status code: ${response.body}");
        }
      } catch (e) {
        print("Error en mandarRegistro $e");
      }
    });

    return;
  }
}
