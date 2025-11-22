import 'dart:convert';

import 'package:PocketList/src/models/product_model.dart';

Lista listaFromJson(String str) => Lista.fromJson(json.decode(str));

String listaToJson(Lista data) => json.encode(data.toJson());

class Lista {
  Lista(
      {this.id = '',
      this.title = '',
      this.superMaret = '',
      this.fecha = '',
      this.total = 0.0,
      this.diference = 0.0,
      this.buget = 0.0});

  String id;
  String title;
  String superMaret;
  String fecha;
  double total;
  double diference;
  double buget;
  ProductModel? productModel;

  factory Lista.fromJson(Map<String, dynamic> json) => Lista(
        id: json["id"] ?? '',
        title: json["title"] ?? '',
        superMaret: json["superMaret"] ?? '',
        fecha: json["fecha"] ?? '',
        total: (json["total"] is int)
            ? (json["total"] as int).toDouble()
            : (json["total"] ?? 0.0),
        buget: (json["buget"] is int)
            ? (json["buget"] as int).toDouble()
            : (json["buget"] ?? 0.0),
        diference: (json["diference"] is int)
            ? (json["diference"] as int).toDouble()
            : (json["diference"] ?? 0.0),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "superMaret": superMaret,
        "fecha": fecha,
        "total": total,
        "buget": buget,
        "diference": diference,
        // "prod_id": prodId,
        // "ProductModel": productModel,
      };
}
