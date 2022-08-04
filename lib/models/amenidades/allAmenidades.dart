// To parse this JSON data, do
//
//     final allAmenidades = allAmenidadesFromJson(jsonString);

import 'dart:convert';

List<AllAmenidades> allAmenidadesFromJson(String str) => List<AllAmenidades>.from(json.decode(str).map((x) => AllAmenidades.fromJson(x)));

String allAmenidadesToJson(List<AllAmenidades> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllAmenidades {
    AllAmenidades({
        this.id,
        this.name,
        this.active,
    });

    int? id;
    String? name;
    bool? active;

    factory AllAmenidades.fromJson(Map<String, dynamic> json) => AllAmenidades(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        active: json["active"] == null ? null : json["active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "active": active == null ? null : active,
    };
}
