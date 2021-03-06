import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shophut/providers/cart.dart';
import 'package:shophut/providers/orders.dart';
import 'package:shophut/widgets/cartItem.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final cartItemsList = cartData.items.values.toList();
    final totalInCart = cartData.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL:-  ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    label: Text(totalInCart.toStringAsFixed(2)),
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                            cartItemsList,
                            totalInCart); //we dont want to listen to the changes in orders
                        cartData.clear();
                      },
                      child: Text('ORDER NOW'))
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) {
              return CartItemWidget(
                  id: cartItemsList[i].id,
                  title: cartItemsList[i].title,
                  quantity: cartItemsList[i].quantity,
                  price: cartItemsList[i].price);
            },
            itemCount: cartData.itemsCount,
          ))
        ],
      ),
    );
  }
}
