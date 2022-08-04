// To parse this JSON data, do
//
//     final mantenimientos = mantenimientosFromJson(jsonString);

import 'dart:convert';

Mantenimientos mantenimientosFromJson(String str) => Mantenimientos.fromJson(json.decode(str));

String mantenimientosToJson(Mantenimientos data) => json.encode(data.toJson());

class Mantenimientos {
    Mantenimientos({
        this.data,
        this.message,
        this.success,
        this.status,
    });

    Data? data;
    String? message;
    bool? success;
    int? status;

    factory Mantenimientos.fromJson(Map<String, dynamic> json) => Mantenimientos(
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
}

class Data {
    Data({
        this.id,
        this.referencia,
        this.asociado,
        this.status,
        this.direccion,
        this.tipoLote,
        this.categoryConst,
        this.subCategoryConst,
        this.categoryHab,
        this.subCategoryHab,
        this.isRecurrente,
        this.fechaEntrega,
        this.deudaMoratoria,
        this.mantenimientoList,
    });

    int? id;
    String? referencia;
    String? asociado;
    String? status;
    String? direccion;
    String? tipoLote;
    dynamic categoryConst;
    dynamic subCategoryConst;
    String? categoryHab;
    String? subCategoryHab;
    bool? isRecurrente;
    DateTime? fechaEntrega;
    dynamic deudaMoratoria;
    List<MantenimientoList>? mantenimientoList;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        referencia: json["referencia"] == null ? null : json["referencia"],
        asociado: json["asociado"] == null ? null : json["asociado"],
        status: json["status"] == null ? null : json["status"],
        direccion: json["direccion"] == null ? null : json["direccion"],
        tipoLote: json["tipo_lote"] == null ? null : json["tipo_lote"],
        categoryConst: json["category_const"],
        subCategoryConst: json["sub_category_const"],
        categoryHab: json["category_hab"] == null ? null : json["category_hab"],
        subCategoryHab: json["sub_category_hab"] == null ? null : json["sub_category_hab"],
        isRecurrente: json["is_recurrente"] == null ? null : json["is_recurrente"],
        fechaEntrega: json["fecha_entrega"] == null ? null : DateTime.parse(json["fecha_entrega"]),
        deudaMoratoria: json["deuda_moratoria"] == null ? null : json["deuda_moratoria"],
        mantenimientoList: json["mantenimientoList"] == null ? null : List<MantenimientoList>.from(json["mantenimientoList"].map((x) => MantenimientoList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "referencia": referencia == null ? null : referencia,
        "asociado": asociado == null ? null : asociado,
        "status": status == null ? null : status,
        "direccion": direccion == null ? null : direccion,
        "tipo_lote": tipoLote == null ? null : tipoLote,
        "category_const": categoryConst,
        "sub_category_const": subCategoryConst,
        "category_hab": categoryHab == null ? null : categoryHab,
        "sub_category_hab": subCategoryHab == null ? null : subCategoryHab,
        "is_recurrente": isRecurrente == null ? null : isRecurrente,
        "fecha_entrega": fechaEntrega == null ? null : fechaEntrega,
        "deuda_moratoria": deudaMoratoria == null ? null : deudaMoratoria,
        "mantenimientoList": mantenimientoList == null ? null : List<dynamic>.from(mantenimientoList!.map((x) => x.toJson())),
    };
}

class MantenimientoList {
    MantenimientoList({
        this.id,
        this.payDate,
        this.createdDate,
        this.updatedDate,
        this.amount,
        this.status,
        this.mes,
        this.year,
        this.cobroMantenimientoList,
        this.razonCancelada,
        this.cargoInteresesMoratorios,
    });

    int? id;
    DateTime? payDate;
    DateTime? createdDate;
    DateTime? updatedDate;
    int? amount;
    String? status;
    int? mes;
    int? year;
    List<CobroMantenimientoList>? cobroMantenimientoList;
    dynamic razonCancelada;
    CargoInteresesMoratorios? cargoInteresesMoratorios;

