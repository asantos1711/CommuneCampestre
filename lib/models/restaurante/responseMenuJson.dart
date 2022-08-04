// To parse this JSON data, do
//
//     final menu = menuFromJson(jsonString);


class Menu {
  Menu({
    this.claveMenu,
    this.nombreMenu,
    this.restaurantId,
    this.nombreRestaurant,
    this.turno,
    this.familias,
  });

  String? claveMenu;
  String? nombreMenu;
  int? restaurantId;
  String? nombreRestaurant;
  int? turno;
  List<Familia>? familias;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        claveMenu: json["claveMenu"] == null ? null : json["claveMenu"],
        nombreMenu: json["nombreMenu"] == null ? null : json["nombreMenu"],
        restaurantId:
            json["restaurantId"] == null ? null : json["restaurantId"],
        nombreRestaurant:
            json["nombreRestaurant"] == null ? null : json["nombreRestaurant"],
        turno: json["turno"] == null ? null : json["turno"],
        familias: json["familias"] == null
            ? null
            : List<Familia>.from(
                json["familias"].map((x) => Familia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "claveMenu": claveMenu == null ? null : claveMenu,
        "nombreMenu": nombreMenu == null ? null : nombreMenu,
        "restaurantId": restaurantId == null ? null : restaurantId,
        "nombreRestaurant": nombreRestaurant == null ? null : nombreRestaurant,
        "turno": turno == null ? null : turno,
        "familias": familias == null
            ? null
            : List<dynamic>.from(familias!.map((x) => x.toJson())),
      };
}

class Familia {
  Familia({
    this.id,
    this.nombre,
    this.orden,
    this.imagen,
    this.platillos,
  });

  int? id;
  String? nombre;
  int? orden;
  String? imagen;
  List<Platillo>? platillos;

  factory Familia.fromJson(Map<String, dynamic> json) => Familia(
        id: json["id"] == null ? null : json["id"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        orden: json["orden"] == null ? null : json["orden"],
        imagen: json["imagen"] == null ? null : json["imagen"],
        platillos: json["platillos"] == null
            ? null
            : List<Platillo>.from(
                json["platillos"].map((x) => Platillo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "nombre": nombre == null ? null : nombre,
        "orden": orden == null ? null : orden,
        "imagen": imagen == null ? null : imagen,
        "platillos": platillos == null
            ? null
            : List<dynamic>.from(platillos!.map((x) => x.toJson())),
      };
}

class Platillo {
  Platillo({
    this.id,
    this.nombre,
    this.descripcion,
    this.clasificacion,
    this.tipo,
    this.costo,
    this.precio,
    this.claveVip,
    this.planAlimentos,
    this.imagen,
    this.desayuno,
    this.comida,
    this.cena,
    this.orden,
  });

  int? id;
  String? nombre;
  String? descripcion;
  Clasificacion? clasificacion;
  String? tipo;
  double? costo;
  int? precio;
  String? claveVip;
  String? planAlimentos;
  String? imagen;
  bool? desayuno;
  bool? comida;
  bool? cena;
  int? orden;

  factory Platillo.fromJson(Map<String, dynamic> json) => Platillo(
        id: json["id"] == null ? null : json["id"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
        clasificacion: json["clasificacion"] == null
            ? null
            : clasificacionValues.map![json["clasificacion"]],
        tipo: json["tipo"] == null ? null : json["tipo"],
        costo: json["costo"] == null ? null : json["costo"].toDouble(),
        precio: json["precio"] == null ? null : json["precio"],
        claveVip: json["claveVip"] == null ? null : json["claveVip"],
        planAlimentos:
            json["planAlimentos"] == null ? null : json["planAlimentos"],
        imagen: json["imagen"] == null ? null : json["imagen"],
        desayuno: json["desayuno"] == null ? null : json["desayuno"],
        comida: json["comida"] == null ? null : json["comida"],
        cena: json["cena"] == null ? null : json["cena"],
        orden: json["orden"] == null ? null : json["orden"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "nombre": nombre == null ? null : nombre,
        "descripcion": descripcion == null ? null : descripcion,
        "clasificacion": clasificacion == null
            ? null
            : clasificacionValues.reverse![clasificacion],
        "tipo": tipo == null ? null : tipo,
        "costo": costo == null ? null : costo,
        "precio": precio == null ? null : precio,
        "claveVip": claveVip == null ? null : claveVip,
        "planAlimentos": planAlimentos == null ? null : planAlimentos,
        "imagen": imagen == null ? null : imagen,
        "desayuno": desayuno == null ? null : desayuno,
        "comida": comida == null ? null : comida,
        "cena": cena == null ? null : cena,
        "orden": orden == null ? null : orden,
      };
}

enum Clasificacion { ALIM, BEBI, SNAC, CAVA }

final clasificacionValues = EnumValues({
  "ALIM": Clasificacion.ALIM,
  "BEBI": Clasificacion.BEBI,
  "CAVA": Clasificacion.CAVA,
  "SNAC": Clasificacion.SNAC
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map?.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
