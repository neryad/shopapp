// To parse this JSON data, do
//
//     final csvData = csvDataFromJson(jsonString);

import 'dart:convert';

import 'package:pocketlist/src/models/product_model.dart';

CsvData csvDataFromJson(String str) => CsvData.fromJson(json.decode(str));

String csvDataToJson(CsvData data) => json.encode(data.toJson());

class CsvData {
  CsvData(
      {this.name = '',
      this.quantity = 0,
      this.price = 0,
      this.listId = '',
      this.complete = 0,
      this.title = '',
      this.superMaret = '',
      this.fecha = '',
      this.total = 0,
      this.diference = 0,
      this.buget = 0,
      ProductModel? productModel});

  String name;
  int quantity;
  int price;
  String listId;
  int complete;
  String title;
  String superMaret;
  String fecha;
  int total;
  int diference;
  int buget;

  factory CsvData.fromJson(Map<String, dynamic> json) => CsvData(
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        listId: json["listId"],
        complete: json["complete"],
        title: json["title"],
        superMaret: json["superMaret"],
        fecha: json["fecha"],
        total: json["total"],
        diference: json["diference"],
        buget: json["buget"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "price": price,
        "listId": listId,
        "complete": complete,
        "title": title,
        "superMaret": superMaret,
        "fecha": fecha,
        "total": total,
        "diference": diference,
        "buget": buget,
      };
}
