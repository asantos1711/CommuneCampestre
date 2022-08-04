import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Invitado {
  String? id;
  String? nombre;
  Tiempos? tiempos;
  String? telefono;
  String? email;
  File? fotoId;
  File? fotoPlaca;
  String? fotoIdUrl;
  String? nombreResidente;
  String? domicilio;
  String? fotoPlacaUrl;
  String? idResidente;
  String? acompanantes;
  String? tipoVisita;
  DateTime? fechaHoraAcceso;
  String? placas;
  String? idEvento;
  bool? activo;
  String? idFraccionamiento;
  int? idLote;
  int? idRegistro;

  Invitado(
      {this.id,
      this.nombre,
      this.tiempos,
      this.telefono,
      this.domicilio,
      this.email,
      this.fotoId,
      this.fotoPlaca,
      this.fotoIdUrl,
      this.fotoPlacaUrl,
      this.idResidente,
      this.nombreResidente,
      this.tipoVisita,
      this.acompanantes,
      this.fechaHoraAcceso,
      this.idEvento,
      this.placas,
      this.activo,
      this.idLote,
      this.idRegistro,
      this.idFraccionamiento});

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'tiempos': tiempos?.toJson(),
        'telefono': telefono,
        'email': email,
        'idEvento': idEvento,
        'referencia': domicilio,
        //'fotoId': fotoId,
        //'fotoPlaca': fotoPlaca,
        'fotoIdUrl': fotoIdUrl,
        'fotoPlacaUrl': fotoPlacaUrl,
        'idResidente': idResidente,
        'acompanantes': acompanantes ?? "",
        'tipoVisita': tipoVisita ?? "",
        'nombreResidente': nombreResidente,
        'fechaHoraAcceso': fechaHoraAcceso,
        'placas': placas,
        'activo': activo,
        'idLote': idLote,
        'idRegistro': idRegistro,
        'idFraccionamiento': idFraccionamiento
      };

  Map<String, dynamic> toJsonRecurrente() => {
        'id': id,
        'nombre': nombre,
        //'entrada': entrada.toIso8601String(),
        'telefono': telefono,
        'email': email,
        //'referencia': referencia,
        //'fotoId': fotoId,
        //'fotoPlaca': fotoPlaca,
        'fotoIdUrl': fotoIdUrl,
        'fotoPlacaUrl': fotoPlacaUrl,
        'tipoVisita': tipoVisita,
        'placas': placas,
        "tiempos": tiempos == null ? null : tiempos?.toJson(),
        'activo': activo

        //'idResidente': idResidente,
        //'nombreResidente': nombreResidente,
      };

  factory Invitado.fromMapRecurrente(Map data) {
    return Invitado(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',

      //tiempos: Tiempos.fromJson(data["tiempos"]),
      //entrada: data['entrada'] ?? '',
      telefono: data['telefono'] ?? '',
      email: data['email'] ?? '',
      //numAcompa: data['numAcompa'] ?? 0,
      //fotoId: data['fotoId'] ?? '',
      //fotoPlaca: data['fotoPlaca'] ?? '',
      //referencia: data['referencia'] ?? '',
      fotoIdUrl: data['fotoIdUrl'] ?? '',
      fotoPlacaUrl: data['fotoPlacaUrl'] ?? '',
      // recurrente: data['recurrente'] ?? '',
      //idResidente: data['idResidente'] ?? '',
      //nombreResidente: data['nombreResidente'] ?? '',
    );
  }

  factory Invitado.fromMap(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    return Invitado(
        id: data['id'] ?? '',
        nombre: data['nombre'] ?? '',
        tiempos:
            data["tiempos"] == null ? null : Tiempos.fromJson(data["tiempos"]),
        //tiempos: Tiempos.fromJson(jsonDecode(data['tiempos'])),
        telefono: data['telefono'] ?? '',
        email: data['email'] ?? '',
        idFraccionamiento: data['idFraccionamiento'] ?? '',
        //numAcompa: data['numAcompa'] ?? 0,
        //fotoId: data['fotoId'] ?? '' as File?,
        //fotoPlaca: data['fotoPlaca'] ?? '' as File?,
        domicilio: data['domicilio'] ?? '',
        fotoIdUrl: data['fotoIdUrl'] ?? null,
        fotoPlacaUrl: data['fotoPlacaUrl'] ?? null,
        idResidente: data['idResidente'] ?? '',
        placas: data['placas'] ?? '',
        acompanantes:
            data["acompanantes"] != null ? data["acompanantes"].toString() : "",
        nombreResidente: data['nombreResidente'] ?? '',
        fechaHoraAcceso: data['fechaHoraAcceso'] != null
            ? data['fechaHoraAcceso'].toDate()
            : null,
        tipoVisita: data['tipoVisita'] ?? '',
        idLote: data['idLote'] ?? 0,
        idRegistro: data['idRegistro'] ?? 0,
        activo: data['activo'] ?? false,
        idEvento: data['idEvento']);
  }
}

// To parse this JSON data, do
//
//     final tiempos = tiemposFromJson(jsonString);

class Tiempos {
  Tiempos({
    this.fechaEntrada,
    this.fechaSalida,
    this.horaEntrada,
    this.horaSalida,
    this.dias,
  });

  DateTime? fechaEntrada;
  DateTime? fechaSalida;
  String? horaEntrada;
  String? horaSalida;
  List<bool>? dias;

  factory Tiempos.fromJson(Map json) {
    //Map json = doc.data() as Map<dynamic, dynamic>;

    return Tiempos(
      fechaEntrada: json["fechaEntrada"] == null
          ? null
          : json["fechaEntrada"]
              .toDate(), //DateTime.parse(json["fechaEntrada"].toString()),
      fechaSalida: json["fechaSalida"] == null
          ? null
          : json["fechaSalida"]
              .toDate(), //DateTime.parse(json["fechaSalida"].toString()),
      horaEntrada:
          json["horaEntrada"] == null ? "" : json["horaEntrada"].toString(),
      horaSalida:
          json["horaSalida"] == null ? "" : json["horaSalida"].toString(),
      dias: json["dias"] != null
          ? List<bool>.from(json["dias"].map((x) => x))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "fechaEntrada": fechaEntrada,
        "fechaSalida": fechaSalida,
        "horaEntrada": horaEntrada,
        "horaSalida": horaSalida,
        "dias": dias != null ? List<dynamic>.from(dias!.map((x) => x)) : null,
      };
}

class TipoVisita {
  static String regularDefinido = "regulardefinido";
  static String regularIndefinido = "regularindefinido";
  static String trabajador = "trabajador";
  static String paqueteria = "paqueteria";
  static String mudanza = "mudanza";
  static String fiesta = "fiesta";
}
