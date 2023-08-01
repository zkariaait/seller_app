import 'package:like_button/like_button.dart';
import 'package:store_qr/components/fav_btn.dart';
import 'package:store_qr/components/price.dart';
import 'package:store_qr/models/Product.dart';
import 'package:store_qr/screens/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:store_qr/components/fav_btn.dart';
import 'package:store_qr/services/admin_services.dart';

import '../../../constants.dart';
import '../../../models/productt.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  final Product product;
  Productt? productt;

  final AdminServices adminServices = AdminServices();

  final VoidCallback press;
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    print(product.title);
    print(product.id);

    adminServices.LikeProduct(id: product.id!);
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: const BorderRadius.all(
            Radius.circular(defaultPadding * 1.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.title!,
              child: Image.network(product.image!),
            ),
            Expanded(
                child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title!,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    // Text(
                    //   "Category",
                    //   style: Theme.of(context).textTheme.caption,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Price(amount: product.price.toString()),
                        LikeButton(
                          isLiked: product.isLiked,
                          onTap: onLikeButtonTapped,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
