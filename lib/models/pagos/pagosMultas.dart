// To parse this JSON data, do
//
//     final pagosMultas = pagosMultasFromJson(jsonString);

import 'dart:convert';

PagosMultas pagosMultasFromJson(String str) => PagosMultas.fromJson(json.decode(str));

String pagosMultasToJson(PagosMultas data) => json.encode(data.toJson());

class PagosMultas {
    PagosMultas({
        this.id,
        this.loteTransient,
        this.multaTransient,
        this.pagado,
        this.referencia,
        this.metodoPago,
        this.caja,
        this.applyDescuento,
        this.autorizado,
        this.noCuenta,
        this.fechaPago,
    });

    String? id;
    Caja? loteTransient;
    Caja? multaTransient;
    int? pagado;
    String ? referencia;
    MetodoPago? metodoPago;
    Caja? caja;
    int? applyDescuento;
    String? autorizado;
    String? noCuenta;
    DateTime? fechaPago;

    factory PagosMultas.fromJson(Map<String, dynamic> json) => PagosMultas(
        id: json["id"] == null ? null : json["id"],
        loteTransient: json["loteTransient"] == null ? null : Caja.fromJson(json["loteTransient"]),
        multaTransient: json["multaTransient"] == null ? null : Caja.fromJson(json["multaTransient"]),
        pagado: json["pagado"] == null ? null : json["pagado"],
        referencia: json["referencia"] == null ? null : json["referencia"],
        metodoPago: json["metodoPago"] == null ? null : MetodoPago.fromJson(json["metodoPago"]),
        caja: json["caja"] == null ? null : Caja.fromJson(json["caja"]),
        applyDescuento: json["applyDescuento"] == null ? null : json["applyDescuento"],
        autorizado: json["autorizado"] == null ? null : json["autorizado"],
        noCuenta: json["noCuenta"] == null ? null : json["noCuenta"],
        fechaPago: json["fecha_pago"] == null ? null : DateTime.parse(json["fecha_pago"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "loteTransient": loteTransient == null ? null : loteTransient!.toJson(),
        "multaTransient": multaTransient == null ? null : multaTransient!.toJson(),
        "pagado": pagado == null ? null : pagado,
        "referencia": referencia == null ? null : referencia,
        "metodoPago": metodoPago == null ? null : metodoPago!.toJson(),
        "caja": caja == null ? null : caja!.toJson(),
        "applyDescuento": applyDescuento == null ? null : applyDescuento,
        "autorizado": autorizado == null ? null : autorizado,
        "noCuenta": noCuenta == null ? null : noCuenta,
        "fecha_pago": fechaPago == null ? null : "${fechaPago!.year.toString().padLeft(4, '0')}-${fechaPago!.month.toString().padLeft(2, '0')}-${fechaPago!.day.toString().padLeft(2, '0')}",
    };
}

class Caja {
    Caja({
        this.id,
    });

    int? id;

    factory Caja.fromJson(Map<String, dynamic> json) => Caja(
        id: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
    };
}

class MetodoPago {
    MetodoPago({
        this.id,
    });

    String? id;

    factory MetodoPago.fromJson(Map<String, dynamic> json) => MetodoPago(
        id: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
    };
}
