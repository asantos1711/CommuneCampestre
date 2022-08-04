class PedidosCasaClub {
  PedidosCasaClub(
      {required this.id, required this.fecha, required this.idPedido});

  String id, idPedido;
  DateTime fecha;

  factory PedidosCasaClub.fromJson(Map<String, dynamic> json) =>
      PedidosCasaClub(
        idPedido: json["idPedido"] == null ? null : json["idPedido"],
        id: json["id"] == null ? null : json["id"],
        fecha: json["fecha"] == null ? null : json["fecha"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "idPedido": idPedido == null ? null : idPedido,
        "id": id == null ? null : id,
        "fecha": fecha == null ? null : fecha,
      };
}
