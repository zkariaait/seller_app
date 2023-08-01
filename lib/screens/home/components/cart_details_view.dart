import 'package:flutter/material.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_qr/auth/services/auth_service.dart';
import 'package:store_qr/models/ProductItem.dart';
import 'package:store_qr/models/order.dart';
import 'package:store_qr/screens/home/controllers/home_controller.dart';
import 'package:store_qr/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'cart_detailsview_card.dart';

class CartDetailsView extends StatefulWidget {
  const CartDetailsView({Key? key, required this.controller}) : super(key: key);

  final HomeController controller;

  @override
  _CartDetailsViewState createState() => _CartDetailsViewState();
}

class _CartDetailsViewState extends State<CartDetailsView> {
  double total = 0.0;
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;
  String qrData = '';

  @override
  void initState() {
    super.initState();
    calculateTotal();
    getQrdata(); // Call getQrdata to set qrData asynchronously
  }

  void calculateTotal() {
    total = 0.0;
    widget.controller.cart.forEach((element) {
      total = total + (element.product!.price! * element.quantity);
    });
  }

  Future<String> getRib() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rib = prefs.getString('rib');
    //   print('RRRIIIIBBB $rib');
    return rib!;
  }

  Future<String> getFirstName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? FirstName = prefs.getString('firstName');
    // print('RRRIIIIBBB $FirstName');
    return FirstName!;
  }

  Future<String> getlastName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastName = prefs.getString('lastName');
//print('RRRIIIIBBB $lastName');
    return lastName!;
  }

  Future<void> getQrdata() async {
    var data = '';
    var qrTotal = 0.0;
    if (widget.controller.cart.isNotEmpty) {
      data += 'Articles :\n';
    }
    List<ProductItem> productItems = [];

    widget.controller.cart.forEach((element) {
      //  ProductItem? pi;
      ProductItem pi = ProductItem(product: element.product);

      if (element.product!.price != null) {
        //  pi!.product!.title = element.product!.title;
        pi!.quantity = element.quantity;
        // print('5555${pi.product!.title}');
        productItems.add(pi);
        // print('5555${productItems}');
        qrTotal += (element.product!.price! * element.quantity);
        data +=
            '     ${element.product!.title} (\$${element.product!.price!}) x${element.quantity} \n';
      }
    });

    String rib = await getRib(); // Await the actual value of getRib()

    String firstName = await getFirstName();

    String lastName = await getlastName();

    Order order = new Order(
        sName: firstName,
        sLastName: lastName,
        productItems: productItems,
        total: total);

    order.sName = firstName;
    order.sLastName = lastName;
    order.total = qrTotal;
    order.productItems = productItems;

    // print('000${order.toJson()}');
    data +=
        '\nTOTAL : \$$qrTotal \nNom: $lastName\nPrenom: $firstName\nRIB: $rib\n';
    setState(() {
      qrData = order.toJson(); // Set qrData and trigger a state update
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cart", style: Theme.of(context).textTheme.headline6),
          //Icon(Icons.receipt),
          ...List.generate(
            widget.controller.cart.length,
            (index) => CartDetailsViewCard(
              productItem: widget.controller.cart[index],
              onDismissed: () {
                widget.controller.removeFromCart(widget.controller.cart[index]);
                setState(() {
                  calculateTotal();
                });
              },
            ),
          ),
          SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            child: AddToCartButton(
              trolley: Icon(Icons.shopping_cart_checkout),
              text: Text(
                "Next \$${total.toStringAsFixed(2)} ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              check: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              borderRadius: BorderRadius.circular(24),
              backgroundColor: Color(0xFF40A944),
              onPressed: (id) {
                getQrdata();

                if (id == AddToCartButtonStateId.idle) {
                  getQrdata();
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 300,
                        padding: EdgeInsets.all(defaultPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "QR Code",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      QrImageView(
                                        data: qrData,
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ),
                                      SizedBox(height: 15),
                                      SizedBox(height: 30),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  setState(() {
                    stateId = AddToCartButtonStateId.loading;
                    Future.delayed(Duration(seconds: 3), () {
                      setState(() {
                        stateId = AddToCartButtonStateId.done;
                      });
                    });
                  });
                } else if (id == AddToCartButtonStateId.done) {
                  setState(() {
                    stateId = AddToCartButtonStateId.idle;
                  });
                }
              },
              stateId: stateId,
            ),
          ),
        ],
      ),
    );
  }
}
