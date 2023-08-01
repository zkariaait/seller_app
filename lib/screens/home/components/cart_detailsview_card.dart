import 'package:flutter/material.dart';
import 'package:store_qr/components/price.dart';
import 'package:store_qr/models/ProductItem.dart';

import '../../../constants.dart';

class CartDetailsViewCard extends StatelessWidget {
  const CartDetailsViewCard({
    Key? key,
    required this.productItem,
    required this.onDismissed,
  }) : super(key: key);

  final ProductItem productItem;
  final Function() onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(productItem.product!.title!), // Set a unique key for the item
      onDismissed: (_) {
        onDismissed();
      },
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: defaultPadding / 2),
        leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(productItem.product!.image!)),
        title: Text(
          productItem.product!.title!,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        trailing: FittedBox(
          child: Row(
            children: [
              Price(
                  amount:
                      '${productItem.product!.price! * productItem.quantity}'),
              Text(
                "   (${productItem.quantity} x ${productItem.product!.price!}\$)",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
