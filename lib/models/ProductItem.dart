import 'dart:convert';

import 'Product.dart';

class ProductItem {
  int quantity;
  final Product? product;

  ProductItem({this.quantity = 1, required this.product});

  void increment() {
    quantity++;
  }

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'quantity': quantity,
      'product': product,
    };
  }

  factory ProductItem.fromMap(Map<String, dynamic> map) {
    return ProductItem(
      quantity: map['quantity'] ?? '',
      product: map['product'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductItem.fromJson(String source) =>
      ProductItem.fromMap(json.decode(source));

  // void add() {}

  // void substract() {}
}
