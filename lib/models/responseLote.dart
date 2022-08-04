// To parse this JSON data, do
//
//     final responseGetLote = responseGetLoteFromJson(jsonString);


//ResponseGetLote responseGetLoteFromJson(String str) => ResponseGetLote.fromJson(json.decode(str));

//String responseGetLoteToJson(ResponseGetLote data) => json.encode(data.toJson());

class ResponseGetLote {
  ResponseGetLote({
    this.data,
    this.message,
    this.success,
    //this.status,
  });

  Data? data;
  String? message;
  dynamic success;
  //int? status;

  factory ResponseGetLote.fromJson(Map<String, dynamic> json) =>
      ResponseGetLote(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] == null ? null : json["message"],
        success: json["success"],
        //status: json["status"] == null ? null : json["status"].toInt(),
      );

  /*Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
        "message": message == null ? null : message,
        "success": success,
        "status": status == null ? null : status,
    };*/
}

class Data {
  Data({
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
    this.fechaEntrega,
    this.latitud,
    this.longitud,
    //this.childrenLotes,
    //this.mantenimiento,
    this.plusPercentMtto,
    this.parentLote,
    //this.residenteLotes,
    this.deuda,
    this.categoryHab,
    this.subCategoryHab,
    this.isRecurrente,
    this.fusionLote,
    //this.residenteLoteList,
    this.vehiculoList,
    //this.datosFiscales,
    this.moratorios,
    this.fondo,
    this.lotesFusionados,
  });

