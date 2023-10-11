import 'package:cloud_firestore/cloud_firestore.dart';

class EntradasSalidas {
  String? id;
  String? idResidente;
  String? idFraccionamiento;
  String? tipoVisita;
  String? placas;
  String? idUrl;
  String? placasUrl;
  String? nombre;
  String? puntoAcceso;
  int? idLote;
  DateTime? fechaHoraAcceso;
  String? tipo;
  String? cono;
  String? usuarioSeguridad;
  String? nombreSeguridad;
  String? nombreEncargadoObra;
  String? idUsuarioObra;
  String? idSalida;
  String? statusVisita;
  String? razonDenegada;
  String? idDoc;
  String? motivo;

  EntradasSalidas(
      {this.id,
      this.nombre,
      this.idResidente,
      this.tipoVisita,
      this.fechaHoraAcceso,
      this.idFraccionamiento,
      this.placas,
      this.placasUrl,
      this.puntoAcceso,
      this.tipo,
      this.idLote,
      this.idUrl,
      this.nombreSeguridad,
      this.usuarioSeguridad,
      this.nombreEncargadoObra,
      this.idUsuarioObra,
      this.idSalida,
      this.idDoc,
      this.statusVisita,
      this.razonDenegada,
      this.motivo,
      this.cono});

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'idResidente': idResidente,
        'tipoVisita': tipoVisita ?? "",
        'fechaHoraAcceso': fechaHoraAcceso,
        'idFraccionamiento': idFraccionamiento,
        'placas': placas,
        'placasUrl': placasUrl,
        'idUrl': idUrl,
        'puntoAcceso': puntoAcceso,
        'tipo': tipo,
        'idLote': idLote,
        'cono': cono,
        'nombreSeguridad': nombreSeguridad,
        'usuarioSeguridad': usuarioSeguridad,
        'nombreEncargadoObra': nombreEncargadoObra,
        'idSalida': idSalida,
        'statusVisita': statusVisita,
        'razonDenegada': razonDenegada,
        'idUsuarioObra': idUsuarioObra,
        'motivo': motivo,
      };
  Map<String, dynamic> toJsonServiceCommune() => {
        'idApp': id,
        'nombre': nombre,
        'idResidente': idResidente,
        'tipoVisita': tipoVisita ?? "",
        'fechaHoraAcceso': fechaHoraAcceso!.toIso8601String(),
        'idFraccionamiento': idFraccionamiento,
        'placas': placas,
        'placasUrl': placasUrl,
        'puntoAcceso': puntoAcceso,
        'tipo': tipo,
        'idLote': idLote,
        'idUrl': idUrl,
        'cono': cono,
        'motivo': motivo,
        'usuarioSeguridad': usuarioSeguridad,
        'nombreSeguridad': nombreSeguridad,
        'nombreEncargadoObra': nombreEncargadoObra,
        'razonDenegada': razonDenegada,
        'idSalida': idSalida,
        'statusVisita': statusVisita,
        'idUsuarioObra': idUsuarioObra,
      };

  factory EntradasSalidas.fromMapServiceCommune(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    return EntradasSalidas(
        id: data['id'] ?? '',
        nombre: data['nombre'] ?? '',
        idResidente: data['idResidente'] ?? '',
        tipo: data['tipo'] ?? '',
        placas: data['placas'] ?? '',
        idLote: data['idLote'] ?? null,
        motivo: data['motivo'] ?? '',
        fechaHoraAcceso: data['fechaHoraAcceso'] != null
            ? data['fechaHoraAcceso'].toDate()
            : null,
        idFraccionamiento: data['idFraccionamiento'] ?? null,
        puntoAcceso: data['puntoAcceso'] ?? null,
        cono: data['cono'] ?? null,
        idUrl: data['idUrl'] ?? null,
        nombreSeguridad: data['nombreSeguridad'] ?? null,
        usuarioSeguridad: data['usuarioSeguridad'] ?? null,
        idUsuarioObra: data['idUsuarioObra'] ?? null,
        razonDenegada: data['razonDenegada'] ?? null,
        statusVisita: data['statusVisita'] ?? null,
        idSalida: data['idSalida'] ?? null,
        nombreEncargadoObra: data['nombreEncargadoObra'] ?? null,
        tipoVisita: data['tipoVisita'] ?? '');
  }
  factory EntradasSalidas.fromMap(Map<dynamic, dynamic> data) {
    // Map data = doc.data() as Map<dynamic, dynamic>;
    return EntradasSalidas(
        id: data['id'] ?? '',
        nombre: data['nombre'] ?? '',
        idResidente: data['idResidente'] ?? '',
        tipo: data['tipo'] ?? '',
        placas: data['placas'] ?? '',
        idLote: data['idLote'] ?? 0,
        motivo: data['motivo'] ?? '',
        fechaHoraAcceso: data['fechaHoraAcceso'] != null
            ? data['fechaHoraAcceso'].toDate()
            : null,
        idFraccionamiento: data['idFraccionamiento'] ?? null,
        cono: data['cono'] ?? null,
        puntoAcceso: data['puntoAcceso'] ?? null,
        nombreSeguridad: data['nombreSeguridad'] ?? null,
        usuarioSeguridad: data['usuarioSeguridad'] ?? null,
        idUsuarioObra: data['idUsuarioObra'] ?? null,
        nombreEncargadoObra: data['nombreEncargadoObra'] ?? null,
        razonDenegada: data['razonDenegada'] ?? null,
        statusVisita: data['statusVisita'] ?? null,
        idSalida: data['idSalida'] ?? null,
        idUrl: data['idUrl'] ?? null,
        placasUrl: data['placasUrl'] ?? null,
        tipoVisita: data['tipoVisita'] ?? '');
  }
}

// To parse this JSON data, do
//
//     final tiempos = tiemposFromJson(jsonString);

