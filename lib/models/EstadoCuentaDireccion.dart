// To parse this JSON data, do
//
//     final estadoCuentaDireccion = estadoCuentaDireccionFromJson(jsonString);

import 'dart:convert';

import 'package:campestre/bloc/usuario_bloc.dart';

import 'package:http/http.dart' as http;
import '../services/jwt.dart';

EstadoCuentaDireccion estadoCuentaDireccionFromJson(String str) =>
    EstadoCuentaDireccion.fromJson(json.decode(str));

String estadoCuentaDireccionToJson(EstadoCuentaDireccion data) =>
    json.encode(data.toJson());

class EstadoCuentaDireccion {
  EstadoCuentaDireccion({
    this.data,
    this.message,
    this.success,
    this.status,
  });

  Data? data;
  String? message;
  bool? success;
  int? status;

  factory EstadoCuentaDireccion.fromJson(Map<String, dynamic> json) =>
      EstadoCuentaDireccion(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] == null ? null : json["message"],
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
        "message": message == null ? null : message,
        "success": success == null ? null : success,
        "status": status == null ? null : status,
      };

  static Future<EstadoCuentaDireccion> getEstadoDireccion(String loteid) async {
    UsuarioBloc _usuarioBloc = UsuarioBloc();
    EstadoCuentaDireccion model = EstadoCuentaDireccion();
    String urlApi = _usuarioBloc.miFraccionamiento.urlApi.toString();

    JWTProvider jwtProvider = JWTProvider();
    String url = urlApi + "api/v1/residente/get/estadocuenta/$loteid";
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

        model = EstadoCuentaDireccion.fromJson(decodeData);
        //print("Datos cargados");
      } else {
        print("getEstadoDireccion service status code: ${response.body}");
      }
    } catch (e) {
      print(
          "Is not possible get getEstadoDireccion at this time. Unexpected error:\n$e");
    }

    return model;
  }
}

class Data {
  Data({
    this.direccion,
    this.direccionChild,
  });

  Direccion? direccion;
  dynamic direccionChild;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        direccion: json["direccion"] == null
            ? null
            : Direccion.fromJson(json["direccion"]),
        direccionChild: json["direccion_child"],
      );

  Map<String, dynamic> toJson() => {
        "direccion": direccion == null ? null : direccion!.toJson(),
        "direccion_child": direccionChild,
      };
}

class Direccion {
  Direccion({
    this.id,
    this.name,
    this.idResidente,
    this.idLote,
    this.referencia,
    this.direccion,
    this.deuda,
    this.deudaMantenimiento,
    this.deudaSancion,
    this.tipoLote,
    this.pagaMtto,
    this.status,
    this.fechaEntrega,
    this.categoryConst,
    this.subCategoryConst,
    this.categoryHab,
    this.subCategoryHab,
    this.isRecurrente,
    this.deudaInicial,
    this.deudaExtraordinaria,
    this.deudaMoratorio,
    this.deudaInicialProyecto,
    this.deudaCuota,
    this.cantNotas,
    this.isAsociado,
    this.hasRepresentante,
  });

  dynamic id;
  String? name;
  dynamic idResidente;
  int? idLote;
  String? referencia;
  String? direccion;
  int? deuda;
  int? deudaMantenimiento;
  dynamic deudaSancion;
  String? tipoLote;
  bool? pagaMtto;
  String? status;
  DateTime? fechaEntrega;
  dynamic categoryConst;
  dynamic subCategoryConst;
  String? categoryHab;
  String? subCategoryHab;
  bool? isRecurrente;
  dynamic deudaInicial;
  dynamic deudaExtraordinaria;
  int? deudaMoratorio;
  dynamic deudaInicialProyecto;
  dynamic deudaCuota;
  dynamic cantNotas;
  dynamic isAsociado;
  bool? hasRepresentante;

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id: json["id"],
        name: json["name"] == null ? null : json["name"],
        idResidente: json["id_residente"],
        idLote: json["id_lote"] == null ? null : json["id_lote"],
        referencia: json["referencia"] == null ? null : json["referencia"],
        direccion: json["direccion"] == null ? null : json["direccion"],
        deuda: json["deuda"] == null ? null : json["deuda"],
        deudaMantenimiento: json["deuda_mantenimiento"] == null
            ? null
            : json["deuda_mantenimiento"],
        deudaSancion: json["deuda_sancion"],
        tipoLote: json["tipo_lote"] == null ? null : json["tipo_lote"],
        pagaMtto: json["paga_mtto"] == null ? null : json["paga_mtto"],
        status: json["status"] == null ? null : json["status"],
        fechaEntrega: json["fecha_entrega"] == null
            ? null
            : DateTime.parse(json["fecha_entrega"]),
        categoryConst: json["category_const"],
        subCategoryConst: json["sub_category_const"],
        categoryHab: json["category_hab"] == null ? null : json["category_hab"],
        subCategoryHab:
            json["sub_category_hab"] == null ? null : json["sub_category_hab"],
        isRecurrente:
            json["is_recurrente"] == null ? null : json["is_recurrente"],
        deudaInicial: json["deuda_inicial"],
        deudaExtraordinaria: json["deuda_extraordinaria"],
        deudaMoratorio:
            json["deuda_moratorio"] == null ? null : json["deuda_moratorio"],
        deudaInicialProyecto: json["deuda_inicial_proyecto"],
        deudaCuota: json["deuda_cuota"],
        cantNotas: json["cant_notas"],
        isAsociado: json["is_asociado"],
        hasRepresentante: json["has_representante"] == null
            ? null
            : json["has_representante"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name == null ? null : name,
        "id_residente": idResidente,
        "id_lote": idLote == null ? null : idLote,
        "referencia": referencia == null ? null : referencia,
        "direccion": direccion == null ? null : direccion,
        "deuda": deuda == null ? null : deuda,
        "deuda_mantenimiento":
            deudaMantenimiento == null ? null : deudaMantenimiento,
        "deuda_sancion": deudaSancion,
        "tipo_lote": tipoLote == null ? null : tipoLote,
        "paga_mtto": pagaMtto == null ? null : pagaMtto,
        "status": status == null ? null : status,
        "fecha_entrega": fechaEntrega == null
            ? null
            : "${fechaEntrega!.year.toString().padLeft(4, '0')}-${fechaEntrega!.month.toString().padLeft(2, '0')}-${fechaEntrega!.day.toString().padLeft(2, '0')}",
        "category_const": categoryConst,
        "sub_category_const": subCategoryConst,
        "category_hab": categoryHab == null ? null : categoryHab,
        "sub_category_hab": subCategoryHab == null ? null : subCategoryHab,
        "is_recurrente": isRecurrente == null ? null : isRecurrente,
        "deuda_inicial": deudaInicial,
        "deuda_extraordinaria": deudaExtraordinaria,
        "deuda_moratorio": deudaMoratorio == null ? null : deudaMoratorio,
        "deuda_inicial_proyecto": deudaInicialProyecto,
        "deuda_cuota": deudaCuota,
        "cant_notas": cantNotas,
        "is_asociado": isAsociado,
        "has_representante": hasRepresentante == null ? null : hasRepresentante,
      };
}
