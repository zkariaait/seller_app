import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:file_picker/file_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/src/foundation/key.dart' as flutter_key;
import 'package:store_qr/auth/widgets/custom_button.dart';
import 'package:store_qr/auth/widgets/custom_textfield.dart';
import 'package:store_qr/constants/global_variables.dart';
import 'package:store_qr/screens/home/components/header.dart';

import '../constants.dart';
import '../constants/utils.dart';
import '../models/Product.dart';
import '../models/productt.dart';
import '../services/admin_services.dart';
import 'home/components/NavBar.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({flutter_key.Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  List<Productt>? products;
  List<Product>? demo_products;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _productName = '';
  String _productDescription = '';
  double _productPrice = 0.0;
  int _productquantity = 0;

  // Add more fields as needed

  String category = 'MOBILES'; // Updated enum constant
  List<File> images = [];

  final _addProductFormKey = GlobalKey<FormState>();

  String qrCodeData = '';
  bool test = false;
  void updateFilteredProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        demo_products = products!.map((product) {
          return Product(
            title: product.name,
            description: product.description,
            price: product.price,
            image: product.images.first,
          );
        }).toList();
      } else {
        demo_products = getFilteredProducts(query.toLowerCase());
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

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the form data
      // Add your logic here
    }
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  List<String> productCategories = [
    'MOBILES',
    'FURNITURE',
    'ELECTRONICS',
    'BOOKS',
    'CLOTHING'
  ];
  Future<void> sellProduct() async {
    print(2);
    String a = await adminServices.sellProduct(
      context: context,
      name: productNameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      quantity: int.parse(quantityController.text),
      category: category,
      images: images,
      rating: [],
    );
    print(3);

    print('a: $a');
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HomeHeader(
              onSearchQueryChanged: updateFilteredProducts,
              onSubmitted: updateFilteredProducts, onLikeButtonTapped: () {},
              // searchController: _searchController,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        images.isNotEmpty
                            ? CarouselSlider(
                                items: images.map(
                                  (i) {
                                    return Builder(
                                      builder: (BuildContext context) =>
                                          Image.file(
                                        i,
                                        fit: BoxFit.cover,
                                        height: 200,
                                      ),
                                    );
                                  },
                                ).toList(),
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  height: 200,
                                ),
                              )
                            : GestureDetector(
                                onTap: selectImages,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.image,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          'Select Product Images',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 30),

                        SizedBox(height: 20),
                        TextFormField(
                          controller: productNameController,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            labelText: 'Product Name',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a product name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _productName = value;
                            });
                          },
                        ),

                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(fontSize: 18),
                          controller: priceController,
                          decoration: InputDecoration(
                            labelText: 'Product Price',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a product price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _productPrice = double.tryParse(value) ?? 0.0;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(fontSize: 18),
                          controller: quantityController,
                          decoration: InputDecoration(
                            labelText: 'Product Quantity',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the quantity';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid quantity';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _productquantity = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(fontSize: 18),
                          controller: descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Product Description',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a product description';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _productDescription = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Color.fromARGB(159, 21, 20, 20),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton(
                              value: category,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              underline: SizedBox(),
                              items: productCategories.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newVal) {
                                setState(() {
                                  category = newVal!;
                                });
                              },
                              dropdownColor: Colors.white,
                              isExpanded: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 1500),

                        // Add more form fields as needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: sellProduct,
        label: Text('Add a Product'),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFF40A944),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
