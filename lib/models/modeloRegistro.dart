// To parse this JSON data, do
//
//     final responseRegistro = responseRegistroFromJson(jsonString? );

import 'dart:convert';

ResponseRegistro responseRegistroFromJson(String? str) =>
    ResponseRegistro.fromJson(json.decode(str!));

String? responseRegistroToJson(ResponseRegistro data) =>
    json.encode(data.toJson());

class ResponseRegistro {
  ResponseRegistro({
    this.data,
    this.message,
    this.success,
    this.status,
  });

  Data? data;
  String? message;
  bool? success;
  int? status;

  factory ResponseRegistro.fromJson(Map<String, dynamic> json) =>
      ResponseRegistro(
        data: Data.fromJsonRegistro(json["data"]),
        message: json["message"],
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "message": message,
        "success": success,
        "status": status,
      };
}

class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.status,
    this.createdAt,
    this.lote,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  String? status;
  DateTime? createdAt;
  Lote? lote;

  factory Data.fromJsonRegistro(Map<String, dynamic> json) => Data(
        id: json["id"] ?? null,
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        status: json["status"],
        createdAt: DateTime?.parse(json["createdAt"]),
        lote: json["lote"] == null ? null : Lote.fromJsonRegistro(json["lote"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "lote": lote?.toJson(),
      };
}

class Lote {
  Lote({
    this.id,
    this.referencia,
    this.numeroViviendas,
    this.calle,
    this.manzana,
    this.lote,
    this.etapa,
    this.superficie,
    this.tipo,
    this.status,
    this.category,
    this.subestado,
    this.categoryHab,
    this.subCategoryHab,
    this.fechaEntrega,
    this.childrenLotes,
    this.latitud,
    this.longitud,
    this.mantenimiento,
    this.plusPercentMtto,
    this.residenteLoteList,
    this.vehiculoList,
    this.datosFiscales,
    this.isRecurrente,
    this.moratorios,
    this.fondo,
    this.lotesFusionados,
  });

  int? id;
  String? referencia;
  int? numeroViviendas;
  String? calle;
  String? manzana;
  String? lote;
  String? etapa;
  double? superficie;
  String? tipo;
  String? status;
  dynamic category;
  dynamic subestado;
  String? categoryHab;
  String? subCategoryHab;
  DateTime? fechaEntrega;
  List<dynamic>? childrenLotes;
  String? latitud;
  String? longitud;
  Mantenimiento? mantenimiento;
  dynamic plusPercentMtto;
  List<ResidenteLoteList>? residenteLoteList;
  List<dynamic>? vehiculoList;
  DatosFiscales? datosFiscales;
  bool? isRecurrente;
  List<dynamic>? moratorios;
  dynamic fondo;
  List<dynamic>? lotesFusionados;

  factory Lote.fromJsonRegistro(Map<String, dynamic> json) => Lote(
        id: json["id"] == null ? null : json["id"],
      );
  factory Lote.fromJson(Map<String, dynamic> json) => Lote(
        id: json["id"] == null ? null : json["id"],
        referencia: json["referencia"],
        numeroViviendas: json["numeroViviendas"],
        calle: json["calle"],
        manzana: json["manzana"],
        lote: json["lote"],
        etapa: json["etapa"],
        superficie: json["superficie"],
        tipo: json["tipo"],
        status: json["status"],
        category: json["category"],
        subestado: json["subestado"],
        categoryHab: json["categoryHab"],
        subCategoryHab: json["subCategoryHab"],
        fechaEntrega: DateTime.parse(json["fechaEntrega"]),
        childrenLotes: json["childrenLotes"] == null
            ? null
            : List<dynamic>.from(json["childrenLotes"].map((x) => x)),
        latitud: json["latitud"],
        longitud: json["longitud"],
        mantenimiento: json["mantenimiento"] == null
            ? null
            : Mantenimiento.fromJson(json["mantenimiento"]),
        plusPercentMtto: json["plusPercentMtto"],
        residenteLoteList: json["residenteList"] == null
            ? null
            : List<ResidenteLoteList>.from(json["residenteLoteList"]
                .map((x) => ResidenteLoteList.fromJson(x))),
        vehiculoList: json["vehiculoList"] == null
            ? null
            : List<dynamic>.from(json["vehiculoList"].map((x) => x)),
        datosFiscales: json["datosFiscales"] == null
            ? null
            : DatosFiscales.fromJson(json["datosFiscales"]),
        isRecurrente: json["isRecurrente"],
        moratorios: json["moratorios"] == null
            ? null
            : List<dynamic>.from(json["moratorios"].map((x) => x)),
        fondo: json["fondo"],
        lotesFusionados: json["lotesFusionados"] == null
            ? null
            : List<dynamic>.from(json["lotesFusionados"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referencia": referencia,
        "numeroViviendas": numeroViviendas,
        "calle": calle,
        "manzana": manzana,
        "lote": lote,
        "etapa": etapa,
        "superficie": superficie,
        "tipo": tipo,
        "status": status,
        "category": category,
        "subestado": subestado,
        "categoryHab": categoryHab,
        "subCategoryHab": subCategoryHab,
        "fechaEntrega":
            "${fechaEntrega?.year.toString().padLeft(4, '0')}-${fechaEntrega?.month.toString().padLeft(2, '0')}-${fechaEntrega?.day.toString().padLeft(2, '0')}",
        "childrenLotes": childrenLotes == null
            ? null
            : List<dynamic>.from(childrenLotes!.map((x) => x)),
        "latitud": latitud,
        "longitud": longitud,
        "mantenimiento": mantenimiento?.toJson(),
        "plusPercentMtto": plusPercentMtto,
        "residenteLoteList": residenteLoteList == null
            ? null
            : List<dynamic>.from(residenteLoteList!.map((x) => x.toJson())),
        "vehiculoList": vehiculoList == null
            ? null
            : List<dynamic>.from(vehiculoList!.map((x) => x)),
        "datosFiscales": datosFiscales?.toJson(),
        "isRecurrente": isRecurrente,
        "moratorios": moratorios == null
            ? null
            : List<dynamic>.from(moratorios!.map((x) => x)),
        "fondo": fondo,
        "lotesFusionados": lotesFusionados == null
            ? null
            : List<dynamic>.from(lotesFusionados!.map((x) => x)),
      };
}

class DatosFiscales {
  DatosFiscales({
    this.id,
    this.razonSocial,
    this.rfc,
    this.poblacion,
    this.cuenta,
    this.domicilio,
    this.numeroExterior,
    this.colonia,
    this.ciudad,
    this.municipio,
    this.estado,
    this.pais,
    this.codigoPostal,
    this.email,
    this.loteTransient,
    this.metodoPagoCfdi,
    this.formaPagoCfdi,
    this.usoCfdi,
    this.tipoDocumento,
    this.claveUnidadCfdi,
    this.claveProductoServicio,
    this.metodoPago,
    this.tarjeta,
  });

  int? id;
  String? razonSocial;
  String? rfc;
  String? poblacion;
  String? cuenta;
  String? domicilio;
  String? numeroExterior;
  String? colonia;
  String? ciudad;
  String? municipio;
  String? estado;
  String? pais;
  String? codigoPostal;
  String? email;
  dynamic loteTransient;
  MetodoPagoCfdi? metodoPagoCfdi;
  FormaPagoCfdi? formaPagoCfdi;
  UsoCfdi? usoCfdi;
  TipoDocumento? tipoDocumento;
  ClaveUnidadCfdi? claveUnidadCfdi;
  ClaveProductoServicio? claveProductoServicio;
  MetodoPago? metodoPago;
  Tarjeta? tarjeta;

  factory DatosFiscales.fromJson(Map<String, dynamic> json) => DatosFiscales(
        id: json["id"],
        razonSocial: json["razonSocial"],
        rfc: json["rfc"],
        poblacion: json["poblacion"],
        cuenta: json["cuenta"],
        domicilio: json["domicilio"],
        numeroExterior: json["numeroExterior"],
        colonia: json["colonia"],
        ciudad: json["ciudad"],
        municipio: json["municipio"],
        estado: json["estado"],
        pais: json["pais"],
        codigoPostal: json["codigoPostal"],
        email: json["email"],
        loteTransient: json["loteTransient"],
        metodoPagoCfdi: json["metodoPagoCFDI"] == null
            ? null
            : MetodoPagoCfdi.fromJson(json["metodoPagoCFDI"]),
        formaPagoCfdi: json["formaPagoCFDI"] == null
            ? null
            : FormaPagoCfdi.fromJson(json["formaPagoCFDI"]),
        usoCfdi:
            json["usoCFDI"] == null ? null : UsoCfdi.fromJson(json["usoCFDI"]),
        tipoDocumento: json["tipoDocumento"] == null
            ? null
            : TipoDocumento.fromJson(json["tipoDocumento"]),
        claveUnidadCfdi: json["claveUnidadCFDI"] == null
            ? null
            : ClaveUnidadCfdi.fromJson(json["claveUnidadCFDI"]),
        claveProductoServicio: json["claveProductoServicio"] == null
            ? null
            : ClaveProductoServicio.fromJson(json["claveProductoServicio"]),
        metodoPago: json["metodoPago"] == null
            ? null
            : MetodoPago.fromJson(json["metodoPago"]),
        tarjeta:
            json["tarjeta"] == null ? null : Tarjeta.fromJson(json["tarjeta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "razonSocial": razonSocial,
        "rfc": rfc,
        "poblacion": poblacion,
        "cuenta": cuenta,
        "domicilio": domicilio,
        "numeroExterior": numeroExterior,
        "colonia": colonia,
        "ciudad": ciudad,
        "municipio": municipio,
        "estado": estado,
        "pais": pais,
        "codigoPostal": codigoPostal,
        "email": email,
        "loteTransient": loteTransient,
        "metodoPagoCFDI": metodoPagoCfdi?.toJson(),
        "formaPagoCFDI": formaPagoCfdi?.toJson(),
        "usoCFDI": usoCfdi?.toJson(),
        "tipoDocumento": tipoDocumento?.toJson(),
        "claveUnidadCFDI": claveUnidadCfdi?.toJson(),
        "claveProductoServicio": claveProductoServicio?.toJson(),
        "metodoPago": metodoPago?.toJson(),
        "tarjeta": tarjeta?.toJson(),
      };
}

class ClaveProductoServicio {
  ClaveProductoServicio({
    this.id,
    this.claveProduccionServicio,
    this.name,
  });

  int? id;
  String? claveProduccionServicio;
  String? name;

  factory ClaveProductoServicio.fromJson(Map<String, dynamic> json) =>
      ClaveProductoServicio(
        id: json["id"],
        claveProduccionServicio: json["claveProduccionServicio"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "claveProduccionServicio": claveProduccionServicio,
        "name": name,
      };
}

class ClaveUnidadCfdi {
  ClaveUnidadCfdi({
    this.id,
    this.claveUnidad,
    this.name,
  });

  int? id;
  String? claveUnidad;
  String? name;

  factory ClaveUnidadCfdi.fromJson(Map<String, dynamic> json) =>
      ClaveUnidadCfdi(
        id: json["id"],
        claveUnidad: json["claveUnidad"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "claveUnidad": claveUnidad,
        "name": name,
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
        id: json["id"],
        name: json["name"],
        formaPago: json["formaPago"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "formaPago": formaPago,
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
        id: json["id"],
        name: json["name"],
        formaPagoCfdi: FormaPagoCfdi.fromJson(json["formaPagoCFDI"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "formaPagoCFDI": formaPagoCfdi?.toJson(),
      };
}

class MetodoPagoCfdi {
  MetodoPagoCfdi({
    this.id,
    this.name,
    this.metodoPago,
  });

  int? id;
  String? name;
  String? metodoPago;

  factory MetodoPagoCfdi.fromJson(Map<String, dynamic> json) => MetodoPagoCfdi(
        id: json["id"],
        name: json["name"],
        metodoPago: json["metodoPago"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "metodoPago": metodoPago,
      };
}

class Tarjeta {
  Tarjeta({
    this.id,
    this.nombre,
    this.tarjeta,
    this.tipo,
    this.numero,
    this.fechaVencimiento,
    this.cvv,
    this.active,
    this.banco,
  });

  int? id;
  String? nombre;
  String? tarjeta;
  String? tipo;
  String? numero;
  String? fechaVencimiento;
  String? cvv;
  bool? active;
  Banco? banco;

  factory Tarjeta.fromJson(Map<String, dynamic> json) => Tarjeta(
        id: json["id"],
        nombre: json["nombre"],
        tarjeta: json["tarjeta"],
        tipo: json["tipo"],
        numero: json["numero"],
        fechaVencimiento: json["fechaVencimiento"],
        cvv: json["cvv"],
        active: json["active"],
        banco: Banco.fromJson(json["banco"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "tarjeta": tarjeta,
        "tipo": tipo,
        "numero": numero,
        "fechaVencimiento": fechaVencimiento,
        "cvv": cvv,
        "active": active,
        "banco": banco?.toJson(),
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
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class TipoDocumento {
  TipoDocumento({
    this.id,
    this.name,
    this.tipoComprobante,
  });

  int? id;
  String? name;
  TipoComprobante? tipoComprobante;

  factory TipoDocumento.fromJson(Map<String, dynamic> json) => TipoDocumento(
        id: json["id"],
        name: json["name"],
        tipoComprobante: TipoComprobante.fromJson(json["tipoComprobante"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tipoComprobante": tipoComprobante?.toJson(),
      };
}

class TipoComprobante {
  TipoComprobante({
    this.id,
    this.name,
    this.tipoComprobante,
  });

  int? id;
  String? name;
  String? tipoComprobante;

  factory TipoComprobante.fromJson(Map<String, dynamic> json) =>
      TipoComprobante(
        id: json["id"],
        name: json["name"],
        tipoComprobante: json["tipoComprobante"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tipoComprobante": tipoComprobante,
      };
}

class UsoCfdi {
  UsoCfdi({
    this.id,
    this.name,
    this.fisica,
    this.moral,
    this.usoCfdi,
  });

  int? id;
  String? name;
  String? fisica;
  String? moral;
  String? usoCfdi;

  factory UsoCfdi.fromJson(Map<String, dynamic> json) => UsoCfdi(
        id: json["id"],
        name: json["name"],
        fisica: json["fisica"],
        moral: json["moral"],
        usoCfdi: json["usoCFDI"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fisica": fisica,
        "moral": moral,
        "usoCFDI": usoCfdi,
      };
}

class Mantenimiento {
  Mantenimiento({
    this.id,
    this.name,
    this.description,
    this.cuota,
    this.diaCorte,
    this.tipoLote,
    this.validoMetrosVivienda,
    this.reglasList,
  });

  int? id;
  String? name;
  String? description;
  double? cuota;
  int? diaCorte;
  String? tipoLote;
  dynamic validoMetrosVivienda;
  List<ReglasList>? reglasList;

  factory Mantenimiento.fromJson(Map<String, dynamic> json) => Mantenimiento(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        cuota: json["cuota"],
        diaCorte: json["diaCorte"],
        tipoLote: json["tipoLote"],
        validoMetrosVivienda: json["validoMetrosVivienda"],
        reglasList: json["reglasList"] == null
            ? null
            : List<ReglasList>.from(
                json["reglasList"].map((x) => ReglasList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "cuota": cuota,
        "diaCorte": diaCorte,
        "tipoLote": tipoLote,
        "validoMetrosVivienda": validoMetrosVivienda,
        "reglasList": reglasList == null
            ? null
            : List<dynamic>.from(reglasList!.map((x) => x.toJson())),
      };
}

class ReglasList {
  ReglasList({
    this.id,
    this.name,
    this.percentDiscount,
    this.description,
  });

  int? id;
  String? name;
  double? percentDiscount;
  String? description;

  factory ReglasList.fromJson(Map<String, dynamic> json) => ReglasList(
        id: json["id"],
        name: json["name"],
        percentDiscount: json["percentDiscount"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "percentDiscount": percentDiscount,
        "description": description,
      };
}

class ResidenteLoteList {
  ResidenteLoteList({
    this.id,
    this.resident,
    this.active,
    this.asociado,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  dynamic resident;
  bool? active;
  bool? asociado;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ResidenteLoteList.fromJson(Map<String, dynamic> json) =>
      ResidenteLoteList(
        id: json["id"],
        resident: json["resident"],
        active: json["active"],
        asociado: json["asociado"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "resident": resident,
        "active": active,
        "asociado": asociado,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
