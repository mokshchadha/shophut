import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shophut/providers/cart.dart';

final ORDERS_URL = Uri.parse(
    'https://quick-heaven-344723-default-rtdb.firebaseio.com/orders.json');

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [
      ..._orders
    ]; //spreading it so that we dont edit the orders object by reference
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final response = await http.post((ORDERS_URL),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((e) => json.encode({
                    'id': e.id,
                    'quantity': e.quantity,
                    'title': e.title,
                    'price': e.price
                  }))
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp));
    notifyListeners();
  }
}
