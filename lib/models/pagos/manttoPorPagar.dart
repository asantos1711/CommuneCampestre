// To parse this JSON data, do
//
//     final manttoPorPagar = manttoPorPagarFromJson(jsonString);

import 'dart:convert';

ManttoPorPagar manttoPorPagarFromJson(String str) => ManttoPorPagar.fromJson(json.decode(str));

String manttoPorPagarToJson(ManttoPorPagar data) => json.encode(data.toJson());

class ManttoPorPagar {
    ManttoPorPagar({
        this.data,
        this.message,
        this.success,
        this.status,
    });

    Data? data;
    String? message;
    bool? success;
    int? status;

    factory ManttoPorPagar.fromJson(Map<String, dynamic> json) => ManttoPorPagar(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] == null ? null : json["message"],
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : data?.toJson(),
        "message": message == null ? null : message,
        "success": success == null ? null : success,
        "status": status == null ? null : status,
    };
}

class Data {
    Data({
        this.idLote,
        this.referencia,
        this.discount,
        this.asociado,
        this.fondo,
        this.mantenimientos,
        this.descuentos,
        this.cuota,
        this.diaCorte,
        this.direccion,
        this.interesesMoratoriosList,
    });

    int? idLote;
    String? referencia;
    double? discount;
    String? asociado;
    dynamic fondo;
    List<Mantenimiento>? mantenimientos;
    List<Descuento>? descuentos;
    int? cuota;
    int? diaCorte;
    Direccion? direccion;
    List<InteresesMoratoriosList>? interesesMoratoriosList;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        idLote: json["idLote"] == null ? null : json["idLote"],
        referencia: json["referencia"] == null ? null : json["referencia"],
        discount: json["discount"] == null ? null : json["discount"].toDouble(),
        asociado: json["asociado"] == null ? null : json["asociado"],
        fondo: json["fondo"],
        mantenimientos: json["mantenimientos"] == null ? null : List<Mantenimiento>.from(json["mantenimientos"].map((x) => Mantenimiento.fromJson(x))),
        descuentos: json["descuentos"] == null ? null : List<Descuento>.from(json["descuentos"].map((x) => Descuento.fromJson(x))),
        cuota: json["cuota"] == null ? null : json["cuota"],
        diaCorte: json["diaCorte"] == null ? null : json["diaCorte"],
        direccion: json["direccion"] == null ? null : Direccion.fromJson(json["direccion"]),
        interesesMoratoriosList: json["interesesMoratoriosList"] == null ? null : List<InteresesMoratoriosList>.from(json["interesesMoratoriosList"].map((x) => InteresesMoratoriosList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "idLote": idLote == null ? null : idLote,
        "referencia": referencia == null ? null : referencia,
        "discount": discount,
        "asociado": asociado == null ? null : asociado,
        "fondo": fondo,
        "mantenimientos": mantenimientos == null ? null : List<dynamic>.from(mantenimientos!.map((x) => x.toJson())),
        "descuentos": descuentos == null ? null : List<dynamic>.from(descuentos!.map((x) => x.toJson())),
        "cuota": cuota == null ? null : cuota,
        "diaCorte": diaCorte == null ? null : diaCorte,
        "direccion": direccion == null ? null : direccion?.toJson(),
        "interesesMoratoriosList": interesesMoratoriosList == null ? null : List<dynamic>.from(interesesMoratoriosList!.map((x) => x.toJson())),
    };
}

class Descuento {
    Descuento({
        this.name,
        this.description,
        this.discount,
    });

    String? name;
    String? description;
    int? discount;

