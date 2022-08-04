class EventoModel {
  String? id;
  String? nombre;
  Tiempos? tiempos;
  String? nombreResidente;
  String? domicilio;
  String? idResidente;
  String? tipoVisita;

  EventoModel({
    this.id,
    this.nombre,
    this.tiempos,
    this.domicilio,
    this.idResidente,
    this.nombreResidente,
    this.tipoVisita,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'tiempos': tiempos?.toJson(),
        'referencia': domicilio,
        'idResidente': idResidente,
        'tipoVisita': tipoVisita ?? "",
        'nombreResidente': nombreResidente
      };

  factory EventoModel.fromMap(Map<String, dynamic> data) {
    return EventoModel(
        id: data['id'] ?? '',
        nombre: data['nombre'] ?? '',
        tiempos: Tiempos.fromJson(data["tiempos"]),
        domicilio: data['domicilio'] ?? '',
        idResidente: data['idResidente'] ?? '',
        nombreResidente: data['nombreResidente'] ?? '',
        tipoVisita: data['tipoVisita'] ?? '');
  }
}

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

  factory Tiempos.fromJson(Map<String, dynamic> json) => Tiempos(
        fechaEntrada:
            json["fechaEntrada"] == null ? null : json["fechaEntrada"].toDate(),
        fechaSalida:
            json["fechaSalida"] == null ? null : json["fechaSalida"].toDate(),
        horaEntrada: json["horaEntrada"] == null ? null : json["horaEntrada"],
        horaSalida: json["horaSalida"] == null ? null : json["horaSalida"],
        dias: json["dias"] == null
            ? null
            : List<bool>.from(json["dias"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "fechaEntrada": fechaEntrada,
        "fechaSalida": fechaSalida,
        "horaEntrada": horaEntrada,
        "horaSalida": horaSalida,
        "dias": dias != null ? List<dynamic>.from(dias!.map((x) => x)) : null,
      };
}
