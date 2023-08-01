import 'package:flutter/material.dart';
import 'package:store_qr/models/Product.dart';
import 'package:store_qr/models/ProductItem.dart';

enum HomeState { normal, cart }

class HomeController extends ChangeNotifier {
  HomeState homeState = HomeState.normal;

  List<ProductItem> cart = [];
  //List<ProductItem> cart = [];

  void changeHomeState(HomeState state) {
    homeState = state;
    notifyListeners();
  }

  void addProductToCart(Product product) {
    for (ProductItem item in cart) {
      if (item.product!.title == product.title) {
        item.increment();
        notifyListeners();
        return;
      }
    }
    cart.add(ProductItem(product: product));
    notifyListeners();
  }

  int totalCartItems() => cart.fold(
      0, (previousValue, element) => previousValue + element.quantity);

  void addProductToCart0(ProductItem product) {
    for (ProductItem item in cart) {
      if (item.product!.title == product.product!.title) {
        item.increment();
        notifyListeners();
        return;
      }
    }
    cart.add(product);
    notifyListeners();
  }

  void removeFromCart(ProductItem product) {
    cart.remove(product);
    notifyListeners();
  }
}