  int? id;
  String? referencia;
  String? numeroViviendas;
  String? calle;
  int? manzana;
  String? lote;
  String? etapa;
  double? superficie;
  String? tipo;
  String? status;
  dynamic category;
  dynamic subestado;
  DateTime? fechaEntrega;
  String? latitud;
  String? longitud;
  //List<Data>? childrenLotes;
  //Mantenimiento? mantenimiento;
  dynamic plusPercentMtto;
  Data? parentLote;
  //List<ResidenteLote>? residenteLotes;
  dynamic deuda;
  String? categoryHab;
  String? subCategoryHab;
  bool? isRecurrente;
  dynamic fusionLote;
  //List<ResidenteLoteList>? residenteLoteList;
  List<dynamic>? vehiculoList;
  //DatosFiscales? datosFiscales;
  List<dynamic>? moratorios;
  dynamic fondo;
  List<dynamic>? lotesFusionados;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? 0 : json["id"],
        /*referencia: json["referencia"] == null ? null : json["referencia"],
        numeroViviendas:
            json["numeroViviendas"] == null ? null : json["numeroViviendas"],
        calle: json["calle"] == null ? null : json["calle"],
        manzana: json["manzana"] == null ? null : json["manzana"],
        lote: json["lote"] == null ? null : json["lote"],
        etapa: json["etapa"] == null ? null : json["etapa"],
        superficie: json["superficie"] == null ? null : json["superficie"],
        tipo: json["tipo"] == null ? null : json["tipo"],
        status: json["status"] == null ? null : json["status"],
        category: json["category"],
        subestado: json["subestado"],
        fechaEntrega: json["fechaEntrega"] == null
            ? null
            : DateTime.parse(json["fechaEntrega"]),
        latitud: json["latitud"] == null ? null : json["latitud"],
        longitud: json["longitud"] == null ? null : json["longitud"],*/
        //childrenLotes: json["childrenLotes"] == null ? null : List<Data>.from(json["childrenLotes"].map((x) => Data.fromJson(x))),
        //mantenimiento: json["mantenimiento"] == null ? null : Mantenimiento.fromJson(json["mantenimiento"]),
        //plusPercentMtto: json["plusPercentMtto"],
        parentLote: json["parentLote"] == null
            ? null
            : Data.fromJson(json["parentLote"]),
        //residenteLotes: json["residenteLotes"] == null ? null : List<ResidenteLote>.from(json["residenteLotes"].map((x) => ResidenteLote.fromJson(x))),
        /*deuda: json["deuda"],
        categoryHab: json["categoryHab"] == null ? null : json["categoryHab"],
        subCategoryHab:
            json["subCategoryHab"] == null ? null : json["subCategoryHab"],
        isRecurrente:
            json["isRecurrente"] == null ? null : json["isRecurrente"],
        fusionLote: json["fusionLote"],*/
        //residenteLoteList: json["residenteLoteList"] == null ? null : List<ResidenteLoteList>.from(json["residenteLoteList"].map((x) => ResidenteLoteList.fromJson(x))),
        //vehiculoList: json["vehiculoList"] == null ? null : List<dynamic>.from(json["vehiculoList"].map((x) => x)),
        //datosFiscales: json["datosFiscales"] == null ? null : DatosFiscales.fromJson(json["datosFiscales"]),
        //moratorios: json["moratorios"] == null ? null : List<dynamic>.from(json["moratorios"].map((x) => x)),
        //fondo: json["fondo"],
        //lotesFusionados: json["lotesFusionados"] == null ? null : List<dynamic>.from(json["lotesFusionados"].map((x) => x)),
      );

  /*Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "referencia": referencia == null ? null : referencia,
        "numeroViviendas": numeroViviendas == null ? null : numeroViviendas,
        "calle": calle == null ? null : calle,
        "manzana": manzana == null ? null : manzana,
        "lote": lote == null ? null : lote,
        "etapa": etapa == null ? null : etapa,
        "superficie": superficie == null ? null : superficie,
        "tipo": tipo == null ? null : tipo,
        "status": status == null ? null : status,
        "category": category,
        "subestado": subestado,
        "fechaEntrega": fechaEntrega == null ? null : fechaEntrega,
        "latitud": latitud == null ? null : latitud,
        "longitud": longitud == null ? null : longitud,
        //"childrenLotes": childrenLotes == null ? null : List<dynamic>.from(childrenLotes!.map((x) => x.toJson())),
        //"mantenimiento": mantenimiento == null ? null : mantenimiento!.toJson(),
        "plusPercentMtto": plusPercentMtto,
        "parentLote": parentLote == null ? null : parentLote!.toJson(),
        //"residenteLotes": residenteLotes == null ? null : List<dynamic>.from(residenteLotes!.map((x) => x.toJson())),
        "deuda": deuda,
        "categoryHab": categoryHab == null ? null : categoryHab,
        "subCategoryHab": subCategoryHab == null ? null : subCategoryHab,
        "isRecurrente": isRecurrente == null ? null : isRecurrente,
        "fusionLote": fusionLote,
        //"residenteLoteList": residenteLoteList == null ? null : List<dynamic>.from(residenteLoteList!.map((x) => x.toJson())),
        "vehiculoList": vehiculoList == null ? null : List<dynamic>.from(vehiculoList!.map((x) => x)),
        //"datosFiscales": datosFiscales == null ? null : datosFiscales!.toJson(),
        "moratorios": moratorios == null ? null : List<dynamic>.from(moratorios!.map((x) => x)),
        "fondo": fondo,
        "lotesFusionados": lotesFusionados == null ? null : List<dynamic>.from(lotesFusionados!.map((x) => x)),
    };
}*/
}

