// To parse this JSON data, do
//
//     final ordenCompletaModel = ordenCompletaModelFromJson(jsonString);

import 'dart:convert';

import 'platillosPedidos.dart';

OrdenCompletaModel ordenCompletaModelFromJson(String str) =>
    OrdenCompletaModel.fromJson(json.decode(str));

String ordenCompletaModelToJson(OrdenCompletaModel data) =>
    json.encode(data.toJson());

class OrdenCompletaModel {
  OrdenCompletaModel({
    this.tipoMovil,
    this.articulos,
    this.nombreHuesped,
    this.menores,
    this.adultos,
    this.planAlimentos,
    this.idioma,
    this.clavePosicion,
    this.hotel,
    this.tipoHuesped,
    this.direccion,
    this.telefono,
  });

  String? tipoMovil;
  List<PlatillosPedidos>? articulos;
  String? nombreHuesped;
  String? menores;
  String? adultos;
  String? planAlimentos;
  String? idioma;
  String? clavePosicion;
  String? hotel;
  String? tipoHuesped;
  String? direccion;
  String? telefono;

  factory OrdenCompletaModel.fromJson(Map<String, dynamic> json) =>
      OrdenCompletaModel(
        tipoMovil: json["tipoMovil"] == null ? null : json["tipoMovil"],
        articulos: json["articulos"] == null
            ? null
            : List<PlatillosPedidos>.from(
                json["articulos"].map((x) => PlatillosPedidos.fromJson(x))),
        nombreHuesped:
            json["nombreHuesped"] == null ? null : json["nombreHuesped"],
        menores: json["menores"] == null ? null : json["menores"],
        adultos: json["adultos"] == null ? null : json["adultos"],
        planAlimentos:
            json["planAlimentos"] == null ? null : json["planAlimentos"],
        idioma: json["idioma"] == null ? null : json["idioma"],
        clavePosicion:
            json["clavePosicion"] == null ? null : json["clavePosicion"],
        hotel: json["hotel"] == null ? null : json["hotel"],
        tipoHuesped: json["tipoHuesped"] == null ? null : json["tipoHuesped"],
        direccion: json["direccion"] == null ? null : json["direccion"],
        telefono: json["telefono"] == null ? null : json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "tipoMovil": tipoMovil == null ? null : tipoMovil,
        "articulos": articulos == null
            ? null
            : List<dynamic>.from(articulos!.map((x) => x.toJson())),
        "nombreHuesped": nombreHuesped == null ? null : nombreHuesped,
        "menores": menores == null ? null : menores,
        "adultos": adultos == null ? null : adultos,
        "planAlimentos": planAlimentos == null ? null : planAlimentos,
        "idioma": idioma == null ? null : idioma,
        "clavePosicion": clavePosicion == null ? null : clavePosicion,
        "hotel": hotel == null ? null : hotel,
        "tipoHuesped": tipoHuesped == null ? null : tipoHuesped,
        // "direccion": direccion == null ? null : direccion,
        //"telefono": telefono == null ? null : telefono,
      };

  Map<String, dynamic> toJsonDelivery() => {
        "tipoMovil": tipoMovil == null ? null : tipoMovil,
        "articulos": articulos == null
            ? null
            : List<dynamic>.from(articulos!.map((x) => x.toJson())),
        "nombreHuesped": nombreHuesped == null ? null : nombreHuesped,
        "menores": menores == null ? null : menores,
        "adultos": adultos == null ? null : adultos,
        "planAlimentos": planAlimentos == null ? null : planAlimentos,
        "idioma": idioma == null ? null : idioma,
        "clavePosicion": clavePosicion == null ? null : clavePosicion,
        "hotel": hotel == null ? null : hotel,
        "tipoHuesped": tipoHuesped == null ? null : tipoHuesped,
        "direccion": direccion == null ? null : direccion,
        "telefono": telefono == null ? null : telefono,
      };
}
