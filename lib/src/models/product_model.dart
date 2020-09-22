import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.name,
    this.quantity,
    this.price,
    this.listId,
    this.complete,
    // this.autocompleteterm,
  });

  int id;
  String name;
  int quantity;
  double price = 0.00;
  String listId;
  int complete;
  // String autocompleteterm;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        listId: json["listId"],
        complete: json["complete"],
        // autocompleteterm: json['autocompleteTerm'] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "price": price,
        "listId": listId,
        "complete": complete,

        // "autocompleteterm" : autocompleteterm,
      };
}
