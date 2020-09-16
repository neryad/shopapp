import 'dart:convert';

//import 'package:PocketList/src/models/product_model.dart';

Segurencia listaFromJson(String str) => Segurencia.fromJson(json.decode(str));

String listaToJson(Segurencia data) => json.encode(data.toJson());

class Segurencia {
  Segurencia({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Segurencia.fromJson(Map<String, dynamic> json) => Segurencia(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
