// To parse this JSON data, do
//
//     final detailEstadoCuenta = detailEstadoCuentaFromJson(jsonString);

import 'dart:convert';

DetailEstadoCuenta detailEstadoCuentaFromJson(String str) => DetailEstadoCuenta.fromJson(json.decode(str));

String detailEstadoCuentaToJson(DetailEstadoCuenta data) => json.encode(data.toJson());

class DetailEstadoCuenta {
    DetailEstadoCuenta({
        this.data,
        this.message,
        this.success,
        this.status,
    });

    List<Datum>? data;
    String? message;
    bool? success;
    int? status;

    factory DetailEstadoCuenta.fromJson(Map<String, dynamic> json) => DetailEstadoCuenta(
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"] == null ? null : json["message"],
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null ? null : message,
        "success": success == null ? null : success,
        "status": status == null ? null : status,
    };
}

class Datum {
    Datum({
        this.fechaCreado,
        this.fecha,
        this.descripcion,
        this.cargo,
        this.abono,
        this.identificador,
        this.tipo,
        this.estado,
        this.facturaId,
        this.folio,
    });

    DateTime? fechaCreado;
    DateTime? fecha;
    String? descripcion;
    int? cargo;
    int? abono;
    int? identificador;
    String? tipo;
    String? estado;
    int? facturaId;
    String? folio;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        fechaCreado: json["fechaCreado"] == null ? null : DateTime.parse(json["fechaCreado"]),
        fecha: json["fecha"] == null ? DateTime.now() : DateTime.parse(json["fecha"]),
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
        cargo: json["cargo"] == null ? null : json["cargo"],
        abono: json["abono"] == null ? null : json["abono"],
        identificador: json["identificador"] == null ? null : json["identificador"],
        tipo: json["tipo"] == null ? null : json["tipo"],
        estado: json["estado"] == null ? null : json["estado"],
        facturaId: json["facturaId"] == null ? null : json["facturaId"],
        folio: json["folio"] == null ? null : json["folio"],
    );

    Map<String, dynamic> toJson() => {
        "fechaCreado": fechaCreado == null ? null : fechaCreado,
        "fecha": fecha == null ? null : fecha,
        "descripcion": descripcion == null ? null : descripcion,
        "cargo": cargo == null ? null : cargo,
        "abono": abono == null ? null : abono,
        "identificador": identificador == null ? null : identificador,
        "tipo": tipo == null ? null : tipo,
        "estado": estado == null ? null : estado,
        "facturaId": facturaId == null ? null : facturaId,
        "folio": folio == null ? null : folio,
    };
}

