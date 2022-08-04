import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/restaurante/crearCuentaMovil.dart';
import '../models/restaurante/responseMenuJson.dart';

class AybServices {
  static Future<Menu> getMenuJson(String clavePosicion) async {
    //print("Pagados*****");
    Menu menu = new Menu();

    String url = "http://143.198.5.240:8080/GrailsAyBapp/JSONClass/getMenu";

    final body = {
      "hotel": 100,
      "clavePosicion": clavePosicion,
      "idioma": "es",
      "tipoHuesped": "HERE"
    };

    //print( json.encode(body));
    final response = await http.post(Uri.parse(url), body: json.encode(body));

    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> decodeData =
            json.decode(utf8.decode(response.bodyBytes));
        print(decodeData);

        menu = Menu.fromJson(decodeData);
      } else {
        print("getMenuJson service status code: ${response.body}");
        return Menu();
      }
    } on Error catch (e) {
    } catch (e) {
      print("Error en menu $e");
    }
    /*if(modelPorPagar.data.toString() == "[]"){
      modelPorPagar.success = false;
    }*/

    return menu;
  }

  static Future<Map<String, dynamic>> sendPedido(
      OrdenCompletaModel modelo) async {
    //print("Pagados*****");
    String menu = "";

    String url =
        "http://143.198.5.240:8080/GrailsAyBapp/JSONClass/creaCuentaMovil";

    final body = modelo.toJson();
    Map<String, dynamic> decodeData = Map<String, dynamic>();

    print(json.encode(body));
    final response = await http.post(Uri.parse(url), body: json.encode(body));

    try {
      if (response.statusCode == 200) {
        decodeData = json.decode(utf8.decode(response.bodyBytes));
        print(decodeData);

        //menu = decodeData["idCuenta"] ?? "";
      } else {
        print("sendPedido service status code: ${response.body}");
        return decodeData;
      }
    } on Error catch (e) {
      print("Error en menu " + e.toString());
    } catch (e) {
      print("Error en menu " + e.toString());
    }
    /*if(modelPorPagar.data.toString() == "[]"){
      modelPorPagar.success = false;
    }*/

    return decodeData;
  }

  static Future<Map<String, dynamic>> sendPedidoDomicilio(
      OrdenCompletaModel modelo) async {
    //print("Pagados*****");
    String menu = "";

    String url =
        "http://143.198.5.240:8080/GrailsAyBapp/JSONClass/creaCuentaMovil";

    final body = modelo.toJsonDelivery();
    Map<String, dynamic> decodeData = Map<String, dynamic>();

    print(json.encode(body));
    final response = await http.post(Uri.parse(url), body: json.encode(body));

    try {
      if (response.statusCode == 200) {
        decodeData = json.decode(utf8.decode(response.bodyBytes));
        print(decodeData);

        //menu = decodeData["idCuenta"] ?? "";
      } else {
        print("sendPedido service status code: ${response.body}");
        return decodeData;
      }
    } on Error catch (e) {
      print("Error en menu " + e.toString());
    } catch (e) {
      print("Error en menu $e");
    }
    /*if(modelPorPagar.data.toString() == "[]"){
      modelPorPagar.success = false;
    }*/

    return decodeData;
  }

  static Future<bool> callMesero(String codigo) async {
    //print("Pagados*****");
    Menu menu = new Menu();

    bool salida = false;

    String url =
        "http://143.198.5.240:8080/GrailsAyBapp/API/llamaMesero?clavePosicion=$codigo";

    final body = {
      "hotel": 100,
      "clavePosicion": codigo,
      "idioma": "en",
      "tipoHuesped": "HERE"
    };

    //print( json.encode(body));
    final response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> decodeData =
            json.decode(utf8.decode(response.bodyBytes));
        print(decodeData);

        menu = Menu.fromJson(decodeData);
        salida = true;
      } else {
        print("availabilityHotels service status code: ${response.body}");
      }
    } catch (e) {
      print("Error en pagados $e");
    }
    /*if(modelPorPagar.data.toString() == "[]"){
      modelPorPagar.success = false;
    }*/

    return salida;
  }
}
