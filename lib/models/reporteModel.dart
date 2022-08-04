import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Reporte {
  String? id;
  String? descripcion;
  int? estatus;
  String? foto1;
  String? foto2;
  File? fotoId;
  File? fotoPlaca;
  String? idFraccionamiento;

  Reporte(
      {this.id,
      this.descripcion,
      this.estatus,
      this.foto1,
      this.foto2,
      this.fotoId,
      this.fotoPlaca,
      this.idFraccionamiento});

  Map<String, dynamic> toJson() => {
        'id': id,
        'descripcion': descripcion,
        'estatus': estatus,
        'foto1': foto1,
        'foto2': foto2,
        'idFraccionamiento': idFraccionamiento,
      };

  factory Reporte.fromMap(Map data) {
    return Reporte(
      id: data['id'] ?? '',
      descripcion: data['descripcion'] ?? '',
      estatus: int.parse(data['estatus'].toString()),
      foto1: data['foto1'],
      foto2: data['foto2'],
      idFraccionamiento: data['idFraccionamiento'],
    );
  }

  factory Reporte.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    return Reporte(
      id: data['id'] ?? '',
      descripcion: data['descripcion'] ?? '',
      estatus: int.parse(data['estatus'].toString()),
      foto1: data['foto1'],
      foto2: data['foto2'],
      idFraccionamiento: data['idFraccionamiento'],
    );
  }
}
