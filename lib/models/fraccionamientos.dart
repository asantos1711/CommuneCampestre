import 'package:flutter/material.dart';

class Fraccionamiento {
  String? nombre;
  String? urlLogopngColor;
  String? urlLogopngBlanco;
  String? urlLogojpg;
  ColorF? color;
  String? id;
  String? keyStripe;
  String? urlApi;
  bool? pagar;
  bool? amenidades;
  bool? reportes;
  String? idRestaurante;
  String? terminos;
  int? numCuentasAsoc;
  bool? infoFracc;
  bool? preguntasFrec;
  int? diasMantto;
  int? diasSanciones;
  int? rangoDiasVisitasReg;
  int? rangoDiasTrabReg;
  int? rangoDiasAirbnb;
  int? rangoDiasTrabPerm;
  int? rangoMesesReg;  
  int? rangoMesesTrab;
  int? rangoMesesMud;
  int? rangoMesesAirbnb;

  Fraccionamiento(
      {this.nombre,
      this.urlLogopngBlanco,
      this.urlLogopngColor,
      this.color,
      this.urlLogojpg,
      this.id,
      this.keyStripe,
      this.urlApi,
      this.idRestaurante,
      this.numCuentasAsoc,
      this.pagar,
      this.amenidades,
      this.terminos,
      this.infoFracc,
      this.preguntasFrec,
      this.diasMantto,
      this.diasSanciones,
      this.rangoDiasAirbnb,
      this.rangoDiasTrabPerm,
      this.rangoDiasTrabReg,
      this.rangoDiasVisitasReg,
      this.rangoMesesAirbnb,
      this.rangoMesesMud,
      this.rangoMesesReg,
      this.rangoMesesTrab,
      this.reportes});

  Color getColor() {
    return Color.fromARGB(255, color!.r, color!.g, color!.b);
  }

  factory Fraccionamiento.fromJson(Map<String, dynamic> json) =>
      Fraccionamiento(
        nombre: json["nombre"] == null ? null : json["nombre"],
        idRestaurante:
            json["idRestaurante"] == null ? null : json["idRestaurante"],
        id: json["id"] == null ? null : json["id"],
        urlLogopngColor:
            json["urlLogopngColor"] == null ? null : json["urlLogopngColor"],
        urlLogojpg: json["urlLogojpg"] == null ? null : json["urlLogojpg"],
        urlLogopngBlanco:
            json["urlLogopngBlanco"] == null ? null : json["urlLogopngBlanco"],
        keyStripe: json["keyStripe"] == null ? null : json["keyStripe"],
        urlApi: json["urlApi"] == null ? null : json["urlApi"],
        pagar: json["pagar"] == null ? null : json["pagar"],
        amenidades: json["amenidades"] == null ? false : json["amenidades"],
        reportes: json["reportes"] == null ? false : json["reportes"],
        infoFracc: json["infoFracc"] == null ? false : json["infoFracc"],
        diasMantto: json["diasMantto"] == null ? 0 : json["diasMantto"],
        diasSanciones: json["diasSanciones"] == null ? 0 : json["diasSanciones"],
        preguntasFrec: json["preguntasFrec"] == null ? false : json["preguntasFrec"],
        terminos: json["terminos"] == null ? null : json["terminos"],
        rangoDiasAirbnb: json["rangoDiasAirbnb"] == null ? 1 : json["rangoDiasAirbnb"],
        rangoDiasTrabPerm: json["rangoDiasTrabPerm"] == null ? 1 : json["rangoDiasTrabPerm"],
        rangoDiasTrabReg: json["rangoDiasTrabReg"] == null ? 1 : json["rangoDiasTrabReg"],
        rangoDiasVisitasReg: json["rangoDiasVisitasReg"] == null ? 1 : json["rangoDiasVisitasReg"],
        rangoMesesAirbnb: json["rangoMesesAirbnb"] == null ? 1 : json["rangoMesesAirbnb"],
        rangoMesesMud: json["rangoMesesMud"] == null ? 1 : json["rangoMesesMud"],
        rangoMesesReg: json["rangoMesesReg"] == null ? 1 : json["rangoMesesReg"],
        rangoMesesTrab: json["rangoMesesTrab"] == null ? 1 : json["rangoMesesTrab"],
        numCuentasAsoc:
            json["numCuentasAsoc"] == null ? null : json["numCuentasAsoc"],
        color: json["color"] == null ? null : ColorF.fromJson(json["color"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "idRestaurante": idRestaurante == null ? null : idRestaurante,
        "nombre": nombre == null ? null : nombre,
        "urlLogopngColor": urlLogopngColor == null ? null : urlLogopngColor,
        "urlLogopngBlanco": urlLogopngBlanco == null ? null : urlLogopngBlanco,
        "urlLogojpg": urlLogojpg == null ? null : urlLogojpg,
        "keyStripe": keyStripe == null ? null : keyStripe,
        "urlApi": urlApi == null ? null : urlApi,
        "pagar": pagar == null ? null : pagar,
        "amenidades": amenidades == null ? null : amenidades,
        "terminos": terminos == null ? false : terminos,
        "reportes": reportes == null ? false : reportes,
        "diasSanciones": diasSanciones == null ? 0 : diasSanciones,
        "diasMantto": diasMantto == null ? 0 : diasMantto,
        "numCuentasAsoc": numCuentasAsoc == null ? 0 : numCuentasAsoc,
        "color": color == null ? null : color!.toJson(),
      };
}

class ColorF {
  ColorF({
    required this.r,
    required this.g,
    required this.b,
  });

  int r;
  int g;
  int b;

  factory ColorF.fromJson(Map<String, dynamic> json) => ColorF(
        r: json["r"] == null ? null : json["r"],
        g: json["g"] == null ? null : json["g"],
        b: json["b"] == null ? null : json["b"],
      );

  Map<String, dynamic> toJson() => {
        "r": r == null ? null : r,
        "g": g == null ? null : g,
        "b": b == null ? null : b,
      };
}
