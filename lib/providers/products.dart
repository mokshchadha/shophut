import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

final FIREBASE_URL = Uri.parse(
    'https://quick-heaven-344723-default-rtdb.firebaseio.com/products.json');

final URLToAId = (id) =>
    'https://quick-heaven-344723-default-rtdb.firebaseio.com/products/$id.json';

class Products with ChangeNotifier {
  List<Product> _items = [];

  // bool _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((item) => item.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouritesItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnlyTrue() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showFavoritesOnlyFalse() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndStoreProduct() async {
    final request = await http.get(FIREBASE_URL);
    final extractedData = json.decode(request.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    extractedData.forEach((key, value) {
      print(key);
      print(value);
      loadedProducts.add(Product(
          id: key,
          description: value['description'],
          title: value['title'],
          price: value['price'],
          imageUrl: value['imageUrl'] != "" && value['imageUrl'].length > 0
              ? value['imageUrl']
              : 'https://comnplayscience.eu/app/images/notfound.png',
          isFavorite: value['isFavorite'] ?? false));
      _items = loadedProducts;
    });
    notifyListeners();
    return Future.value();
  }

  Future<void> addProduct(Product product) {
    return http
        .post(FIREBASE_URL,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl.toString(),
              'isFavorite': product.isFavorite
            }))
        .then((response) {
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  void editProduct(String id, Product updatedProduct) {
    //editing logic
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = URLToAId(id);
      _items[prodIndex] = updatedProduct;
      http.patch(Uri.parse(url),
          body: json.encode({
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'imageUrl': updatedProduct.imageUrl,
            'price': updatedProduct.price,
          }));
    }
    notifyListeners();
  }

  void deleteItems(String id) {
    int idx = _items.indexWhere((e) => e.id == id);
    var itemToBeDeleted = _items[idx];
    _items.removeWhere((element) => element.id == id);
    //optimistic delete
    http
        .delete(Uri.parse(URLToAId(id)))
        .then((response) => {
              if (response.statusCode >= 400)
                {
                  throw HttpException(
                      'Custom Error, because http.delete does not handle the error automatically like get or post')
                }
            })
        .catchError(() {
      _items.add(itemToBeDeleted);
    });
    notifyListeners();
  }
}
