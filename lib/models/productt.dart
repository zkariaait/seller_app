import 'dart:convert';

import 'package:store_qr/models/rating.dart';

class Productt {
  final String name;
  final String description;
  final int quantity;
  final List<String> images;
  final String category;
  final double price;
  String? id;
  final String manufacturer;
  final List<Rating>? rating;
  final String? qrCode;
  bool? isLiked;

  Productt({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    required this.manufacturer,
    this.rating,
    this.qrCode,
    this.isLiked,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'manufacturer': manufacturer,
      'ratings': rating,
      'qrCode': qrCode,
      'isLiked': isLiked,
    };
  }

  factory Productt.fromMap(Map<String, dynamic> map) {
    return Productt(
      id: map['productId'] != null ? map['productId'].toString() : null,
      name: map['productName'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? 0,
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      qrCode: map['qrCode'] ?? '',
      isLiked: map['isLiked'] ?? false,
      price: map['price']?.toDouble() ?? 0.0,
      manufacturer: map['manufacturer'],
      rating: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Productt.fromJson(String source) =>
      Productt.fromMap(json.decode(source));
}
