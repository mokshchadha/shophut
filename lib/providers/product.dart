import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final URLToAId = (id) =>
    'https://quick-heaven-344723-default-rtdb.firebaseio.com/products/$id.json';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    http.patch(Uri.parse(URLToAId(id)),
        body: json.encode({'isFavorite': isFavorite}));
    notifyListeners();
  }
}
