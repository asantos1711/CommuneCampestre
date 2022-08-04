// To parse this JSON data, do
//
//     final newsletterModel = newsletterModelFromJson(jsonString);

import 'dart:convert';

NewsletterModel newsletterModelFromJson(String str) =>
    NewsletterModel.fromJson(json.decode(str));

String newsletterModelToJson(NewsletterModel data) =>
    json.encode(data.toJson());

class NewsletterModel {
  NewsletterModel({
    this.newsLetterList,
    this.total,
    this.next,
    this.previous,
  });

  List<NewsLetterList>? newsLetterList;
  int? total;
  bool? next;
  bool? previous;

  factory NewsletterModel.fromJson(Map<String, dynamic> json) =>
      NewsletterModel(
        newsLetterList: json["newsLetterList"] == null
            ? null
            : List<NewsLetterList>.from(
                json["newsLetterList"].map((x) => NewsLetterList.fromJson(x))),
        total: json["total"] == null ? null : json["total"],
        next: json["next"] == null ? null : json["next"],
        previous: json["previous"] == null ? null : json["previous"],
      );

  Map<String, dynamic> toJson() => {
        "newsLetterList": newsLetterList == null
            ? null
            : List<dynamic>.from(newsLetterList!.map((x) => x.toJson())),
        "total": total == null ? null : total,
        "next": next == null ? null : next,
        "previous": previous == null ? null : previous,
      };
}

class NewsLetterList {
  NewsLetterList({
    this.id,
    this.name,
    this.descripcion,
    this.url,
    this.fileName,
    this.createdAt,
  });

  int? id;
  String? name;
  String? descripcion;
  String? url;
  dynamic fileName;
  DateTime? createdAt;

  factory NewsLetterList.fromJson(Map<String, dynamic> json) => NewsLetterList(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
        url: json["url"] == null ? null : json["url"],
        fileName: json["fileName"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "descripcion": descripcion == null ? null : descripcion,
        "url": url == null ? null : url,
        "fileName": fileName,
        "createdAt": createdAt == null ? null : createdAt?.toIso8601String(),
      };
}
