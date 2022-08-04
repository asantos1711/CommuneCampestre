
// To parse this JSON data, do
//
//     final horariosAmenidades = horariosAmenidadesFromJson(jsonString);

import 'dart:convert';

HorariosAmenidades horariosAmenidadesFromJson(String str) => HorariosAmenidades.fromJson(json.decode(str));

String horariosAmenidadesToJson(HorariosAmenidades data) => json.encode(data.toJson());

class HorariosAmenidades {
    HorariosAmenidades({
        this.data,
        this.message,
        this.success,
        this.status,
    });

    List<Datum>? data;
    String? message;
    bool? success;
    int? status;

    factory HorariosAmenidades.fromJson(Map<String, dynamic> json) => HorariosAmenidades(
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
        this.id,
        this.horario,
        this.estado,
        this.estadoDescripcion,
        this.name, 
        this.agendaTAmenidadId,
        this.lugaresDisponibles,
        this.diasPreviosReservar,
    });

    int? id;
    String? horario;
    String? estado;
    String? estadoDescripcion;
    dynamic name;
    int? agendaTAmenidadId;
    int? lugaresDisponibles;
    int? diasPreviosReservar;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        horario: json["horario"] == null ? null : json["horario"],
        estado: json["estado"] == null ? null : json["estado"],
        estadoDescripcion: json["estadoDescripcion"] == null ? null : json["estadoDescripcion"],
        name: json["name"],
        agendaTAmenidadId: json["agendaTAmenidadId"],
        lugaresDisponibles: json["lugaresDisponibles"],
        diasPreviosReservar: json["diasPreviosReservar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "horario": horario == null ? null : horario,
        "estado": estado == null ? null :estado,
        "estadoDescripcion": estadoDescripcion == null ? null : estadoDescripcion,
        "name": name,
        "lugaresDisponibles": lugaresDisponibles,
        "diasPreviosReservar": diasPreviosReservar,
    };
}