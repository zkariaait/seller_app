import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:store_qr/components/fav_btn.dart';
import 'package:store_qr/components/price.dart';
import 'package:store_qr/constants.dart';
import 'package:store_qr/models/Product.dart';
import '../../services/admin_services.dart';
import 'components/cart_counter.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.product,
    required this.onProductAdd,
  }) : super(key: key);

  final Product product;
  final ValueChanged<int>
      onProductAdd; // Callback for adding product with quantity

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String _cartTag = "";
  int quantity = 1;
  final AdminServices adminServices = AdminServices();

  void updateCartCounterValue(int newQuantity) {
    setState(() {
      quantity = newQuantity;
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    print(widget.product.title);
    print(widget.product.id);

    adminServices.LikeProduct(id: widget.product.id!);
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ElevatedButton(
              onPressed: () {
                widget.onProductAdd(
                    quantity); // Pass the quantity to the callback
                setState(() {
                  _cartTag = '_cartTag';
                });
                Navigator.pop(context);
              },
              child: Text("Add to Cart"),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Category",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          LikeButton(
            isLiked: widget.product.isLiked,
            onTap: onLikeButtonTapped,
          ),
          // FavBtn(radius: 20),
          SizedBox(width: defaultPadding),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.37,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          color: Color(0xFFF8F8F8),
                          child: Hero(
                            tag: widget.product.title!,
                            child: Image.network(widget.product.image!),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: CartCounter(
                            value: quantity,
                            onValueChanged: updateCartCounterValue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: defaultPadding * 1.5),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.title!,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Price(amount: widget.product.price.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      widget.product.description!,
                      style: TextStyle(
                        color: Color(0xFFBDBDBD),
                        height: 1.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
