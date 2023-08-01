import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:store_qr/models/productt.dart';
import 'package:store_qr/screens/home/components/NavBar.dart';
import 'package:store_qr/constants.dart';
import 'package:store_qr/models/Product.dart';
import 'package:store_qr/models/ProductItem.dart';
import 'package:store_qr/screens/details/details_screen.dart';
import 'package:store_qr/screens/home/components/cart_details_view.dart';
import 'package:store_qr/screens/home/components/cart_short_view.dart';
import 'package:store_qr/screens/home/controllers/home_controller.dart';
import 'package:store_qr/screens/home/components/header.dart';
import 'package:store_qr/screens/home/components/product_card.dart';
import 'package:store_qr/services/admin_services.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = HomeController();
  List<Productt>? products;
  List<Product>? demo_products;

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  final AdminServices adminServices = AdminServices();
  void updateLikeButtonTapped() {
    fetchLikedProducts();
  }

  Future<void> fetchAllProducts() async {
    products = await adminServices.fetchAllProducts();
    products!.forEach((element) {
      if (element.isLiked == null) {
        element.isLiked = false;
      }
    });
    setState(() {
      demo_products = products!.map((product) {
        return Product(
            id: product.id,
            title: product.name,
            description: product.description,
            price: product.price,
            image: product.images.first,
            isLiked: product.isLiked);
      }).toList();
    });
    demo_products!.forEach((element) {
      print('${element.id} : ${element.isLiked}');
    });
  }

  Future<void> fetchLikedProducts() async {
    List<Productt> likedproducts = [];

    products = await adminServices.fetchAllProducts();
    products!.forEach((element) {
      if (element.isLiked == true) likedproducts.add(element);
    });
    setState(() {
      demo_products = likedproducts!.map((product) {
        return Product(
            id: product.id,
            title: product.name,
            description: product.description,
            price: product.price,
            image: product.images.first,
            isLiked: product.isLiked);
      }).toList();
      print(products!.length);
    });
    demo_products!.forEach((element) {
      print('${element.id} : ${element.isLiked}');
    });
  }

  void updateFilteredProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        print(1);
        demo_products = products!.map((product) {
          return Product(
              id: product.id,
              title: product.name,
              description: product.description,
              price: product.price,
              image: product.images.first,
              isLiked: product.isLiked);
        }).toList();
      } else {
        print(2);
        print('query$query');
        //updateFilteredProducts(query);
        demo_products = getFilteredProducts(query.toLowerCase());
        print(demo_products);
      }
    });
  }

  List<Product> getFilteredProducts(String searchedQuery) {
    try {
      List<Product> filteredProducts = demo_products!
          .where((product) => product.title!
              .toLowerCase()
              .contains(searchedQuery.toLowerCase()))
          .toList();
      return filteredProducts;
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  void _onVerticalGesture(DragUpdateDetails details) {
    if (details.primaryDelta! < -0.7) {
      controller.changeHomeState(HomeState.cart);
    } else if (details.primaryDelta! > 12) {
      controller.changeHomeState(HomeState.normal);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (demo_products == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return FutureBuilder<void>(
      // future: fetchAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
            drawer: NavBar(),
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Container(
                color: Color(0xFFEAEAEA),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return LayoutBuilder(
                      builder: (context, BoxConstraints constraints) {
                        return Stack(
                          children: [
                            AnimatedPositioned(
                              duration: panelTransition,
                              top: controller.homeState == HomeState.normal
                                  ? headerHeight
                                  : -(constraints.maxHeight -
                                      cartBarHeight * 2 -
                                      headerHeight),
                              left: 0,
                              right: 0,
                              height: constraints.maxHeight -
                                  headerHeight -
                                  cartBarHeight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(defaultPadding * 1.5),
                                    bottomRight:
                                        Radius.circular(defaultPadding * 1.5),
                                  ),
                                ),
                                child: GridView.builder(
                                  itemCount: demo_products!.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    mainAxisSpacing: defaultPadding,
                                    crossAxisSpacing: defaultPadding,
                                  ),
                                  itemBuilder: (context, index) =>
                                      FocusedMenuHolder(
                                    onPressed: () {},
                                    menuWidth: 50,
                                    blurSize: 5.0,
                                    menuItemExtent: 45,
                                    menuBoxDecoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(defaultPadding * 10)),
                                    ),
                                    duration: const Duration(milliseconds: 10),
                                    animateMenuItems: true,
                                    blurBackgroundColor: Colors.black54,
                                    openWithTap: true,
                                    menuItems: [
                                      FocusedMenuItem(
                                        title: Text('Option 1'),
                                        onPressed: () {},
                                      ),
                                      FocusedMenuItem(
                                        title: Text('Option 2'),
                                        onPressed: () {},
                                      ),
                                      // Add more menu options as needed
                                    ],
                                    child: FocusedMenuHolder(
                                      menuOffset: 5,
                                      menuWidth: 190,
                                      animateMenuItems: true,
                                      duration:
                                          const Duration(milliseconds: 10),
                                      blurBackgroundColor: Colors.black54,
                                      menuBoxDecoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                defaultPadding * 1.25)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 100),
                                            reverseTransitionDuration:
                                                const Duration(
                                                    milliseconds: 100),
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                FadeTransition(
                                              opacity: animation,
                                              child: DetailsScreen(
                                                product: demo_products![index],
                                                onProductAdd: (quantity) {
                                                  controller.addProductToCart0(
                                                    ProductItem(
                                                      product:
                                                          demo_products![index],
                                                      quantity: quantity,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      menuItems: [
                                        FocusedMenuItem(
                                            title: Text('Add to cart'),
                                            trailingIcon:
                                                Icon(Icons.shopping_cart),
                                            onPressed: () {
                                              controller.addProductToCart0(
                                                ProductItem(
                                                  product:
                                                      demo_products![index],
                                                  quantity: 1,
                                                ),
                                              );
                                            }),
                                        FocusedMenuItem(
                                            title: Text('Add to Favorite'),
                                            trailingIcon:
                                                Icon(Icons.favorite_rounded),
                                            onPressed: () {}),
                                        FocusedMenuItem(
                                            title: Text('Delete'),
                                            backgroundColor: Colors.red,
                                            trailingIcon:
                                                Icon(Icons.delete_sweep_sharp),
                                            onPressed: () {})
                                      ],
                                      child: ProductCard(
                                        product: demo_products![index],
                                        press: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 500),
                                              reverseTransitionDuration:
                                                  const Duration(
                                                      milliseconds: 500),
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  FadeTransition(
                                                opacity: animation,
                                                child: DetailsScreen(
                                                  product:
                                                      demo_products![index],
                                                  onProductAdd: (quantity) {
                                                    controller
                                                        .addProductToCart0(
                                                      ProductItem(
                                                        product: demo_products![
                                                            index],
                                                        quantity: quantity,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: panelTransition,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: controller.homeState == HomeState.normal
                                  ? cartBarHeight
                                  : (constraints.maxHeight - cartBarHeight),
                              child: GestureDetector(
                                onVerticalDragUpdate: _onVerticalGesture,
                                child: Container(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  color: Color(0xFFEAEAEA),
                                  alignment: Alignment.topLeft,
                                  child: AnimatedSwitcher(
                                    duration: panelTransition,
                                    child: controller.homeState ==
                                            HomeState.normal
                                        ? CardShortView(controller: controller)
                                        : CartDetailsView(
                                            controller: controller),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: panelTransition,
                              top: controller.homeState == HomeState.normal
                                  ? 0
                                  : -headerHeight,
                              right: 0,
                              left: 0,
                              height: headerHeight,
                              child: HomeHeader(
                                onSearchQueryChanged: updateFilteredProducts,
                                onSubmitted: updateFilteredProducts,
                                onLikeButtonTapped: updateLikeButtonTapped,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
