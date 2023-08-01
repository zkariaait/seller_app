import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}



  // fetchAllProducts() async {
  //   products = await adminServices.fetchAllProducts();
  //   for (int i = 0; i < products!.length; i++) {
  //     Product product = new Product();
  //     product.title = products![i].name;
  //     product.description = products![i].description;
  //     product.price = products![i].price;
  //     product.image = products![i].images.first;
  //     print('WAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA$product');
  //     demo_products!.add(product);
  //   }
  //   setState(() {});
  // }