    factory MantenimientoList.fromJson(Map<String, dynamic> json) => MantenimientoList(
        id: json["id"] == null ? null : json["id"],
        payDate: json["payDate"] == null ? null : DateTime.parse(json["payDate"]),
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        updatedDate: json["updatedDate"] == null ? null : DateTime.parse(json["updatedDate"]),
        amount: json["amount"] == null ? null : json["amount"],
        status: json["status"] == null ? null : json["status"],
        mes: json["mes"] == null ? null : json["mes"],
        year: json["year"] == null ? null : json["year"],
        cobroMantenimientoList: json["cobroMantenimientoList"] == null ? null : List<CobroMantenimientoList>.from(json["cobroMantenimientoList"].map((x) => CobroMantenimientoList.fromJson(x))),
        razonCancelada: json["razonCancelada"],
        cargoInteresesMoratorios: json["cargoInteresesMoratorios"] == null ? null : CargoInteresesMoratorios.fromJson(json["cargoInteresesMoratorios"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "payDate": payDate == null ? null : payDate,
        "createdDate": createdDate == null ? null : createdDate!.toIso8601String(),
        "updatedDate": updatedDate == null ? null : updatedDate!.toIso8601String(),
        "amount": amount == null ? null : amount,
        "status": status == null ? null : status,
        "mes": mes == null ? null : mes,
        "year": year == null ? null : year,
        "cobroMantenimientoList": cobroMantenimientoList == null ? null : List<dynamic>.from(cobroMantenimientoList!.map((x) => x.toJson())),
        "razonCancelada": razonCancelada,
        "cargoInteresesMoratorios": cargoInteresesMoratorios == null ? null : cargoInteresesMoratorios!.toJson(),
    };
}

class CargoInteresesMoratorios {
    CargoInteresesMoratorios({
        this.id,
        this.tiie,
        this.monto,
        this.montoDcto,
        this.pagado,
        this.diasAtrasados,
        this.interesMoratorio,
        this.deudaMoratoria,
        this.status,
        this.applyDescuento,
        this.autorizado,
        this.createdAt,
        this.updatedAt,
        this.pagoInteresesMoratorios,
    });

    int? id;
    Tiie? tiie;
    int? monto;
    int? montoDcto;
    int? pagado;
    int? diasAtrasados;
    double? interesMoratorio;
    int? deudaMoratoria;
    String? status;
    double? applyDescuento;
    dynamic autorizado;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<PagoInteresesMoratorio>? pagoInteresesMoratorios;

    factory CargoInteresesMoratorios.fromJson(Map<String, dynamic> json) => CargoInteresesMoratorios(
        id: json["id"] == null ? null : json["id"],
        tiie: json["tiie"] == null ? null : Tiie.fromJson(json["tiie"]),
        monto: json["monto"] == null ? null : json["monto"],
        montoDcto: json["montoDcto"] == null ? null : json["montoDcto"],
        pagado: json["pagado"] == null ? null : json["pagado"],
        diasAtrasados: json["diasAtrasados"] == null ? null : json["diasAtrasados"],
        interesMoratorio: json["interesMoratorio"] == null ? null : json["interesMoratorio"],
        deudaMoratoria: json["deudaMoratoria"] == null ? null : json["deudaMoratoria"],
        status: json["status"] == null ? null : json["status"],
        applyDescuento: json["applyDescuento"] == null ? null : json["applyDescuento"],
        autorizado: json["autorizado"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        pagoInteresesMoratorios: json["pagoInteresesMoratorios"] == null ? null : List<PagoInteresesMoratorio>.from(json["pagoInteresesMoratorios"].map((x) => PagoInteresesMoratorio.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "tiie": tiie == null ? null : tiie!.toJson(),
        "monto": monto == null ? null : monto,
        "montoDcto": montoDcto == null ? null : montoDcto,
        "pagado": pagado == null ? null : pagado,
        "diasAtrasados": diasAtrasados == null ? null : diasAtrasados,
        "interesMoratorio": interesMoratorio == null ? null : interesMoratorio,
        "deudaMoratoria": deudaMoratoria == null ? null : deudaMoratoria,
        "status": status == null ? null : status,
        "applyDescuento": applyDescuento == null ? null : applyDescuento,
        "autorizado": autorizado,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "pagoInteresesMoratorios": pagoInteresesMoratorios == null ? null : List<dynamic>.from(pagoInteresesMoratorios!.map((x) => x.toJson())),
    };
}

class PagoInteresesMoratorio {
    PagoInteresesMoratorio({
        this.id,
        this.monto,
        this.montoDcto,
        this.pagado,
        this.deudaMoratoria,
        this.pagoStatus,
        this.applyDescuento,
        this.autorizado,
        this.createdAt,
        this.updatedAt,
        this.metodoPago,
        this.caja,
        this.noCuenta,
        this.referencia,
        this.fechaPago,
        this.isFacturado,
        this.refSistemaAnterior,
    });

    int? id;
    int? monto;
    int? montoDcto;
    int? pagado;
    int? deudaMoratoria;
    String? pagoStatus;
    dynamic applyDescuento;
    String? autorizado;
    DateTime? createdAt;
    DateTime? updatedAt;
    MetodoPago? metodoPago;
    Caja? caja;
    String? noCuenta;
    String? referencia;
    DateTime? fechaPago;
    bool? isFacturado;
    dynamic refSistemaAnterior;

    factory PagoInteresesMoratorio.fromJson(Map<String, dynamic> json) => PagoInteresesMoratorio(
        id: json["id"] == null ? null : json["id"],
        monto: json["monto"],
        montoDcto: json["montoDcto"] == null ? null : json["montoDcto"],
        pagado: json["pagado"] == null ? null : json["pagado"],
        deudaMoratoria: json["deudaMoratoria"],
        pagoStatus: json["pago_status"] == null ? null :json["pago_status"],
        applyDescuento: json["applyDescuento"],
        autorizado: json["autorizado"] == null ? null : json["autorizado"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        metodoPago: json["metodoPago"] == null ? null : MetodoPago.fromJson(json["metodoPago"]),
        caja: json["caja"] == null ? null : Caja.fromJson(json["caja"]),
        noCuenta: json["noCuenta"] == null ? null : json["noCuenta"],
        referencia: json["referencia"] == null ? null : json["referencia"],
        fechaPago: json["fecha_pago"] == null ? null : DateTime.parse(json["fecha_pago"]),
        isFacturado: json["isFacturado"] == null ? null : json["isFacturado"],
        refSistemaAnterior: json["refSistemaAnterior"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "monto": monto,
        "montoDcto": montoDcto == null ? null : montoDcto,
        "pagado": pagado == null ? null : pagado,
        "deudaMoratoria": deudaMoratoria,
        "pago_status": pagoStatus == null ? null : pagoStatus,
        "applyDescuento": applyDescuento,
        "autorizado": autorizado == null ? null : autorizado,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "metodoPago": metodoPago == null ? null : metodoPago!.toJson(),
        "caja": caja == null ? null : caja!.toJson(),
        "noCuenta": noCuenta == null ? null : noCuenta,
        "referencia": referencia == null ? null : referencia,
        "fecha_pago": fechaPago == null ? null : fechaPago,
        "isFacturado": isFacturado == null ? null : isFacturado,
        "refSistemaAnterior": refSistemaAnterior,
    };
}

class Caja {
    Caja({
        this.id,
        this.name,
        this.noCuenta,
        this.noConvenio,
        this.noClabe,
        this.banco,
        this.active,
    });

    int? id;
    String? name;
    String? noCuenta;
    String? noConvenio;
    String? noClabe;
    Banco? banco;
    bool? active;

    factory Caja.fromJson(Map<String, dynamic> json) => Caja(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        noCuenta: json["noCuenta"] == null ? null : json["noCuenta"],
        noConvenio: json["noConvenio"] == null ? null : json["noConvenio"],
        noClabe: json["noCLABE"] == null ? null : json["noCLABE"],
        banco: json["banco"] == null ? null : Banco.fromJson(json["banco"]),
        active: json["active"] == null ? null : json["active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null :name,
        "noCuenta": noCuenta == null ? null : noCuenta,
        "noConvenio": noConvenio == null ? null : noConvenio,
        "noCLABE": noClabe == null ? null : noClabe,
        "banco": banco == null ? null : banco!.toJson(),
        "active": active == null ? null : active,
    };
}

class Banco {
    Banco({
        this.id,
        this.name,
    });

    int? id;
    String? name;

    factory Banco.fromJson(Map<String, dynamic> json) => Banco(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
    };
}


class MetodoPago {
    MetodoPago({
        this.id,
        this.name,
        this.formaPagoCfdi,
    });

    int? id;
    String? name;
    FormaPagoCfdi? formaPagoCfdi;

    factory MetodoPago.fromJson(Map<String, dynamic> json) => MetodoPago(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        formaPagoCfdi: json["formaPagoCFDI"] == null ? null : FormaPagoCfdi.fromJson(json["formaPagoCFDI"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "formaPagoCFDI": formaPagoCfdi == null ? null : formaPagoCfdi!.toJson(),
    };
}

class FormaPagoCfdi {
    FormaPagoCfdi({
        this.id,
        this.name,
        this.formaPago,
    });

    int? id;
    String? name;
    String? formaPago;

    factory FormaPagoCfdi.fromJson(Map<String, dynamic> json) => FormaPagoCfdi(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        formaPago: json["formaPago"] == null ? null : json["formaPago"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "formaPago": formaPago == null ? null : formaPago,
    };
}


class Tiie {
    Tiie({
        this.id,
        this.mes,
        this.year,
        this.porcentaje,
    });

    int? id;
    int? mes;
    int? year;
    double? porcentaje;

    factory Tiie.fromJson(Map<String, dynamic> json) => Tiie(
        id: json["id"] == null ? null : json["id"],
        mes: json["mes"] == null ? null : json["mes"],
        year: json["year"] == null ? null : json["year"],
        porcentaje: json["porcentaje"] == null ? null : json["porcentaje"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "mes": mes == null ? null : mes,
        "year": year == null ? null : year,
        "porcentaje": porcentaje == null ? null : porcentaje,
    };
}

class CobroMantenimientoList {
    CobroMantenimientoList({
        this.id,
        this.createdDate,
        this.updatedDate,
        this.pagoStatus,
        this.costoMtto,
        this.pagado,
        this.costoMttoDescuento,
        this.loteTransient,
        this.pagosMantenimientoList,
        this.concepto,
        this.metodoPago,
        this.referencia,
        this.fechaPago,
        this.noCuenta,
        this.isFacturado,
        this.refSistemaAnterior,
        this.caja,
    });

    int? id;
    DateTime? createdDate;
    DateTime? updatedDate;
    String? pagoStatus;
    int? costoMtto;
    int? pagado;
    int? costoMttoDescuento;
    dynamic loteTransient;
    dynamic pagosMantenimientoList;
    String? concepto;
    MetodoPago? metodoPago;
    String? referencia;
    DateTime? fechaPago;
    String? noCuenta;
    bool? isFacturado;
    dynamic refSistemaAnterior;
    Caja? caja;

    factory CobroMantenimientoList.fromJson(Map<String, dynamic> json) => CobroMantenimientoList(
        id: json["id"] == null ? null : json["id"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        updatedDate: json["updatedDate"] == null ? null : DateTime.parse(json["updatedDate"]),
        pagoStatus: json["pagoStatus"] == null ? null : json["pagoStatus"],
        costoMtto: json["costoMtto"] == null ? null : json["costoMtto"],
        pagado: json["pagado"] == null ? null : json["pagado"],
        costoMttoDescuento: json["costoMttoDescuento"] == null ? null : json["costoMttoDescuento"],
        loteTransient: json["loteTransient"],
        pagosMantenimientoList: json["pagosMantenimientoList"],
        concepto: json["concepto"] == null ? null : json["concepto"],
        metodoPago: json["metodoPago"] == null ? null : MetodoPago.fromJson(json["metodoPago"]),
        referencia: json["referencia"] == null ? null : json["referencia"],
        fechaPago: json["fechaPago"] == null ? null : DateTime.parse(json["fechaPago"]),
        noCuenta: json["noCuenta"] == null ? null : json["noCuenta"],
        isFacturado: json["isFacturado"] == null ? null : json["isFacturado"],
        refSistemaAnterior: json["refSistemaAnterior"],
        caja: json["caja"] == null ? null : Caja.fromJson(json["caja"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "createdDate": createdDate == null ? null : createdDate,
        "updatedDate": updatedDate == null ? null : updatedDate!.toIso8601String(),
        "pagoStatus": pagoStatus == null ? null : pagoStatus,
        "costoMtto": costoMtto == null ? null : costoMtto,
        "pagado": pagado == null ? null : pagado,
        "costoMttoDescuento": costoMttoDescuento == null ? null : costoMttoDescuento,
        "loteTransient": loteTransient,
        "pagosMantenimientoList": pagosMantenimientoList,
        "concepto": concepto == null ? null : concepto,
        "metodoPago": metodoPago == null ? null : metodoPago!.toJson(),
        "referencia": referencia == null ? null : referencia,
        "fechaPago": fechaPago == null ? null : fechaPago,
        "noCuenta": noCuenta == null ? null : noCuenta,
        "isFacturado": isFacturado == null ? null : isFacturado,
        "refSistemaAnterior": refSistemaAnterior,
        "caja": caja == null ? null : caja!.toJson(),
    };
}

