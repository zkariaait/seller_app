import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:store_qr/screens/home/components/NavBar.dart';
import '../../../constants.dart';
import '../../../models/Product.dart';
import '../../../models/productt.dart';
import '../../../services/admin_services.dart';

class HomeHeader extends StatefulWidget {
  final Function(String) onSearchQueryChanged;
  final Function(String) onSubmitted;
  final Function() onLikeButtonTapped;

  const HomeHeader({
    Key? key,
    required this.onSearchQueryChanged,
    required this.onSubmitted,
    required this.onLikeButtonTapped,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool isDrawerOpen = false;
  final TextEditingController productNameController = TextEditingController();
  final ValueNotifier<String> searchQueryNotifier = ValueNotifier('');

  List<Productt>? products;
  List<Product>? demo_products;
  List<Product>? searchedProducts;

  final AdminServices adminServices = AdminServices();

  Future<void> fetchAllProducts() async {
    products = await adminServices.fetchAllProducts();
    demo_products = products!.map((product) {
      return Product(
        title: product.name,
        description: product.description,
        price: product.price,
        image: product.images.first,
      );
    }).toList();
  }

  Future<void> fetchLikedProducts() async {
    products = await adminServices.fetchLikedProducts();
    demo_products = products!.map((product) {
      return Product(
        title: product.name,
        description: product.description,
        price: product.price,
        image: product.images.first,
      );
    }).toList();
  }

  // Future<bool> onLikeButtonTapped(bool isLiked) async {
  //   if (isLiked == true) {
  //     fetchAllProducts();
  //   }

  //   return !isLiked;
  // }
  void onLikeButtonTapped() async {
    fetchLikedProducts();

    //  return !isLiked;
  }

  List<Product> getFilteredProducts(String searchedQuery) {
    try {
      RegExp pattern = RegExp(searchedQuery, caseSensitive: false);
      List<Product> filteredProducts = demo_products!
          .where((product) => pattern.hasMatch(product.title!))
          .toList();
      filteredProducts.forEach((element) {
        //  print(element.title);
      });
      return filteredProducts;
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  void updateSearchedProducts(String searchedQuery) {
    setState(() {
      if (searchedQuery.isEmpty) {
        searchedProducts = [];
      } else {
        searchedProducts = getFilteredProducts(searchedQuery);
      }
    });
    widget.onSearchQueryChanged(searchedQuery);
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts();

    // Add a listener to the text field controller
    productNameController.addListener(() {
      searchQueryNotifier.value = productNameController.text;
    });

    // Add a listener to the search query notifier
    searchQueryNotifier.addListener(() {
      updateSearchedProducts(searchQueryNotifier.value);
    });
  }

  @override
  void dispose() {
    productNameController.dispose();
    searchQueryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: headerHeight,
      color: Colors.white,
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                setState(() {
                  isDrawerOpen = !isDrawerOpen;
                });
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: productNameController,
                onChanged: (value) => widget.onSearchQueryChanged(value),
                onSubmitted: (value) => widget.onSubmitted(value),
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          // LikeButton(
          //   isLiked: true,
          //   onTap: (isLiked) {
          //     setState(() {
          //       widget.onLikeButtonTapped(isLiked);
          //     });
          //   },
          // ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.onLikeButtonTapped();
              });
            },
            icon: Icon(Icons.favorite_border),
          ),
          // NavBar(),
        ],
      ),
    );
  }
}
