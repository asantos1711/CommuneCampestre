import 'dart:convert';

PlatillosPedidos platillosPedidosFromJson(String str) =>
    PlatillosPedidos.fromJson(json.decode(str));

String platillosPedidosToJson(PlatillosPedidos data) =>
    json.encode(data.toJson());

class PlatillosPedidos {
  PlatillosPedidos(
      {this.idplatillo,
      this.tiempo,
      this.comensal,
      this.cantidad,
      this.precio,
      this.extras,
      this.nombre});

  String? idplatillo;
  String? tiempo;
  String? comensal;
  String? cantidad;
  String? extras;
  String? nombre;
  int? precio;

  factory PlatillosPedidos.fromJson(Map<String, dynamic> json) =>
      PlatillosPedidos(
        idplatillo: json["idplatillo"] == null ? null : json["idplatillo"],
        tiempo: json["tiempo"] == null ? null : json["tiempo"],
        comensal: json["comensal"] == null ? null : json["comensal"],
        cantidad: json["cantidad"] == null ? null : json["cantidad"],
        extras: json["extras"] == null ? null : json["extras"],
        precio: json["precio"] == null ? null : json["precio"],
      );

  Map<String, dynamic> toJson() => {
        "idplatillo": idplatillo == null ? null : idplatillo,
        "tiempo": tiempo == null ? null : tiempo,
        "comensal": comensal == null ? null : comensal,
        "cantidad": cantidad == null ? null : cantidad,
        "extras": extras == null ? "" : extras,
        "precio": precio == null ? null : precio,
      };
}
