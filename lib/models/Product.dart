class Product {
  String? id, title, image, description;
  double? price;
  bool? isLiked;

  Product({
    this.id,
    this.description,
    this.price,
    this.title,
    this.image,
    this.isLiked,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'price': price,
      'isLiked': isLiked,
    };
  }

  Map<String, dynamic> toJson0() {
    return {
      'id': id,
      'title': title,
      'image': image,
      // 'description': description,
      'price': price,
      'isLiked': isLiked,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      price: json['price'],
      isLiked: json['isLiked'],
    );
  }
}