    factory Descuento.fromJson(Map<String, dynamic> json) => Descuento(
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        discount: json["discount"] == null ? null : json["discount"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "discount": discount == null ? null : discount,
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
    dynamic name;
    dynamic idResidente;
    dynamic idLote;
    dynamic referencia;
    String? direccion;
    int? deuda;
    dynamic deudaMantenimiento;
    dynamic deudaSancion;
    String? tipoLote;
    bool? pagaMtto;
    dynamic status;
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
    dynamic hasRepresentante;

    factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id: json["id"],
        name: json["name"],
        idResidente: json["id_residente"],
        idLote: json["id_lote"],
        referencia: json["referencia"],
        direccion: json["direccion"] == null ? null : json["direccion"],
        deuda: json["deuda"] == null ? null : json["deuda"],
        deudaMantenimiento: json["deuda_mantenimiento"],
        deudaSancion: json["deuda_sancion"],
        tipoLote: json["tipo_lote"] == null ? null : json["tipo_lote"],
        pagaMtto: json["paga_mtto"] == null ? null : json["paga_mtto"],
        status: json["status"],
        fechaEntrega: json["fecha_entrega"] == null ? null : DateTime.parse(json["fecha_entrega"]),
        categoryConst: json["category_const"],
        subCategoryConst: json["sub_category_const"],
        categoryHab: json["category_hab"] == null ? null : json["category_hab"],
        subCategoryHab: json["sub_category_hab"] == null ? null : json["sub_category_hab"],
        isRecurrente: json["is_recurrente"] == null ? null : json["is_recurrente"],
        deudaInicial: json["deuda_inicial"],
        deudaExtraordinaria: json["deuda_extraordinaria"],
        deudaMoratorio: json["deuda_moratorio"] == null ? null : json["deuda_moratorio"],
        deudaInicialProyecto: json["deuda_inicial_proyecto"],
        deudaCuota: json["deuda_cuota"],
        cantNotas: json["cant_notas"],
        isAsociado: json["is_asociado"],
        hasRepresentante: json["has_representante"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "id_residente": idResidente,
        "id_lote": idLote,
        "referencia": referencia,
        "direccion": direccion == null ? null : direccion,
        "deuda": deuda == null ? null : deuda,
        "deuda_mantenimiento": deudaMantenimiento,
        "deuda_sancion": deudaSancion,
        "tipo_lote": tipoLote == null ? null : tipoLote,
        "paga_mtto": pagaMtto == null ? null : pagaMtto,
        "status": status,
        "fecha_entrega": fechaEntrega == null ? null : fechaEntrega,
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
        "has_representante": hasRepresentante,
    };
}

class InteresesMoratoriosList {
    InteresesMoratoriosList({
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
        this.fechaCorte,
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
    String? fechaCorte;

    factory InteresesMoratoriosList.fromJson(Map<String, dynamic> json) => InteresesMoratoriosList(
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
        fechaCorte: json["fechaCorte"] == null ? null : json["fechaCorte"],//DateTime.parse(json["fechaCorte"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "tiie": tiie == null ? null : tiie?.toJson(),
        "monto": monto == null ? null : monto,
        "montoDcto": montoDcto == null ? null : montoDcto,
        "pagado": pagado == null ? null : pagado,
        "diasAtrasados": diasAtrasados == null ? null : diasAtrasados,
        "interesMoratorio": interesMoratorio == null ? null : interesMoratorio,
        "deudaMoratoria": deudaMoratoria == null ? null : deudaMoratoria,
        "status": status == null ? null : status,
        "applyDescuento": applyDescuento == null ? null : applyDescuento,
        "autorizado": autorizado,
        "fechaCorte": fechaCorte == null ? null : fechaCorte,
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
        porcentaje: json["porcentaje"] == null ? null : json["porcentaje"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "mes": mes == null ? null : mes,
        "year": year == null ? null : year,
        "porcentaje": porcentaje == null ? null : porcentaje,
    };
}

class Mantenimiento {
    Mantenimiento({
        this.id,
        this.mes,
        this.year,
        this.fechaCorte,
        this.total,
        this.cobroMantenimientoList,
        this.deudaMoratoria,
        this.descuentoReglas,
    });

    int? id;
    int? mes;
    int? year;
    DateTime? fechaCorte;
    int? total;
    List<dynamic>? cobroMantenimientoList;
    int? deudaMoratoria;
    int? descuentoReglas;

    factory Mantenimiento.fromJson(Map<String, dynamic> json) => Mantenimiento(
        id: json["id"] == null ? null : json["id"],
        mes: json["mes"] == null ? null : json["mes"],
        year: json["year"] == null ? null : json["year"],
        fechaCorte: json["fechaCorte"] == null ? null : DateTime.parse(json["fechaCorte"]),
        total: json["total"] == null ? null : json["total"],
        cobroMantenimientoList: json["cobroMantenimientoList"] == null ? null : List<dynamic>.from(json["cobroMantenimientoList"].map((x) => x)),
        deudaMoratoria: json["deuda_moratoria"] == null ? null : json["deuda_moratoria"],
        descuentoReglas: json["descuentoReglas"] == null ? null : json["descuentoReglas"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "mes": mes == null ? null : mes,
        "year": year == null ? null : year,
        "fechaCorte": fechaCorte == null ? null : fechaCorte,
        "total": total == null ? null : total,
        "cobroMantenimientoList": cobroMantenimientoList == null ? null : List<dynamic>.from(cobroMantenimientoList!.map((x) => x)),
        "deuda_moratoria": deudaMoratoria == null ? null : deudaMoratoria,
        "descuentoReglas": descuentoReglas == null ? null : descuentoReglas,
    };
}
