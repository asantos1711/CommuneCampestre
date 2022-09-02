import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String? nombre;
  String? telefono;
  String? email;
  String? idResidente;
  String? direccion;
  String? tipo;
  String? estatus;
  int? lote;
  String? idTitular;
  int? idRegistro;
  String? tokenNoti;
  String? idFraccionamiento;
  int? lotePadre;

  Usuario(
      {this.nombre,
      this.telefono,
      this.email,
      this.direccion,
      this.idResidente,
      this.tipo,
      this.estatus,
      this.lote,
      this.idTitular,
      this.idFraccionamiento,
      this.tokenNoti,
      this.idRegistro,
      this.lotePadre});

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
        'tipo': tipo,
        'idResidente': idResidente,
        'estatus': estatus,
        'lote': lote,
        'idTitular': idTitular,
        'tokenNoti': tokenNoti,
        'idRegistro': idRegistro,
        'idFraccionamiento': idFraccionamiento,
        'lotePadre': lotePadre
      };

  factory Usuario.fromMap(Map data) {
    return Usuario(
      nombre: data['nombre'] ?? '',
      telefono: data['telefono'] ?? '',
      email: data['email'] ?? '',
      direccion: data['direccion'],
      tipo: data['tipo'],
      idResidente: data['idResidente'] ?? '',
      estatus: data['estatus'] ?? '',
      idTitular: data['idTitular'] ?? '',
      tokenNoti: data['tokenNoti'] ?? '',
      idFraccionamiento: data['idFraccionamiento'] ?? '',
      idRegistro: data['idRegistro'] ?? null,
      lotePadre: data['lotePadre'] ?? null,
      lote: int.parse(data['lote'].toString()) ?? null,
    );
  }

  factory Usuario.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data();
    return Usuario(
      nombre: data['nombre'] ?? '',
      telefono: data['telefono'] ?? '',
      email: data['email'] ?? '',
      tipo: data['tipo'],
      direccion: data['direccion'],
      idResidente: data['idResidente'] ?? '',
      estatus: data['estatus'] ?? '',
      idRegistro: data['idRegistro'] ?? null,
      idFraccionamiento: data['idFraccionamiento'] ?? '',
      tokenNoti: data['tokenNoti'] ?? '',
      idTitular: data['idTitular'] ?? '',
      lotePadre: data['lotePadre'] ?? null,
      lote: int.tryParse(data['lote'].toString()) ?? null,
    );
  }
}
