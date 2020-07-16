import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    ProductModel({
        this.id,
        this.name,
        this.quantity,
        this.price,
        this.listId,
    });

    String id;
    String name;
    int quantity;
    double price;
    int listId;

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        listId: json["listId"],
    );

    Map<String, dynamic> toJson() => {
         "id": id,
        "name": name,
        "quantity": quantity,
        "price": price,
        "listId": listId,
    };
}
