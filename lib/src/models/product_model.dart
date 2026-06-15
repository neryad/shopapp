import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id = 0,
    this.name = '',
    this.quantity = 0,
    this.price = 0.0,
    this.listId = '',
    this.complete = 0,
    this.categoryId,
  });

  int id;
  String name;
  int quantity;
  double price = 0.00;
  String listId;
  int complete;
  int? categoryId;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        listId: json["listId"],
        complete: json["complete"],
        categoryId: json["categoryId"] as int?,
        // autocompleteterm: json['autocompleteTerm'] as String,
      );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      "name": name,
      "quantity": quantity,
      "price": price,
      "listId": listId,
      "complete": complete,
      "categoryId": categoryId,
      // "autocompleteterm" : autocompleteterm,
    };

    // Only include id if it's not 0 (i.e., for updates, not inserts)
    if (id != 0) {
      json["id"] = id;
    }

    return json;
  }
}
