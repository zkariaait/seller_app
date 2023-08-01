import 'dart:convert';

import 'ProductItem.dart';

class Order {
  String? sName, sLastName;
  List<ProductItem> productItems = [];
  double total = 0.0;

  Order({
    required sName,
    required sLastName,
    required productItems,
    required total,
  });

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'FirstName': sName,
      'LastName': sLastName,
      'Items': productItems.map((x) => x.toMap()).toList(),
      'Total': total,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      sName: map['FirstName'] ?? '',
      sLastName: map['LastName'] ?? '',
      total: map['Total'] ?? '',
      productItems: List<ProductItem>.from(
          map['cartItems']?.map((x) => ProductItem.fromMap(x['cartItem']))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
