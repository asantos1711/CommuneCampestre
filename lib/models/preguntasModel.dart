import 'package:cloud_firestore/cloud_firestore.dart';

class PreguntasFrecuentes {
  String? pregunta;
  String? respuesta;
  String? idFraccionamiento;

  PreguntasFrecuentes(
      {this.pregunta,
      this.respuesta,
      this.idFraccionamiento});

  Map<String, dynamic> toJson() => {
        'pregunta': pregunta,
        'respuesta': respuesta,
        'idFraccionamiento': idFraccionamiento,
      };

  factory PreguntasFrecuentes.fromMap(Map data) {
    return PreguntasFrecuentes(
      pregunta: data['pregunta'] ?? '',
      respuesta: data['respuesta'] ?? '',
      idFraccionamiento: data['idFraccionamiento'] ?? '',
    );
  }

  factory PreguntasFrecuentes.fromFirestore(DocumentSnapshot doc) {
     Map data = doc.data() as Map<dynamic, dynamic>;
    return PreguntasFrecuentes(
      pregunta: data['pregunta'] ?? '',
      respuesta: data['respuesta'] ?? '',
      idFraccionamiento: data['idFraccionamiento'] ?? '',
    );
  }
}
