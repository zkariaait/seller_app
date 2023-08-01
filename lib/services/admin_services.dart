import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_qr/auth/services/auth_service.dart';
import 'package:store_qr/constants/error_handling.dart';
import 'package:store_qr/constants/global_variables.dart';
import 'package:store_qr/constants/utils.dart';
import 'package:store_qr/models/productt.dart';
import 'package:store_qr/providers/user_provider.dart';

import '../models/rating.dart';

class AdminServices {
  AuthService authService = new AuthService();
  Future<List<Productt>> fetchAllProducts() async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Productt> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/products/seller/161'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'x-auth-token': userProvider.user.token,
      });
      print(res.body);

      httpErrorHandle(
        response: res,
        //context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            //   print('0$jsonDecode(res.body)');
            productList.add(
              Productt.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
    //  print('aaa$productList');

    return productList;
  }

  Future<String> sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required List<File> images,
    required List<Rating>? rating,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      //  print('0$images');
      final cloudinary = CloudinaryPublic('dm32ciz26', 'hhryfvyn');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Productt product = Productt(
          name: name,
          description: description,
          quantity: quantity,
          images: imageUrls,
          category: category,
          price: price,
          manufacturer: ' ',
          rating: [],
          isLiked: false);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = await prefs.getString('x-auth-token');
      print('TOOKEEEN$token');
      http.Response res = await http.post(
        Uri.parse('$uri/products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': '$token',
        },
        body: product.toJson(),
      );
      String productId = await res.body;

      print('object${res.statusCode}');

      if (res.statusCode == 202) {
        String productId = await res.body;
        print('productId$productId');
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Product Added Successfully!',
            message: '',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        return productId;
      }

      httpErrorHandle(
        response: res,
        //context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully!');

          Navigator.pop(context);
          //Navigator.pushNamed(context, '/home');
        },
      );
      return productId;
    } catch (e) {
      //  showSnackBar(context, e.toString());
      return '0';
    }
  }

  void deleteProduct({
    required BuildContext context,
    required Productt product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var a = product.id;
      print('object:$a');
      http.Response res = await http.delete(
        Uri.parse('$uri/product/$a'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          //  'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );
      int aa = res.statusCode;
      print('0object0 :$aa');

      httpErrorHandle(
        response: res,
        //context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Productt>> fetchLikedProducts() async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Productt> productList = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('x-auth-token');
    try {
      http.Response res = await http.get(Uri.parse('$uri/liked'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': token!,
      });
      print(res.body);

      httpErrorHandle(
        response: res,
        //context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            print('0$jsonDecode(res.body)');
            productList.add(
              Productt.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
    print('aaa$productList');

    return productList;
  }

  void LikeProduct({
    // required BuildContext context,
    required String id,
    // required VoidCallback onSuccess,
  }) async {
    //  final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var a = id;
      print('object:$a');
      http.Response res = await http.put(
        Uri.parse('$uri/like/$a'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': id,
        }),
      );
      int aa = res.statusCode;
      print('0object0 :$aa');

      httpErrorHandle(
        response: res,
        //context: context,
        onSuccess: () {
          //  onSuccess();
        },
      );
    } catch (e) {
      // showSnackBar(context, e.toString());
    }
  }
}