/*
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
        this.regimenFiscal,
        this.urlFileConstancia,
        this.nameFileConstancia,
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
    dynamic tarjeta;
    dynamic regimenFiscal;
    dynamic urlFileConstancia;
    dynamic nameFileConstancia;

    factory DatosFiscales.fromJson(Map<String, dynamic> json) => DatosFiscales(
        id: json["id"] == null ? null : json["id"],
        razonSocial: json["razonSocial"] == null ? null : json["razonSocial"],
        rfc: json["rfc"] == null ? null : json["rfc"],
        poblacion: json["poblacion"] == null ? null : json["poblacion"],
        cuenta: json["cuenta"] == null ? null : json["cuenta"],
        domicilio: json["domicilio"] == null ? null : json["domicilio"],
        numeroExterior: json["numeroExterior"] == null ? null : json["numeroExterior"],
        colonia: json["colonia"] == null ? null : json["colonia"],
        ciudad: json["ciudad"] == null ? null : json["ciudad"],
        municipio: json["municipio"] == null ? null : json["municipio"],
        estado: json["estado"] == null ? null : json["estado"],
        pais: json["pais"] == null ? null : json["pais"],
        codigoPostal: json["codigoPostal"] == null ? null : json["codigoPostal"],
        email: json["email"] == null ? null : json["email"],
        loteTransient: json["loteTransient"],
        metodoPagoCfdi: json["metodoPagoCFDI"] == null ? null : MetodoPagoCfdi.fromJson(json["metodoPagoCFDI"]),
        formaPagoCfdi: json["formaPagoCFDI"] == null ? null : FormaPagoCfdi.fromJson(json["formaPagoCFDI"]),
        usoCfdi: json["usoCFDI"] == null ? null : UsoCfdi.fromJson(json["usoCFDI"]),
        tipoDocumento: json["tipoDocumento"] == null ? null : TipoDocumento.fromJson(json["tipoDocumento"]),
        claveUnidadCfdi: json["claveUnidadCFDI"] == null ? null : ClaveUnidadCfdi.fromJson(json["claveUnidadCFDI"]),
        claveProductoServicio: json["claveProductoServicio"] == null ? null : ClaveProductoServicio.fromJson(json["claveProductoServicio"]),
        metodoPago: json["metodoPago"] == null ? null : MetodoPago.fromJson(json["metodoPago"]),
        tarjeta: json["tarjeta"],
        regimenFiscal: json["regimenFiscal"],
        urlFileConstancia: json["urlFileConstancia"],
        nameFileConstancia: json["nameFileConstancia"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "razonSocial": razonSocial == null ? null : razonSocial,
        "rfc": rfc == null ? null : rfc,
        "poblacion": poblacion == null ? null : poblacion,
        "cuenta": cuenta == null ? null : cuenta,
        "domicilio": domicilio == null ? null : domicilio,
        "numeroExterior": numeroExterior == null ? null : numeroExterior,
        "colonia": colonia == null ? null : colonia,
        "ciudad": ciudad == null ? null : ciudad,
        "municipio": municipio == null ? null : municipio,
        "estado": estado == null ? null : estado,
        "pais": pais == null ? null : pais,
        "codigoPostal": codigoPostal == null ? null : codigoPostal,
        "email": email == null ? null : email,
        "loteTransient": loteTransient,
        "metodoPagoCFDI": metodoPagoCfdi == null ? null : metodoPagoCfdi!.toJson(),
        "formaPagoCFDI": formaPagoCfdi == null ? null : formaPagoCfdi!.toJson(),
        "usoCFDI": usoCfdi == null ? null : usoCfdi!.toJson(),
        "tipoDocumento": tipoDocumento == null ? null : tipoDocumento!.toJson(),
        "claveUnidadCFDI": claveUnidadCfdi == null ? null : claveUnidadCfdi!.toJson(),
        "claveProductoServicio": claveProductoServicio == null ? null : claveProductoServicio!.toJson(),
        "metodoPago": metodoPago == null ? null : metodoPago!.toJson(),
        "tarjeta": tarjeta,
        "regimenFiscal": regimenFiscal,
        "urlFileConstancia": urlFileConstancia,
        "nameFileConstancia": nameFileConstancia,
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

    factory ClaveProductoServicio.fromJson(Map<String, dynamic> json) => ClaveProductoServicio(
        id: json["id"] == null ? null : json["id"],
        claveProduccionServicio: json["claveProduccionServicio"] == null ? null : json["claveProduccionServicio"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "claveProduccionServicio": claveProduccionServicio == null ? null : claveProduccionServicio,
        "name": name == null ? null : name,
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

    factory ClaveUnidadCfdi.fromJson(Map<String, dynamic> json) => ClaveUnidadCfdi(
        id: json["id"] == null ? null : json["id"],
        claveUnidad: json["claveUnidad"] == null ? null : json["claveUnidad"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "claveUnidad": claveUnidad == null ? null : claveUnidad,
        "name": name == null ? null : name,
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
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        metodoPago: json["metodoPago"] == null ? null : json["metodoPago"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "metodoPago": metodoPago == null ? null : metodoPago,
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
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        tipoComprobante: json["tipoComprobante"] == null ? null : TipoComprobante.fromJson(json["tipoComprobante"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "tipoComprobante": tipoComprobante == null ? null : tipoComprobante!.toJson(),
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

    factory TipoComprobante.fromJson(Map<String, dynamic> json) => TipoComprobante(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        tipoComprobante: json["tipoComprobante"] == null ? null : json["tipoComprobante"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "tipoComprobante": tipoComprobante == null ? null : tipoComprobante,
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
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        fisica: json["fisica"] == null ? null : json["fisica"],
        moral: json["moral"] == null ? null : json["moral"],
        usoCfdi: json["usoCFDI"] == null ? null : json["usoCFDI"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "fisica": fisica == null ? null : fisica,
        "moral": moral == null ? null : moral,
        "usoCFDI": usoCfdi == null ? null : usoCfdi,
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
    int? cuota;
    int? diaCorte;
    String? tipoLote;
    dynamic validoMetrosVivienda;
    List<ReglasList>? reglasList;

    factory Mantenimiento.fromJson(Map<String, dynamic> json) => Mantenimiento(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        cuota: json["cuota"] == null ? null : json["cuota"],
        diaCorte: json["diaCorte"] == null ? null : json["diaCorte"],
        tipoLote: json["tipoLote"] == null ? null : json["tipoLote"],
        validoMetrosVivienda: json["validoMetrosVivienda"],
        reglasList: json["reglasList"] == null ? null : List<ReglasList>.from(json["reglasList"].map((x) => ReglasList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "cuota": cuota == null ? null : cuota,
        "diaCorte": diaCorte == null ? null : diaCorte,
        "tipoLote": tipoLote == null ? null : tipoLote,
        "validoMetrosVivienda": validoMetrosVivienda,
        "reglasList": reglasList == null ? null : List<dynamic>.from(reglasList!.map((x) => x.toJson())),
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
    int? percentDiscount;
    String? description;

    factory ReglasList.fromJson(Map<String, dynamic> json) => ReglasList(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        percentDiscount: json["percentDiscount"] == null ? null : json["percentDiscount"],
        description: json["description"] == null ? null : json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "percentDiscount": percentDiscount == null ? null : percentDiscount,
        "description": description == null ? null : description,
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

    factory ResidenteLoteList.fromJson(Map<String, dynamic> json) => ResidenteLoteList(
        id: json["id"] == null ? null : json["id"],
        resident: json["resident"],
        active: json["active"] == null ? null : json["active"],
        asociado: json["asociado"] == null ? null : json["asociado"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "resident": resident,
        "active": active == null ? null : active,
        "asociado": asociado == null ? null : asociado,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
    };
}

class ResidenteLote {
    ResidenteLote({
        this.id,
        this.active,
        this.asociado,
        this.createdAt,
        this.updatedAt,
        this.residente,
        this.lote,
    });

    int? id;
    bool? active;
    bool? asociado;
    DateTime? createdAt;
    DateTime? updatedAt;
    Residente? residente;
    dynamic lote;

    factory ResidenteLote.fromJson(Map<String, dynamic> json) => ResidenteLote(
        id: json["id"] == null ? null : json["id"],
        active: json["active"] == null ? null : json["active"],
        asociado: json["asociado"] == null ? null : json["asociado"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        residente: json["residente"] == null ? null : Residente.fromJson(json["residente"]),
        lote: json["lote"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "active": active == null ? null : active,
        "asociado": asociado == null ? null : asociado,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "residente": residente == null ? null : residente!.toJson(),
        "lote": lote,
    };
}

class Residente {
    Residente({
        this.id,
        this.name,
        this.telefonoList,
        this.correoElectronicoList,
        this.tarjetaList,
        this.deuda,
        this.tipo,
    });

    int? id;
    String? name;
    List<TelefonoList>? telefonoList;
    List<CorreoElectronicoList>? correoElectronicoList;
    List<dynamic>? tarjetaList;
    dynamic deuda;
    String? tipo;

    factory Residente.fromJson(Map<String, dynamic> json) => Residente(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        telefonoList: json["telefonoList"] == null ? null : List<TelefonoList>.from(json["telefonoList"].map((x) => TelefonoList.fromJson(x))),
        correoElectronicoList: json["correoElectronicoList"] == null ? null : List<CorreoElectronicoList>.from(json["correoElectronicoList"].map((x) => CorreoElectronicoList.fromJson(x))),
        tarjetaList: json["tarjetaList"] == null ? null : List<dynamic>.from(json["tarjetaList"].map((x) => x)),
        deuda: json["deuda"],
        tipo: json["tipo"] == null ? null : json["tipo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "telefonoList": telefonoList == null ? null : List<dynamic>.from(telefonoList!.map((x) => x.toJson())),
        "correoElectronicoList": correoElectronicoList == null ? null : List<dynamic>.from(correoElectronicoList!.map((x) => x.toJson())),
        "tarjetaList": tarjetaList == null ? null : List<dynamic>.from(tarjetaList!.map((x) => x)),
        "deuda": deuda,
        "tipo": tipo == null ? null : tipo,
    };
}

class CorreoElectronicoList {
    CorreoElectronicoList({
        this.id,
        this.correo,
        this.referencia,
        this.facturar,
    });

    int? id;
    String? correo;
    String? referencia;
    bool? facturar;

    factory CorreoElectronicoList.fromJson(Map<String, dynamic> json) => CorreoElectronicoList(
        id: json["id"] == null ? null : json["id"],
        correo: json["correo"] == null ? null : json["correo"],
        referencia: json["referencia"] == null ? null : json["referencia"],
        facturar: json["facturar"] == null ? null : json["facturar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "correo": correo == null ? null : correo,
        "referencia": referencia == null ? null : referencia,
        "facturar": facturar == null ? null : facturar,
    };
}

class TelefonoList {
    TelefonoList({
        this.id,
        this.numero,
        this.referencia,
        this.tipoNumeroTelefono,
    });

    int? id;
    String? numero;
    String? referencia;
    TipoNumeroTelefono? tipoNumeroTelefono;

    factory TelefonoList.fromJson(Map<String, dynamic> json) => TelefonoList(
        id: json["id"] == null ? null : json["id"],
        numero: json["numero"] == null ? null : json["numero"],
        referencia: json["referencia"] == null ? null : json["referencia"],
        tipoNumeroTelefono: json["tipoNumeroTelefono"] == null ? null : TipoNumeroTelefono.fromJson(json["tipoNumeroTelefono"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "numero": numero == null ? null : numero,
        "referencia": referencia == null ? null : referencia,
        "tipoNumeroTelefono": tipoNumeroTelefono == null ? null : tipoNumeroTelefono!.toJson(),
    };
}

class TipoNumeroTelefono {
    TipoNumeroTelefono({
        this.id,
        this.name,
    });

    int? id;
    String? name;

    factory TipoNumeroTelefono.fromJson(Map<String, dynamic> json) => TipoNumeroTelefono(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
    };
}
*/
