import 'dart:convert';

import 'package:shopapp/src/models/product_model.dart';

Lista listaFromJson(String str) => Lista.fromJson(json.decode(str));

String listaToJson(Lista data) => json.encode(data.toJson());

class Lista {
    Lista({
        this.id,
        this.title,
        this.superMaret,
        this.fecha,
        this.total

    });

    int id;
    String title;
    String superMaret;
    String fecha;
    double total;
    ProductModel productModel;

    factory Lista.fromJson(Map<String, dynamic> json) => Lista(
        id: json["id"],
        title: json["title"],
        superMaret: json["superMaret"],
        fecha: json["fecha"],
        total: json["total"],
        // prodId: json["prod_id"],
        // productModel: json["ProductModel"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "superMaret": superMaret,
        "fecha": fecha,
        "total":total,
        // "prod_id": prodId,
        // "ProductModel": productModel,
    };
}
